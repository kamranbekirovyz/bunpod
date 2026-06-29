import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppValues.title,
      debugShowCheckedModeBanner: false,
      themeMode: .dark,
      theme: MaterialThemes.light,
      darkTheme: MaterialThemes.dark,
      home: const HomePage(),
    );
  }
}
