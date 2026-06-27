import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

extension NumX on num {
  Widget get gap {
    return Gap(toDouble());
  }

  SliverGap get gapSliver {
    return SliverGap(toDouble());
  }

  SliverGap get sliverGap {
    return SliverGap(toDouble());
  }
}

extension NumXs on num? {
  String get clearPrice {
    if (this == null) return 'N/A';

    return this! % 1 == 0
        ? '${this!.toInt()} AZN'
        : '${this!.toStringAsFixed(2)} AZN'.replaceAll('.00', '');
  }
}
