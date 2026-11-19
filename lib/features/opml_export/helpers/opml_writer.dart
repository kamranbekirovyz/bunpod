import 'package:bunpod/bunpod.dart';
import 'package:xml/xml.dart';

abstract final class OpmlWriter {
  static String write(List<Channel> channels) {
    final XmlBuilder builder = XmlBuilder()
      ..processing(
        'xml',
        'version="1.0" encoding="UTF-8"',
      );

    builder.element(
      'opml',
      attributes: {'version': '2.0'},
      nest: () {
        builder.element(
          'head',
          nest: () {
            builder.element(
              'title',
              nest: '${AppValues.title} subscriptions',
            );
          },
        );
        builder.element(
          'body',
          nest: () {
            for (final Channel channel in channels) {
              final String? feedUrl = channel.feedUrl;
              if (feedUrl == null) continue;

              builder.element(
                'outline',
                attributes: {
                  'type': 'rss',
                  'text': channel.title ?? feedUrl,
                  'title': channel.title ?? feedUrl,
                  'xmlUrl': feedUrl,
                },
              );
            }
          },
        );
      },
    );

    return builder.buildDocument().toXmlString(pretty: true);
  }
}
