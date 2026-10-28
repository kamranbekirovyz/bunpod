import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  late final ExploreTrendingCubit _trendingCubit;
  late final ExploreSearchCubit _searchCubit;

  Category? _category;

  bool get _browsing => _search.text.trim().isEmpty;

  @override
  void initState() {
    super.initState();
    _trendingCubit = ExploreTrendingCubit()..load();
    _searchCubit = ExploreSearchCubit();
    locator<ExploreCategoriesCubit>().load();
    _searchFocus.addListener(() => setState(() {}));
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

  void _openChannel(ChannelPreview show) {
    Navigator.of(
      context,
    ).push(ChannelPage.route(appleId: show.appleId, preview: show));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: const StyledBackButton(),
        title: const Text('Explore'),
      ),
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverPadding(
            padding: const .fromLTRB(16, 8, 16, 16),
            sliver: SliverToBoxAdapter(
              child: ExploreSearchField(
                controller: _search,
                focusNode: _searchFocus,
                onChanged: _onQueryChanged,
                onClear: _clearSearch,
              ),
            ),
          ),
          if (_browsing) ...[
            SliverToBoxAdapter(
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
            BlocBuilder<ExploreTrendingCubit, List<ChannelPreview>?>(
              bloc: _trendingCubit,
              builder: (context, shows) {
                return ExploreShowGrid(shows: shows, onTap: _openChannel);
              },
            ),
          ] else
            BlocBuilder<ExploreSearchCubit, List<ChannelPreview>?>(
              bloc: _searchCubit,
              builder: (context, results) {
                if (results != null && results.isEmpty) {
                  return const SliverToBoxAdapter(child: ExploreNoResults());
                }

                return ExploreShowGrid(shows: results, onTap: _openChannel);
              },
            ),
          SliverToBoxAdapter(
            child: SizedBox(height: 24 + BottomPadding.of(context)),
          ),
        ],
      ),
    );
  }
}
