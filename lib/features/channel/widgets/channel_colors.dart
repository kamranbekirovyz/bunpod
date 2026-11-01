import 'package:bunpod/bunpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// Hands channel colors down the tree. When a channel's color arrives, only
/// the widgets showing that channel rebuild.
class ChannelColors extends StatelessWidget {
  const ChannelColors({super.key, required this.child});

  final Widget child;

  /// Shown until a channel's cover color is ready.
  static const Color fallback = Color(0xFF7D6D5E);

  static Color seedOf(
    BuildContext context, {
    required int? id,
    required String? image,
  }) {
    if (id == null) return fallback;

    final Color? seed = InheritedModel.inheritFrom<_ChannelColorsModel>(
      context,
      aspect: id,
    )?.seeds[id];

    if (seed == null) locator<ChannelColorsCubit>().ensure(id, image ?? '');

    return seed ?? fallback;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelColorsCubit, Map<int, Color>>(
      bloc: locator<ChannelColorsCubit>(),
      builder: (context, seeds) {
        return _ChannelColorsModel(seeds: seeds, child: child);
      },
    );
  }
}

class _ChannelColorsModel extends InheritedModel<int> {
  const _ChannelColorsModel({required this.seeds, required super.child});

  final Map<int, Color> seeds;

  @override
  bool updateShouldNotify(_ChannelColorsModel old) => seeds != old.seeds;

  @override
  bool updateShouldNotifyDependent(_ChannelColorsModel old, Set<int> ids) {
    return ids.any((id) => seeds[id] != old.seeds[id]);
  }
}
