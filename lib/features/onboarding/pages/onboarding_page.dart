import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  static Future<bool?> show(BuildContext context) {
    return Navigator.of(context).push(
      const OnboardingPage().asAdaptiveSheetRoute<bool>(
        dismissible: false,
      ),
    );
  }

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const int _minPicks = 3;

  late final TrendingCubit _trendingCubit;
  late final FollowPicksCubit _followPicksCubit;

  @override
  void initState() {
    super.initState();
    _trendingCubit = TrendingCubit()..load();
    _followPicksCubit = FollowPicksCubit();
  }

  @override
  void dispose() {
    _trendingCubit.close();
    _followPicksCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FollowPicksCubit, bool?>(
      bloc: _followPicksCubit,
      listener: (context, followed) {
        if (followed == true) {
          HapticsHelper.success();
          Navigator.of(context).pop(true);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: .fromLTRB(
                    24,
                    TopPadding.of(context) + 24,
                    24,
                    24,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: OnboardingHeader(
                      minPicks: _minPicks,
                    ),
                  ),
                ),
                BlocBuilder<TrendingCubit, List<ChannelPreview>?>(
                  bloc: _trendingCubit,
                  builder: (context, trending) {
                    return OnboardingShowGrid(
                      shows: trending,
                      followPicksCubit: _followPicksCubit,
                      minPicks: _minPicks,
                    );
                  },
                ),
                // Clearance so the last row scrolls out from under the CTA.
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 132 + BottomPadding.of(context),
                  ),
                ),
              ],
            ),
            OnboardingFollowButton(
              minPicks: _minPicks,
              followPicksCubit: _followPicksCubit,
            ),
          ],
        ),
      ),
    );
  }
}
