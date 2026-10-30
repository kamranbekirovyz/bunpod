import 'package:bunpod/bunpod.dart';
import 'package:expressive_snack/expressive_snack.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionRow extends StatefulWidget {
  const SubscriptionRow({
    super.key,
    required this.channel,
    required this.borderRadius,
  });

  final Channel channel;
  final BorderRadius borderRadius;

  @override
  State<SubscriptionRow> createState() => _SubscriptionRowState();
}

class _SubscriptionRowState extends State<SubscriptionRow> {
  late final ChannelFollowCubit _followCubit;

  @override
  void initState() {
    super.initState();
    _followCubit = ChannelFollowCubit(true);
  }

  @override
  void dispose() {
    _followCubit.close();
    super.dispose();
  }

  void _openChannel() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) {
          return ChannelPage(
            id: widget.channel.id,
            preview: ChannelPreview.fromChannel(widget.channel),
          );
        },
      ),
    );
  }

  void _toggle() {
    final int? id = widget.channel.id;

    if (id != null) _followCubit.toggle(id: id);
  }

  void _onSucceeded(BuildContext context, Follow? follow) {
    final bool subscribed = follow?.subscribed == true;

    showExpressiveSnack(
      context: context,
      message: subscribed
          ? 'Resubscribed to ${widget.channel.title}'
          : 'Unsubscribed from ${widget.channel.title}',
      icon: subscribed ? Icons.add_rounded : Icons.close_rounded,
    );
    locator<SubscriptionsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChannelFollowCubit, Follow?>(
      bloc: _followCubit,
      listenWhen: ChannelFollowCubit.succeeded,
      listener: _onSucceeded,
      builder: (context, follow) {
        return SubscriptionTile(
          channel: widget.channel,
          borderRadius: widget.borderRadius,
          subscribed: follow?.subscribed ?? true,
          onTap: _openChannel,
          onToggle: _toggle,
        );
      },
    );
  }
}
