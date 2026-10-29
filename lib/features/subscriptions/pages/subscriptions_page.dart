import 'package:bunpod/bunpod.dart';
import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:expressive_refresh_indicator/expressive_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) {
        return const SubscriptionsPage();
      },
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

          return ExpressiveRefreshIndicator(
            onRefresh: locator<SubscriptionsCubit>().load,
            child: ListView.separated(
              padding: .fromLTRB(16, 8, 16, 32 + BottomPadding.of(context)),
              itemCount: channels.length,
              separatorBuilder: (_, _) => MenuSection.tileGap.gap,
              itemBuilder: (BuildContext context, int index) {
                final Channel channel = channels[index];

                return SubscriptionRow(
                  key: ValueKey<int?>(channel.id),
                  channel: channel,
                  borderRadius: MenuSection.radiusFor(index, channels.length),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
