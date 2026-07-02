import 'package:flutter/material.dart';

class BottomPadding extends StatelessWidget {
  const BottomPadding({super.key});

  static double of(BuildContext context) {
    final double viewPadding = MediaQuery.viewPaddingOf(context).bottom;
    final double height = viewPadding > 0 ? viewPadding : 16;

    return height;
  }

  @override
  Widget build(BuildContext context) {
    final double height = of(context);

    return SizedBox(height: height);
  }
}

class TopPadding extends StatelessWidget {
  const TopPadding({super.key});

  static double of(BuildContext context) {
    final double viewPadding = MediaQuery.viewPaddingOf(context).top;
    final double height = viewPadding > 0 ? viewPadding : 0;

    return height;
  }

  @override
  Widget build(BuildContext context) {
    final double height = of(context);

    return SizedBox(height: height);
  }
}
