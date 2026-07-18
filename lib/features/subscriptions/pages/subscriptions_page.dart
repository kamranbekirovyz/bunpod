import 'package:bunpod/bunpod.dart';
import 'package:expressive_refresh_indicator/expressive_refresh_indicator.dart';
import 'package:expressive_snack/expressive_snack.dart';
import 'package:flutter/material.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SubscriptionsPage());
  }

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  final Set<String> _unsubscribed = <String>{};

  Future<void> _refresh() {
    return Future<void>.delayed(const Duration(seconds: 3));
  }

  void _openChannel(Channel channel) {
    Navigator.of(context).push(ChannelPage.route(channel));
  }

  void _toggle(Channel channel) {
    final bool nowUnsubscribed = !_unsubscribed.contains(channel.name);
    setState(() {
      if (nowUnsubscribed) {
        _unsubscribed.add(channel.name);
      } else {
        _unsubscribed.remove(channel.name);
      }
    });

    showExpressiveSnack(
      context: context,
      message: nowUnsubscribed
          ? 'Unsubscribed from ${channel.name}'
          : 'Resubscribed to ${channel.name}',
      icon: nowUnsubscribed ? Icons.close_rounded : Icons.add_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Channel> channels = mockSubscriptions;

    return Scaffold(
      appBar: const _AppBar(),
      body: ExpressiveRefreshIndicator(
        onRefresh: _refresh,
        child: ListView.separated(
          padding: .fromLTRB(
            16,
            8,
            16,
            32 + BottomPadding.of(context),
          ),
          itemCount: channels.length,
          itemBuilder: (BuildContext context, int index) {
            final Channel channel = channels[index];

            return SubscriptionTile(
              channel: channel,
              borderRadius: _radiusFor(index, channels.length),
              subscribed: !_unsubscribed.contains(channel.name),
              onTap: () {
                _openChannel(channel);
              },
              onToggle: () {
                _toggle(channel);
              },
            );
          },
          separatorBuilder: (_, _) {
            return MenuSection.tileGap.gap;
          },
        ),
      ),
    );
  }

  BorderRadius _radiusFor(int index, int length) {
    const Radius outer = .circular(MenuSection.outerRadius);
    const Radius inner = .circular(MenuSection.innerRadius);

    return .vertical(
      top: index == 0 ? outer : inner,
      bottom: index == length - 1 ? outer : inner,
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const StyledBackButton(),
      title: const Text('Subscriptions'),
    );
  }
}
