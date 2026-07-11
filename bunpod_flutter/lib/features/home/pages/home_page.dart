import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final List<String?> _tabValues = _buildTabValues();

  late final TabController _tabController = TabController(
    length: _tabValues.length,
    vsync: this,
    animationDuration: const Duration(milliseconds: 220),
  );

  String? _channel;

  late Episode _playing = mockEpisodes.firstWhere(
    (e) => e.playing,
    orElse: () => mockEpisodes.first,
  );

  void _openPlayer() {
    Navigator.of(context).push(PlayerPage.route(_playing));
  }

  static List<String?> _buildTabValues() {
    final Set<String> seen = <String>{};
    final List<String?> values = <String?>[null];
    for (final Episode e in mockEpisodes) {
      if (seen.add(e.channel)) values.add(e.channel);
    }
    return values;
  }

  @override
  void initState() {
    super.initState();
    _tabController.animation!.addListener(_syncChannelToTab);
  }

  void _syncChannelToTab() {
    final String? value = _tabValues[_tabController.animation!.value.round()];
    if (value != _channel) setState(() => _channel = value);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    final List<FilterTab> tabs = <FilterTab>[
      FilterTab(
        value: null,
        label: 'All',
        accent: cs.primary,
        onAccent: cs.onPrimary,
        icon: Icons.grid_view_rounded,
      ),
    ];

    for (final String? value in _tabValues) {
      if (value == null) continue;
      final Episode e = mockEpisodes.firstWhere((e) => e.channel == value);
      final ColorScheme scheme = e.scheme(context);

      tabs.add(
        FilterTab(
          value: e.channel,
          label: e.channel,
          accent: scheme.primary,
          onAccent: scheme.onPrimary,
          image: e.image,
          shape: ShapeValues.coverFocused,
        ),
      );
    }

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: HomeAppBar(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerScrolled) {
          return [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  24.gap,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: _openPlayer,
                      child: PlayerCard(
                        scheme: _playing.scheme(context),
                        imageUrl: _playing.image,
                        channel: _playing.channel,
                        title: _playing.title,
                        progress: _playing.progress,
                        timeLeft: _playing.total - _playing.listened,
                        coverShape: ShapeValues.coverFocused,
                        onPlayPause: () {},
                      ),
                    ),
                  ),
                  32.gap,
                ],
              ),
            ),
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverPersistentHeader(
                pinned: true,
                delegate: _PinnedTabsDelegate(
                  height: 64,
                  child: Center(
                    child: FilterTabs(
                      tabs: tabs,
                      selected: _channel,
                      onSelected: (value) {
                        // Tapping the already-selected channel a second time
                        // opens its channel page (the "All" tab is exempt).
                        if (value != null && value == _channel) {
                          final Channel? channel = channelByName(value);
                          if (channel != null) {
                            Navigator.of(
                              context,
                            ).push(ChannelPage.route(channel));
                          }
                          return;
                        }
                        final int i = _tabValues.indexOf(value);
                        if (i != -1) _tabController.animateTo(i);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          physics: const SpringPagePhysics(),
          children: [
            for (final value in _tabValues)
              Builder(builder: (context) => _buildPage(context, value)),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, String? channel) {
    final List<Episode> visible = channel == null
        ? mockEpisodes
        : mockEpisodes.where((e) => e.channel == channel).toList();

    final List<Widget> children = <Widget>[];
    bool first = true;
    for (final Bucket bucket in Bucket.values) {
      final List<Episode> eps = visible
          .where((e) => e.bucket == bucket)
          .toList();
      if (eps.isEmpty) continue;
      children.add(
        SectionHeader(
          label: _bucketLabels[bucket]!,
          count: eps.length,
          topPadding: first ? 16 : 32,
        ),
      );
      first = false;
      for (final Episode ep in eps) {
        children.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: EpisodeCard(
              episode: ep,
              playing: identical(ep, _playing),
              onTap: () {
                setState(() {
                  _playing = ep;
                });
                _openPlayer();
              },
            ),
          ),
        );
      }
    }

    return CustomScrollView(
      key: PageStorageKey(channel ?? '__all__'),
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 32),
          sliver: SliverList(delegate: SliverChildListDelegate(children)),
        ),
      ],
    );
  }
}

const _bucketLabels = <Bucket, String>{
  Bucket.today: 'Today',
  Bucket.yesterday: 'Yesterday',
  Bucket.thisWeek: 'This Week',
  Bucket.thisMonth: 'This Month',
  Bucket.earlier: 'Earlier',
};

class _PinnedTabsDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _PinnedTabsDelegate({
    required this.child,
    required this.height,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _PinnedTabsDelegate old) {
    return old.child != child || old.height != height;
  }
}
