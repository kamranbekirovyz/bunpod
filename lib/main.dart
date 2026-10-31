import 'package:bunpod/bootstrap.dart';
import 'package:bunpod/bunpod.dart';

Future<void> main() {
  return Bootstrap.run(() {
    return const App();
  });
}
