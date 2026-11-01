import 'package:bunpod/bunpod.dart';
import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
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

  late final FeedHeaderController _header = FeedHeaderController(
    tabController: _tabController,
  );

  Episode? _playing;

  @override
  void initState() {
    super.initState();
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      locator<FeedCubit>().setChannelId(_tabs[_tabController.index]?.id);
      _header.sync();
    });
    locator<FeedCubit>().setChannelId(null);
    _playing =
        locator<PreferencesLocalData>().lastEpisode ??
        _firstPlaying(locator<FeedCubit>().state);
  }

  @override
  void dispose() {
    _header.dispose();
    _tabController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FeedAppBar(),
      body: Stack(
        children: [
          FeedPages(
            header: _header,
            tabs: _tabs,
            onFeed: _pickPlaying,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FeedHeader(
              header: _header,
              tabs: _tabs,
              channels: widget.channels,
              suggested: _playing,
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: BottomPadding.of(context),
            child: FeedDockedPlayer(
              header: _header,
              suggested: _playing,
            ),
          ),
        ],
      ),
    );
  }
}
