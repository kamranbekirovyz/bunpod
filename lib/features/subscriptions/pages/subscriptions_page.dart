import 'package:bunpod/bunpod.dart';
import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:expressive_refresh_indicator/expressive_refresh_indicator.dart';
import 'package:expressive_snack/expressive_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SubscriptionsPage());
  }

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  late final UnsubscribedCubit _unsubscribedCubit;

  @override
  void initState() {
    super.initState();
    _unsubscribedCubit = UnsubscribedCubit();
  }

  @override
  void dispose() {
    if (_unsubscribedCubit.state.isNotEmpty) {
      locator<SubscriptionsCubit>().load();
    }
    _unsubscribedCubit.close();
    super.dispose();
  }

  void _openChannel(Channel channel) {
    Navigator.of(context).push(
      ChannelPage.route(
        id: channel.id,
        preview: ChannelPreview.fromChannel(channel),
      ),
    );
  }

  void _toggle(Channel channel) {
    final int? id = channel.id;
    if (id == null) return;

    final bool unsubscribing = !_unsubscribedCubit.state.contains(id);
    _unsubscribedCubit.toggle(id);

    showExpressiveSnack(
      context: context,
      message: unsubscribing
          ? 'Unsubscribed from ${channel.title}'
          : 'Resubscribed to ${channel.title}',
      icon: unsubscribing ? Icons.close_rounded : Icons.add_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const StyledBackButton(),
        title: const Text('Subscriptions'),
      ),
      body: BlocBuilder<SubscriptionsCubit, List<Channel>?>(
        bloc: locator<SubscriptionsCubit>(),
        builder: (context, channels) {
          if (channels == null) {
            return Center(child: LoadingIndicator());
          }

          if (channels.isEmpty) {
            return const Center(child: Text('No subscriptions yet'));
          }

          return BlocBuilder<UnsubscribedCubit, Set<int>>(
            bloc: _unsubscribedCubit,
            builder: (context, unsubscribed) {
              return ExpressiveRefreshIndicator(
                onRefresh: locator<SubscriptionsCubit>().load,
                child: ListView.separated(
                  padding: .fromLTRB(16, 8, 16, 32 + BottomPadding.of(context)),
                  itemCount: channels.length,
                  separatorBuilder: (_, _) => MenuSection.tileGap.gap,
                  itemBuilder: (BuildContext context, int index) {
                    final Channel channel = channels[index];

                    return SubscriptionTile(
                      channel: channel,
                      borderRadius: MenuSection.radiusFor(
                        index,
                        channels.length,
                      ),
                      subscribed: !unsubscribed.contains(channel.id),
                      onTap: () => _openChannel(channel),
                      onToggle: () => _toggle(channel),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
