import 'package:material_ui/material_ui.dart';

class AppResumeListener extends StatefulWidget {
  const AppResumeListener({
    super.key,
    required this.onResume,
    required this.child,
  });

  final VoidCallback onResume;
  final Widget child;

  @override
  State<AppResumeListener> createState() => _AppResumeListenerState();
}

class _AppResumeListenerState extends State<AppResumeListener> {
  late final AppLifecycleListener _listener;
  bool _hidden = false;

  @override
  void initState() {
    super.initState();

    _listener = AppLifecycleListener(
      onHide: () => _hidden = true,
      onShow: () {
        // Shade only makes it inactive.
        if (!_hidden) return;

        _hidden = false;
        widget.onResume();
      },
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
