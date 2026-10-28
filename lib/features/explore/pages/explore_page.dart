import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  static Future<void> show(BuildContext context) {
    return Navigator.of(context).push(
      const ExplorePage().asAdaptiveSheetRoute<void>(),
    );
  }

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _search = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  late final ExploreTrendingCubit _trendingCubit;
  late final ExploreSearchCubit _searchCubit;

  Category? _category;

  bool _scrolled = false;

  bool get _browsing => _search.text.trim().isEmpty;

  @override
  void initState() {
    super.initState();
    _trendingCubit = ExploreTrendingCubit()..load();
    _searchCubit = ExploreSearchCubit();
    locator<ExploreCategoriesCubit>().load();
  }

  @override
  void dispose() {
    _search.dispose();
    _searchFocus.dispose();
    _trendingCubit.close();
    _searchCubit.close();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    setState(() {});
    _searchCubit.search(query);
  }

  void _clearSearch() {
    _search.clear();
    _onQueryChanged('');
  }

  void _pickCategory(Category? category) {
    setState(() => _category = category);
    _trendingCubit.load(categoryId: category?.id);
  }

  bool _onScroll(ScrollUpdateNotification notification) {
    final bool scrolled = notification.metrics.pixels > 0;

    if (scrolled != _scrolled) setState(() => _scrolled = scrolled);

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Padding(
            padding: .fromLTRB(16, TopPadding.of(context) + 16, 16, 16),
            child: ExploreSearchField(
              controller: _search,
              focusNode: _searchFocus,
              scrolled: _scrolled,
              onChanged: _onQueryChanged,
              onClear: _clearSearch,
            ),
          ),
          if (_browsing)
            Padding(
              padding: const .only(bottom: 8),
              child: BlocBuilder<ExploreCategoriesCubit, List<Category>?>(
                bloc: locator<ExploreCategoriesCubit>(),
                builder: (context, categories) {
                  return ExploreCategoryChips(
                    categories: categories ?? [],
                    selected: _category,
                    onSelected: _pickCategory,
                  );
                },
              ),
            ),
          Expanded(
            child: NotificationListener<ScrollUpdateNotification>(
              onNotification: _onScroll,
              child: CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  if (_browsing)
                    BlocBuilder<ExploreTrendingCubit, List<ChannelPreview>?>(
                      bloc: _trendingCubit,
                      builder: (context, shows) {
                        return ExploreShowGrid(shows: shows);
                      },
                    )
                  else
                    BlocBuilder<ExploreSearchCubit, List<ChannelPreview>?>(
                      bloc: _searchCubit,
                      builder: (context, results) {
                        if (results != null && results.isEmpty) {
                          return const SliverToBoxAdapter(
                            child: ExploreNoResults(),
                          );
                        }

                        return ExploreShowGrid(shows: results);
                      },
                    ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 24 + BottomPadding.of(context)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
