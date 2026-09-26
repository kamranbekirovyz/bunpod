import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:versionarte/versionarte.dart';

class VersionarteWrapper extends StatefulWidget {
  const VersionarteWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<VersionarteWrapper> createState() => _VersionarteWrapperState();
}

class _VersionarteWrapperState extends State<VersionarteWrapper> {
  late final VersionarteCubit _cubit;
  late final AppLifecycleListener _lifecycle;

  bool _checking = false;
  bool _noticeDismissed = false;

  @override
  void initState() {
    super.initState();

    _cubit = VersionarteCubit();
    _lifecycle = AppLifecycleListener(
      onResume: _check,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _check();
    });
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _cubit.close();
    super.dispose();
  }

  Future<void> _check() async {
    if (_checking) return;

    setState(() => _checking = true);

    try {
      await _cubit.check();
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VersionarteCubit, VersionarteResult?>(
      bloc: _cubit,
      builder: (BuildContext context, VersionarteResult? state) {
        final VersionarteStatus? status = state?.status;
        final String? latestVersion =
            state?.manifest?.currentPlatform?.version.latest;

        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            widget.child,

            if (status == .outdated && !_noticeDismissed)
              UpdateAvailableNotice(
                onUpdate: _cubit.openStore,
                onDismiss: () {
                  setState(() {
                    _noticeDismissed = true;
                  });
                },
              ),

            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 450),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _blocking(state, status, latestVersion),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _blocking(
    VersionarteResult? state,
    VersionarteStatus? status,
    String? latestVersion,
  ) {
    if (status == VersionarteStatus.inactive) {
      return AppUnavailablePage(
        key: const ValueKey<String>('versionarte-unavailable'),
        message: state?.getMessageForLanguage('en'),
        checking: _checking,
        onRetry: _check,
      );
    }

    if (status == VersionarteStatus.forcedUpdate) {
      return ForceUpdatePage(
        key: const ValueKey<String>('versionarte-force-update'),
        latestVersion: latestVersion,
        onUpdate: _cubit.openStore,
      );
    }

    // Zero-sized and pointer-transparent, so the app underneath is untouched.
    return const SizedBox.shrink(
      key: ValueKey<String>('versionarte-clear'),
    );
  }
}
