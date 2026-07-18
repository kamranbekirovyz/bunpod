import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (details) => FriendlyErrorView(details: details);

  setupLocator();

  runApp(const App());
}
