import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

class SpringPagePhysics extends PageScrollPhysics {
  const SpringPagePhysics({super.parent});

  @override
  SpringPagePhysics applyTo(ScrollPhysics? ancestor) {
    return SpringPagePhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring =>
      const MaterialSpringMotion.standardSpatialDefault().description;
}
