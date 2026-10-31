import 'package:bunpod/bunpod.dart';
import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:expressive_refresh_indicator/expressive_refresh_indicator.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool _onboardingShown = false;

  @override
  void initState() {
    super.initState();
    _load();

    locator<UserCubit>().load();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      logarte.attach(
        context: context,
        visible: false,
      );
    });
  }

  Future<void> _load() => locator<SubscriptionsCubit>().load();

  Future<void> _showOnboarding() async {
    _onboardingShown = true;

    final bool? followed = await OnboardingPage.show(context);

    if (followed == true) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return BlocConsumer<SubscriptionsCubit, List<Channel>?>(
      bloc: locator<SubscriptionsCubit>(),
      listener: (context, channels) {
        if (channels != null && channels.isEmpty && !_onboardingShown) {
          _showOnboarding();
        }
      },
      builder: (context, channels) {
        if (channels != null && channels.isNotEmpty) {
          return _FeedView(
            key: ValueKey<String>(channels.map((p) => p.id).join('|')),
            channels: channels,
          );
        }

        return Scaffold(
          backgroundColor: cs.surface,
          appBar: FeedAppBar(),
          body: Center(
            child: channels == null
                ? LoadingIndicator()
                : TextButton(
                    onPressed: _showOnboarding,
                    child: const Text('Pick some shows'),
                  ),
          ),
        );
      },
    );
  }
}

class _FeedView extends StatefulWidget {
  const _FeedView({super.key, required this.channels});

  final List<Channel> channels;

  @override
  State<_FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<_FeedView> with TickerProviderStateMixin {
  late final List<Channel?> _tabs = [null, ...widget.channels];

  late final TabController _tabController = TabController(
    length: _tabs.length,
    vsync: this,
    animationDuration: const Duration(milliseconds: 220),
  );

  Channel? _selected;

  Episode? _playing;

  @override
  void initState() {
    super.initState();
    _tabController.animation!.addListener(_syncTab);
    locator<FeedCubit>().load();
    _playing =
        locator<PreferencesLocalData>().lastEpisode ??
        _firstPlaying(locator<FeedCubit>().state);
  }

  Episode? _firstPlaying(Feed? feed) {
    final List<Episode>? episodes = feed?.episodes;

    if (episodes == null || episodes.isEmpty) return null;

    return episodes.firstWhere(
      (e) => e.listened > Duration.zero && e.progress < 1,
      orElse: () => episodes.first,
    );
  }

  void _pickPlaying(Feed? feed) {
    final Episode? fresh = feed?.episodes
        .where((episode) => episode.id == _playing?.id)
        .firstOrNull;

    setState(() => _playing = fresh ?? _playing ?? _firstPlaying(feed));
  }

  void _syncTab() {
    final Channel? channel = _tabs[_tabController.animation!.value.round()];

    if (channel == _selected) return;

    HapticsHelper.selection();
    setState(() => _selected = channel);
    locator<FeedCubit>().load(channelId: channel?.id);
  }

  Future<void> _refresh() {
    return locator<FeedCubit>().load(channelId: _selected?.id);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FeedAppBar(),
      body: ExpressiveRefreshIndicator(
        onRefresh: _refresh,
        // Inside NestedScrollView the drag comes from the inner scrollables
        // (outer -> TabBarView page -> list = depth 2), so the default
        // depth-0 predicate would never trigger.
        notificationPredicate: (notification) => notification.depth == 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerScrolled) {
            return [
              SliverToBoxAdapter(
                child: _NowPlaying(suggested: _playing),
              ),
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
                sliver: SliverPersistentHeader(
                  pinned: true,
                  delegate: FeedPinnedTabsDelegate(
                    height: 64,
                    child: Center(
                      child: FeedChannelTabs(
                        channels: widget.channels,
                        selected: _selected,
                        onSelected: (channel) {
                          // Tapping the already-selected show a second time
                          // opens its channel page (the "All" tab is exempt).
                          if (channel != null && channel == _selected) {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) {
                                  return ChannelPage(
                                    id: channel.id,
                                    preview: ChannelPreview.fromChannel(
                                      channel,
                                    ),
                                  );
                                },
                              ),
                            );
                            return;
                          }

                          _tabController.animateTo(_tabs.indexOf(channel));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: BlocConsumer<FeedCubit, Feed?>(
            bloc: locator<FeedCubit>(),
            listener: (context, feed) => _pickPlaying(feed),
            builder: (context, feed) {
              return TabBarView(
                controller: _tabController,
                physics: const SpringPagePhysics(),
                children: [
                  for (final Channel? channel in _tabs)
                    FeedEpisodeList(
                      key: PageStorageKey('${channel?.id}'),
                      feed: channel == _selected ? feed : null,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NowPlaying extends StatelessWidget {
  const _NowPlaying({required this.suggested});

  final Episode? suggested;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlayerCubit, Playback, Episode?>(
      bloc: locator<PlayerCubit>(),
      selector: (playback) => playback.episode,
      builder: (context, playing) {
        final Episode? shown = playing ?? suggested;

        if (shown == null) return 32.gap;

        return Padding(
          padding: const .fromLTRB(16, 24, 16, 32),
          child: EpisodeProgressBuilder(
            episode: shown,
            builder: (context, episode) {
              return FeedNowPlayingCard(
                episode: episode,
              );
            },
          ),
        );
      },
    );
  }
}
