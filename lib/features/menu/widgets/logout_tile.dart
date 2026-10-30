import 'package:bunpod/bunpod.dart';
import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class LogoutTile extends StatefulWidget {
  const LogoutTile({super.key});

  @override
  State<LogoutTile> createState() => _LogoutTileState();
}

class _LogoutTileState extends State<LogoutTile> {
  late final LogoutCubit _logoutCubit;

  @override
  void initState() {
    super.initState();
    _logoutCubit = LogoutCubit();
  }

  @override
  void dispose() {
    _logoutCubit.close();
    super.dispose();
  }

  Future<void> _confirm() async {
    final bool confirmed = await StyledSheet.show(
      context,
      icon: Icons.logout_rounded,
      title: 'Log out?',
      message: 'Your shows will miss you. Come back anytime.',
      confirmLabel: 'Log out',
    );

    if (confirmed) _logoutCubit.logout();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutCubit, ViewState>(
      bloc: _logoutCubit,
      listener: (_, state) {
        if (state.isReady) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(
              builder: (_) {
                return const WelcomePage(
                  returning: true,
                );
              },
            ),
            (_) => false,
          );
        }
      },
      builder: (context, state) {
        final bool busy = state is ViewBusy;

        return MenuTile(
          icon: Icons.logout_outlined,
          title: 'Log out',
          trailing: busy
              ? SizedBox.square(
                  dimension: 24,
                  child: LoadingIndicator(),
                )
              : null,
          onTap: busy ? null : _confirm,
        );
      },
    );
  }
}
