import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return BlocBuilder<UserCubit, User?>(
      bloc: locator<UserCubit>(),
      builder: (context, user) {
        final bool loading = user == null;
        final String? avatar = user?.avatar;

        return ShimmerScope(
          active: loading,
          child: ShimmerReveal(
            loading: loading,
            placeholder: const ShimmerPlaceholder(
              shape: RoundedRectangleBorder(),
            ),
            child: loading
                ? const SizedBox.shrink()
                : avatar == null
                ? ColoredBox(
                    color: cs.surfaceContainerHighest,
                    child: FractionallySizedBox(
                      widthFactor: 0.55,
                      heightFactor: 0.55,
                      child: FittedBox(
                        child: Icon(
                          Icons.person_rounded,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                : SmoothImage(
                    url: avatar,
                  ),
          ),
        );
      },
    );
  }
}
