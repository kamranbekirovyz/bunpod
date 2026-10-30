import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.initials = true,
  });

  final bool initials;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, User?>(
      bloc: locator<UserCubit>(),
      builder: (context, user) {
        final bool loading = user == null;

        return ShimmerScope(
          active: loading,
          child: ShimmerReveal(
            loading: loading,
            placeholder: const ShimmerPlaceholder(
              shape: RoundedRectangleBorder(),
            ),
            child: switch (user) {
              null => const SizedBox.shrink(),
              User(:final String avatar) => SmoothImage(
                url: avatar,
              ),
              User(:final name) => _Monogram(
                name: initials ? name : null,
              ),
            },
          ),
        );
      },
    );
  }
}

class _Monogram extends StatelessWidget {
  const _Monogram({required this.name});

  final String? name;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final String? initials = _initials(name);

    return ColoredBox(
      color: cs.primaryContainer,
      child: FractionallySizedBox(
        widthFactor: 0.5,
        heightFactor: 0.5,
        child: FittedBox(
          child: initials == null
              ? Icon(
                  Icons.person_rounded,
                  color: cs.onPrimaryContainer,
                )
              : Text(
                  initials,
                  style: GoogleFonts.unbounded(
                    textStyle: tt.displayLarge,
                    fontWeight: .w700,
                    letterSpacing: -2,
                    color: cs.onPrimaryContainer,
                  ),
                ),
        ),
      ),
    );
  }

  static String? _initials(String? name) {
    final List<String> words = (name ?? '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) return null;

    final String first = words.first.characters.first;
    final String last = words.length > 1 ? words.last.characters.first : '';

    return (first + last).toUpperCase();
  }
}
