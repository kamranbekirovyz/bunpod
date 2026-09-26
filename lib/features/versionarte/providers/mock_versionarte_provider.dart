import 'package:bunpod/bunpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:versionarte/versionarte.dart';

/// Which version check result the mock returns.
enum MockVersionarteScenario {
  /// Nothing on screen.
  upToDate,

  /// [UpdateAvailableNotice] drops in from the top.
  optionalUpdate,

  /// [ForceUpdatePage] covers the app.
  forcedUpdate,

  /// [AppUnavailablePage] covers the app.
  unavailable,
}

// Uncomment one, then hot restart.

const MockVersionarteScenario _scenario = .upToDate;
// const MockVersionarteScenario _scenario = .optionalUpdate;
// const MockVersionarteScenario _scenario = .forcedUpdate;
// const MockVersionarteScenario _scenario = .unavailable;

/// Builds the manifest relative to the running version, so pubspec bumps
/// don't change the scenario.
class MockVersionarteProvider extends VersionarteProvider {
  const MockVersionarteProvider();

  @override
  Future<DistributionManifest?> getDistributionManifest() async {
    await Future<void>.delayed(AppValues.mockDelay);

    final PackageInfo info = await Versionarte.packageInfo;

    final String current = info.version;
    final String next = _bumpMinor(current);

    final (String minimum, String latest, bool active) = switch (_scenario) {
      MockVersionarteScenario.upToDate => (current, current, true),
      MockVersionarteScenario.optionalUpdate => (current, next, true),
      MockVersionarteScenario.forcedUpdate => (next, next, true),
      MockVersionarteScenario.unavailable => (current, current, false),
    };

    final PlatformDistributionInfo distribution = PlatformDistributionInfo(
      downloadUrl: _mockStoreUrl,
      version: VersionDetails(minimum: minimum, latest: latest),
      status: StatusDetails(
        active: active,
        message: const <String, String>{
          'en': 'Back in a few minutes. Everything you saved is safe.',
        },
      ),
    );

    return DistributionManifest(
      android: distribution,
      iOS: distribution,
    );
  }

  static const String _mockStoreUrl = 'https://bunpod.app';

  /// `1.4.2` -> `1.5.0`.
  static String _bumpMinor(String version) {
    final List<String> parts = version.split('.');

    if (parts.length != 3) return version;

    final int? major = int.tryParse(parts[0]);
    final int? minor = int.tryParse(parts[1]);

    if (major == null || minor == null) return version;

    return '$major.${minor + 1}.0';
  }
}
