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
