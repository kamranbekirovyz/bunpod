import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: _Body(),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const StyledBackButton(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return ListView(
      padding: .fromLTRB(
        16,
        8,
        16,
        BottomPadding.of(context),
      ),
      children: [
        const MenuHeader(),
        56.gap,
        MenuSection(
          label: 'Library',
          children: [
            MenuTile(
              icon: Icons.download_outlined,
              title: 'Downloads',
              onTap: () {
                ComingSoon.show(context);
              },
            ),
            MenuTile(
              icon: Icons.history_outlined,
              title: 'Listening history',
              onTap: () {
                ComingSoon.show(context);
              },
            ),
            MenuTile(
              icon: Icons.podcasts_outlined,
              title: 'Subscriptions',
              onTap: () {
                ComingSoon.show(context);
              },
            ),
          ],
        ),
        32.gap,
        MenuSection(
          label: 'Preferences',
          children: [
            MenuTile(
              icon: Icons.brightness_6_outlined,
              title: 'Theme',
              trailing: BlocBuilder<ThemeModeCubit, ThemeMode>(
                bloc: locator<ThemeModeCubit>(),
                builder: (context, state) {
                  final ThemeMode themeMode = state;

                  return Switch(
                    value: themeMode == .dark,
                    thumbIcon: const WidgetStateProperty<Icon?>.fromMap({
                      WidgetState.selected: Icon(Icons.dark_mode_rounded),
                      WidgetState.any: Icon(Icons.light_mode_rounded),
                    }),
                    onChanged: (_) {
                      locator<ThemeModeCubit>().toggle();
                    },
                  );
                },
              ),
            ),
            MenuTile(
              icon: Icons.notifications_outlined,
              title: 'New episode alerts',
              trailing: Switch(
                value: false,
                thumbIcon: const WidgetStateProperty<Icon?>.fromMap({
                  WidgetState.selected: Icon(Icons.check_rounded),
                  WidgetState.any: Icon(Icons.close_rounded),
                }),
                onChanged: (value) {},
              ),
            ),
          ],
        ),
        32.gap,
        MenuSection(
          label: 'Support',
          children: [
            MenuTile(
              icon: Icons.workspace_premium_outlined,
              title: 'Support the developer',
              background: cs.secondaryContainer,
              foreground: cs.onSecondaryContainer,
              onTap: () {
                ComingSoon.show(context);
              },
            ),
            MenuTile(
              icon: Icons.lightbulb_outlined,
              title: 'Suggest a feature',
              onTap: () {
                ComingSoon.show(context);
              },
            ),
            MenuTile(
              icon: Icons.alternate_email_outlined,
              title: 'Contact',
              onTap: () {
                ComingSoon.show(context);
              },
            ),
            MenuTile(
              icon: Icons.code_outlined,
              title: 'GitHub repo',
              onTap: () {
                ComingSoon.show(context);
              },
            ),
          ],
        ),
        32.gap,
        MenuSection(
          label: 'Account',
          children: [
            MenuTile(
              icon: Icons.logout_outlined,
              title: 'Log out',
              onTap: () {
                ConfirmSheet.show(
                  context,
                  icon: Icons.logout_rounded,
                  title: 'Log out?',
                  message:
                      'You can sign back in anytime. Your subscriptions '
                      'and downloads stay on this device.',
                  confirmLabel: 'Log out',
                );
              },
            ),
            MenuTile(
              icon: Icons.delete_forever_outlined,
              title: 'Delete account',
              foreground: cs.error,
              onTap: () {
                ConfirmSheet.show(
                  context,
                  icon: Icons.delete_forever_rounded,
                  title: 'Delete account?',
                  message:
                      'This permanently erases your account, subscriptions, '
                      "and listening history. This can't be undone.",
                  confirmLabel: 'Delete forever',
                  destructive: true,
                );
              },
            ),
          ],
        ),
        64.gap,
        const VersionIndicator(),
        8.gap,
        const DeveloperSignature(),
        16.gap,
      ],
    );
  }
}
