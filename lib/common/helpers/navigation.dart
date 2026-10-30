import 'package:material_ui/material_ui.dart';

/// Root navigator, reachable without a [BuildContext].
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

BuildContext get ctx => navigatorKey.currentContext!;
