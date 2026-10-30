import 'package:bunpod/bunpod.dart';
import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class DeleteAccountTile extends StatefulWidget {
  const DeleteAccountTile({super.key});

  @override
  State<DeleteAccountTile> createState() => _DeleteAccountTileState();
}

class _DeleteAccountTileState extends State<DeleteAccountTile> {
  late final DeleteAccountCubit _deleteAccountCubit;

  @override
  void initState() {
    super.initState();
    _deleteAccountCubit = DeleteAccountCubit();
  }

  @override
  void dispose() {
    _deleteAccountCubit.close();
    super.dispose();
  }

  Future<void> _confirm() async {
    final bool confirmed = await StyledSheet.show(
      context,
      icon: Icons.delete_forever_rounded,
      title: 'Delete everything?',
      message: 'Your account, shows and history go for good. No undo button.',
      confirmLabel: 'Delete forever',
      destructive: true,
    );

    if (confirmed) {
      _deleteAccountCubit.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return BlocConsumer<DeleteAccountCubit, ViewState>(
      bloc: _deleteAccountCubit,
      listener: (_, state) {
        if (state.isReady) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(
              builder: (_) {
                return const WelcomePage(
                  farewell: .deletion,
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
          icon: Icons.delete_forever_outlined,
          title: 'Delete account',
          foreground: cs.error,
          trailing: busy
              ? SizedBox.square(
                  dimension: 24,
                  child: LoadingIndicator(
                    activeIndicatorColor: cs.error,
                  ),
                )
              : null,
          onTap: busy ? null : _confirm,
        );
      },
    );
  }
}
