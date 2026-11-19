import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class OpmlExportPage extends StatelessWidget {
  const OpmlExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Channel>? channels = locator<SubscriptionsCubit>().state;

    return Scaffold(
      appBar: AppBar(
        leading: const StyledBackButton(),
      ),
      body: channels == null || channels.isEmpty
          ? const _NoSubscriptions()
          : _Body(
              channels: channels,
            ),
    );
  }
}

class _Body extends StatefulWidget {
  final List<Channel> channels;

  const _Body({
    required this.channels,
  });

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late final OpmlExportCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = OpmlExportCubit();
  }

  void _save() {
    _cubit.exportAndSave(widget.channels);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpmlExportCubit, ViewState<int>>(
      bloc: _cubit,
      builder: (context, state) {
        if (state.isReady) {
          HapticsHelper.success();

          return OpmlExportReadyView(
            channels: widget.channels,
          );
        } else if (state.isFailed) {
          return OpmlExportFailedView(
            onSave: _save,
          );
        }

        return OpmlExportIdleView(
          channels: widget.channels,
          busy: state.isBusy,
          onSave: _save,
        );
      },
    );
  }
}

class _NoSubscriptions extends StatelessWidget {
  const _NoSubscriptions();

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const .symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: .end,
        crossAxisAlignment: .stretch,
        children: [
          const OpmlShapeStack(),
          32.gap,
          const OpmlImportHero(
            title: 'Nothing to take yet',
            message:
                'Your bag is empty. Follow a few shows and they’ll be ready '
                'to go wherever you do.',
          ),
          64.gap,
          ExpressiveActionButton(
            label: 'Find shows',
            icon: Icons.add_rounded,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) {
                    return const ExplorePage();
                  },
                ),
              );
            },
            background: cs.primary,
            foreground: cs.onPrimary,
          ),
          8.gap,
          const BottomPadding(),
        ],
      ),
    );
  }
}
