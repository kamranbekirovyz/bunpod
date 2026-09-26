import 'package:bunpod/bunpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:versionarte/versionarte.dart';

/// The four answers a real backend can give.
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

// ---------------------------------------------------------------------------
// Pick a scenario by moving the `//` — exactly one line stays uncommented.
// Hot restart (not hot reload) to see it, since the check runs at startup.
// ---------------------------------------------------------------------------

const MockVersionarteScenario _scenario = .upToDate;
// const MockVersionarteScenario _scenario = .optionalUpdate;
// const MockVersionarteScenario _scenario = .forcedUpdate;
// const MockVersionarteScenario _scenario = .unavailable;

/// Answers version checks without a backend, so a fresh clone can see all four
/// screens.
///
/// The manifest is built *relative to the running build's version* rather than
/// with fixed numbers, so bumping `version:` in pubspec.yaml never quietly
/// turns one scenario into another.
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
      // Below the minimum is what makes an update forced.
      MockVersionarteScenario.forcedUpdate => (next, next, true),
      MockVersionarteScenario.unavailable => (current, current, false),
    };

    final PlatformDistributionInfo distribution = PlatformDistributionInfo(
      // A real manifest owns these. Hard-coding a store URL in the app is how
      // you strand users when the listing moves to another developer account.
      downloadUrl: _mockStoreUrl,
      version: VersionDetails(minimum: minimum, latest: latest),
      status: StatusDetails(
        active: active,
        message: const <String, String>{
          'en': 'Back in a few minutes. Everything you saved is safe.',
        },
      ),
    );

    // Same answer on every platform: the mock has no reason to differ, and a
    // real manifest is where per-platform minimums belong.
    return DistributionManifest(
      android: distribution,
      iOS: distribution,
      macOS: distribution,
      windows: distribution,
      linux: distribution,
    );
  }

  static const String _mockStoreUrl = 'https://bunpod.app';

  /// `1.4.2` -> `1.5.0`. Falls back to the input when it is not a plain
  /// three-part version, which only costs the mock its scenario.
  static String _bumpMinor(String version) {
    final List<String> parts = version.split('.');

    if (parts.length != 3) return version;

    final int? major = int.tryParse(parts[0]);
    final int? minor = int.tryParse(parts[1]);

    if (major == null || minor == null) return version;

    return '$major.${minor + 1}.0';
  }
}
