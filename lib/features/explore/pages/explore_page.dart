import 'package:bunpod/bunpod.dart';
import 'package:bunpod/features/explore/widgets/category_card.dart';
import 'package:bunpod/features/explore/widgets/category_pill.dart';
import 'package:bunpod/features/explore/widgets/explore_search_field.dart';
import 'package:bunpod/features/explore/widgets/host_bubble.dart';
import 'package:bunpod/features/explore/widgets/result_tile.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ExplorePage());
  }

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _search = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  ExploreCategory? _category;

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  String get _query => _search.text.trim();

  bool get _browsing => _query.isEmpty && _category == null;

  void _pickCategory(ExploreCategory category) {
    setState(
      () => _category = identical(_category, category) ? null : category,
    );
  }

  void _clearCategory() {
    setState(() => _category = null);
  }

  void _clearSearch() {
    _search.clear();
    setState(() {});
  }

  void _openChannel(Channel channel) {
    Navigator.of(context).push(ChannelPage.route(channel));
  }

  /// Channels matching the active shelf and/or query. A query matches a
  /// channel's name or host directly, and matches whole shelves by name.
  List<Channel> get _results {
    final List<Channel> pool = _category?.channels ?? mockChannels;
    final String q = _query.toLowerCase();
    if (q.isEmpty) return pool;

    final Set<String> viaCategory = <String>{
      for (final ExploreCategory c in mockCategories)
        if (c.name.toLowerCase().contains(q)) ...c.channelNames,
    };

    return <Channel>[
      for (final Channel channel in pool)
        if (channel.name.toLowerCase().contains(q) ||
            channel.host.toLowerCase().contains(q) ||
            viaCategory.contains(channel.name))
          channel,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const _AppBar(),
      body: _Body(
        search: _search,
        searchFocus: _searchFocus,
        category: _category,
        browsing: _browsing,
        results: _results,
        onQueryChanged: (_) => setState(() {}),
        onClearSearch: _clearSearch,
        onPickCategory: _pickCategory,
        onClearCategory: _clearCategory,
        onOpenChannel: _openChannel,
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const StyledBackButton(),
      title: const Text('Explore'),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.search,
    required this.searchFocus,
    required this.category,
    required this.browsing,
    required this.results,
    required this.onQueryChanged,
    required this.onClearSearch,
    required this.onPickCategory,
    required this.onClearCategory,
    required this.onOpenChannel,
  });

  final TextEditingController search;
  final FocusNode searchFocus;
  final ExploreCategory? category;
  final bool browsing;
  final List<Channel> results;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<ExploreCategory> onPickCategory;
  final VoidCallback onClearCategory;
  final ValueChanged<Channel> onOpenChannel;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                ExploreSearchField(
                  controller: search,
                  focusNode: searchFocus,
                  onChanged: onQueryChanged,
                  onClear: onClearSearch,
                ),
                if (category != null) ...[
                  12.gap,
                  CategoryPill(
                    category: category!,
                    onClear: onClearCategory,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (browsing)
          ..._browseSlivers(context)
        else
          ..._resultSlivers(context),
        SliverToBoxAdapter(
          child: SizedBox(height: 24 + BottomPadding.of(context)),
        ),
      ],
    );
  }

  Widget _sectionLabel(BuildContext context, String label) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      child: Text(
        label,
        style: tt.labelMedium?.copyWith(
          color: cs.onSurfaceVariant,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  List<Widget> _browseSlivers(BuildContext context) {
    return [
      SliverToBoxAdapter(child: _sectionLabel(context, 'HOSTS ON AIR')),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 252,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              childAspectRatio: 1.32,
            ),
            itemCount: mockChannels.length,
            itemBuilder: (BuildContext context, int index) {
              final Channel channel = mockChannels[index];

              return HostBubble(
                channel: channel,
                onTap: () => onOpenChannel(channel),
              );
            },
          ),
        ),
      ),
      SliverToBoxAdapter(child: _sectionLabel(context, 'THE SHELVES')),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverList.separated(
          itemCount: mockCategories.length,
          separatorBuilder: (_, _) => 4.gap,
          itemBuilder: (BuildContext context, int index) {
            final ExploreCategory category = mockCategories[index];

            return CategoryCard(
              category: category,
              first: index == 0,
              last: index == mockCategories.length - 1,
              onTap: () => onPickCategory(category),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _resultSlivers(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    if (results.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 64, 24, 0),
            child: Column(
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 40,
                  color: cs.outline,
                ),
                12.gap,
                Text(
                  'No shows match that — yet.',
                  style: tt.bodyLarge?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        sliver: SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {
            final Channel channel = results[index];

            return ResultTile(
              channel: channel,
              onTap: () {
                onOpenChannel(channel);
              },
            );
          },
        ),
      ),
    ];
  }
}
