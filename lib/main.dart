import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (details) {
    return FriendlyErrorView(
      details: details,
    );
  };

  setupLocator();

  runApp(const App());
}
