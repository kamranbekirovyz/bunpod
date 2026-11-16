import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class OpmlImportPage extends StatelessWidget {
  const OpmlImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    // sheets close, pages go back
    final bool sheet = ModalRoute.of(context) is PopupRoute;

    return Scaffold(
      appBar: AppBar(
        leading: sheet
            ? Center(
                child: CloseButton(),
              )
            : const StyledBackButton(),
      ),
      body: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late final OpmlImportCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = OpmlImportCubit();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpmlImportCubit, ViewState<OpmlImport>>(
      bloc: _cubit,
      builder: (context, state) {
        if (state.isBusy) {
          return const OpmlImportBusyView();
        } else if (state.isReady) {
          HapticsHelper.success();

          return OpmlImportReadyView(
            result: state.requireData,
            onPick: _cubit.pickAndImport,
          );
        } else if (state.isFailed) {
          return OpmlImportFailedView(
            onPick: _cubit.pickAndImport,
          );
        }

        return OpmlImportIdleView(
          onPick: _cubit.pickAndImport,
        );
      },
    );
  }
}
