import 'package:bunpod/bunpod.dart';
import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingFollowButton extends StatelessWidget {
  const OnboardingFollowButton({
    super.key,
    required this.minPicks,
    required this.followPicksCubit,
  });

  final int minPicks;
  final FollowPicksCubit followPicksCubit;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Align(
      alignment: .bottomCenter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: .topCenter,
            end: .bottomCenter,
            colors: [
              cs.surface.withValues(alpha: 0.0),
              cs.surface.withValues(alpha: 0.92),
              cs.surface,
            ],
            stops: const [0.0, 0.45, 0.75],
          ),
        ),
        child: Padding(
          padding: .fromLTRB(
            24,
            40,
            24,
            8 + BottomPadding.of(context),
          ),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: [
              StreamBuilder<Set<int>>(
                stream: followPicksCubit.picked$,
                initialData: followPicksCubit.picked,
                builder: (context, snapshot) {
                  final int count = snapshot.requireData.length;
                  final bool ready = count >= minPicks;

                  return BlocBuilder<FollowPicksCubit, bool?>(
                    bloc: followPicksCubit,
                    builder: (context, state) {
                      final bool busy = state == null;

                      return FilledButton(
                        onPressed: ready && !busy
                            ? followPicksCubit.follow
                            : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: cs.onPrimary,
                          minimumSize: const .fromHeight(60),
                          shape: const StadiumBorder(),
                          textStyle: tt.titleMedium?.copyWith(
                            fontWeight: .w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                        child: busy
                            ? SizedBox.square(
                                dimension: 32,
                                child: LoadingIndicator(
                                  activeIndicatorColor: cs.onSurfaceVariant,
                                ),
                              )
                            : Text(
                                !ready
                                    ? 'Pick ${minPicks - count} more '
                                          'to continue'
                                    : 'Follow $count shows',
                              ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
