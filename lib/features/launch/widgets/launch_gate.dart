import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// Sits at the app's root and lets the right first page through once
/// [LaunchCubit] decides. Not a page itself, so it never shows up as a
/// route, in analytics or in the back stack.
class LaunchGate extends StatefulWidget {
  const LaunchGate({super.key});

  @override
  State<LaunchGate> createState() => _LaunchGateState();
}

class _LaunchGateState extends State<LaunchGate> {
  late final LaunchCubit _launchCubit;

  @override
  void initState() {
    super.initState();
    _launchCubit = LaunchCubit()..resolve();
  }

  @override
  void dispose() {
    _launchCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LaunchCubit, LaunchDestination?>(
          bloc: _launchCubit,
          listener: (context, destination) {
            if (destination == .feed) {
              locator<ChangelogCubit>().initialize();
            }
          },
        ),
        BlocListener<ChangelogCubit, Changelog?>(
          bloc: locator<ChangelogCubit>(),
          listener: (context, changelog) {
            if (changelog == null) return;

            ChangelogSheet.show(
              context: context,
              changelog: changelog,
            );
          },
        ),
      ],
      child: BlocBuilder<LaunchCubit, LaunchDestination?>(
        bloc: _launchCubit,
        builder: (context, destination) {
          return switch (destination) {
            null => ColoredBox(
              color: Theme.of(context).colorScheme.surface,
            ),
            .welcome => const WelcomePage(),
            .feed => const FeedPage(),
          };
        },
      ),
    );
  }
}
