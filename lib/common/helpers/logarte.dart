import 'package:bunpod/bunpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logarte/logarte.dart';

final Logarte logarte = Logarte(
  password: 'm3e',
  ignorePassword: kDebugMode,
  onRocketLongPressed: (BuildContext context) {
    locator<ThemeModeCubit>().toggle();
  },
);
