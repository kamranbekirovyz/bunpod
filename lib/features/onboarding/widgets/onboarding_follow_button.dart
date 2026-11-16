import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingFollowButton extends StatelessWidget {
  const OnboardingFollowButton({
    super.key,
    required this.followPicksCubit,
  });

  final FollowPicksCubit followPicksCubit;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Align(
      alignment: .bottomCenter,
      child: Padding(
        padding: .fromLTRB(
          24,
          40,
          24,
          BottomPadding.of(context),
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
                final bool ready = count > 0;

                return BlocBuilder<FollowPicksCubit, bool?>(
                  bloc: followPicksCubit,
                  builder: (context, state) {
                    final bool busy = state == null;

                    return ExpressiveActionButton(
                      label: switch (count) {
                        0 => 'Pick a show to continue',
                        1 => 'Follow 1 show',
                        _ => 'Follow $count shows',
                      },
                      busy: busy,
                      onTap: ready ? followPicksCubit.follow : null,
                      background: ready
                          ? cs.primary
                          : cs.surfaceContainerHighest,
                      foreground: ready ? cs.onPrimary : cs.onSurfaceVariant,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
