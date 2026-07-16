import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:bunpod_flutter/features/subscriptions/widgets/subscription_tile.dart';
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
  /// Shows dropped this session. Mock persistence until real subscription
  /// storage lands.
  final Set<String> _unsubscribed = <String>{};

  /// Shows mid removal animation: still listed, playing their collapse. Moved
  /// to [_unsubscribed] when the tile reports its slot closed.
  final Set<String> _removing = <String>{};

  /// Catalog order, which is newest episode first.
  List<Channel> get _channels {
    return <Channel>[
      for (final Channel channel in mockSubscriptions)
        if (!_unsubscribed.contains(channel.name)) channel,
    ];
  }

  // Mock-only: holds the expressive indicator for a beat; a real feed sync
  // goes here later.
  Future<void> _refresh() {
    return Future<void>.delayed(const Duration(seconds: 3));
  }

  void _openChannel(Channel channel) {
    Navigator.of(context).push(ChannelPage.route(channel));
  }

  /// Asks before dropping [channel]. Resolves true once the row is on its way
  /// out, which tells the drag to stay open instead of springing shut.
  Future<bool> _unsubscribe(Channel channel) async {
    final int waiting = newEpisodeCount(channel);

    final bool confirmed = await StyledSheet.show(
      context,
      icon: Icons.playlist_remove_rounded,
      title: 'Unsubscribe from ${channel.name}?',
      message: waiting == 0
          ? 'New episodes stop showing up in your library. You can subscribe '
                'again anytime.'
          : 'New episodes stop showing up in your library, including the '
                "$waiting you haven't played yet. You can subscribe again "
                'anytime.',
      confirmLabel: 'Unsubscribe',
      destructive: true,
    );

    if (!confirmed || !mounted) return false;

    setState(() => _removing.add(channel.name));
    showExpressiveSnack(
      context: context,
      message: 'Unsubscribed from ${channel.name}',
      icon: Icons.playlist_remove_rounded,
    );
    return true;
  }

  void _finishRemoving(Channel channel) {
    setState(() {
      _removing.remove(channel.name);
      _unsubscribed.add(channel.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AppBar(),
      body: ExpressiveRefreshIndicator(
        onRefresh: _refresh,
        child: _Body(
          channels: _channels,
          removing: _removing,
          onOpenChannel: _openChannel,
          onUnsubscribe: _unsubscribe,
          onRemoved: _finishRemoving,
        ),
      ),
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

class _Body extends StatelessWidget {
  const _Body({
    required this.channels,
    required this.removing,
    required this.onOpenChannel,
    required this.onUnsubscribe,
    required this.onRemoved,
  });

  final List<Channel> channels;
  final Set<String> removing;
  final ValueChanged<Channel> onOpenChannel;
  final Future<bool> Function(Channel) onUnsubscribe;
  final ValueChanged<Channel> onRemoved;

  @override
  Widget build(BuildContext context) {
    if (channels.isEmpty) return const _Empty();

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const .fromLTRB(16, 8, 16, 0),
          sliver: SliverList.separated(
            itemCount: channels.length,
            separatorBuilder: (_, _) => MenuSection.tileGap.gap,
            itemBuilder: (BuildContext context, int index) {
              final Channel channel = channels[index];

              return SubscriptionTile(
                // Keyed so a mid-removal row keeps its animation state when
                // rows above it leave the list.
                key: ValueKey<String>(channel.name),
                channel: channel,
                borderRadius: _radiusFor(index, channels.length),
                onTap: () => onOpenChannel(channel),
                onUnsubscribe: () => onUnsubscribe(channel),
                removing: removing.contains(channel.name),
                onRemoved: () => onRemoved(channel),
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 32 + BottomPadding.of(context)),
        ),
      ],
    );
  }

  /// The same grouping the menu and downloads use: round on the group's outer
  /// edges, nearly square on the inner seams.
  BorderRadius _radiusFor(int index, int length) {
    const Radius outer = .circular(MenuSection.outerRadius);
    const Radius inner = .circular(MenuSection.innerRadius);

    return .vertical(
      top: index == 0 ? outer : inner,
      bottom: index == length - 1 ? outer : inner,
    );
  }
}

/// Every show dropped. Points back at Explore instead of leaving a dead end.
class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const .fromLTRB(32, 0, 32, 48),
        child: Column(
          mainAxisSize: .min,
          children: [
            Icon(Icons.podcasts_rounded, size: 44, color: cs.outline),
            16.gap,
            Text(
              'No subscriptions yet',
              style: tt.titleMedium?.copyWith(fontWeight: .w700),
              textAlign: .center,
            ),
            8.gap,
            Text(
              'Follow a show and its new episodes land here.',
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              textAlign: .center,
            ),
            24.gap,
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(ExplorePage.route());
              },
              icon: const Icon(Icons.search_rounded),
              label: const Text('Explore shows'),
            ),
          ],
        ),
      ),
    );
  }
}
