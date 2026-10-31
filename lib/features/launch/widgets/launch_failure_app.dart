import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';

/// Shown instead of [App] when launch fails, so the user sees an
/// explanation rather than a frozen splash.
class LaunchFailureApp extends StatelessWidget {
  const LaunchFailureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MaterialThemes.light,
      home: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Scaffold(
      body: Padding(
        padding: const .symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: ShapeDecoration(
                color: cs.primaryContainer,
                shape: const StarBorder(
                  points: 12,
                  innerRadiusRatio: 0.8,
                  pointRounding: 0.7,
                  valleyRounding: 0.3,
                ),
              ),
              child: Icon(
                Icons.power_off_rounded,
                color: cs.onPrimaryContainer,
                size: 48,
              ),
            ),
            24.gap,
            Text(
              'BunPod couldn\'t start.',
              textAlign: .center,
              style: tt.titleLarge?.copyWith(fontWeight: .w600),
            ),
            12.gap,
            Text(
              'Close it from the app switcher and open it again. We\'ve '
              'been alerted and are fixing it.',
              textAlign: .center,
              style: tt.bodyLarge?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
