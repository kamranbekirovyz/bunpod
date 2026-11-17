import 'package:bunpod/bunpod.dart';

class OpmlImporter {
  const OpmlImporter({this.matcher = const OpmlMatcher()});

  final OpmlMatcher matcher;

  static const int _maxFeeds = 500;

  static const int _concurrency = 10;

  Future<OpmlImport> import(String xml) async {
    final List<OpmlFeed> feeds = OpmlParser.parse(xml);

    if (feeds.isEmpty) {
      throw const FormatException('No podcast feeds in this file');
    }
    if (feeds.length > _maxFeeds) {
      throw const FormatException('Too many feeds, the limit is $_maxFeeds');
    }

    final List<OpmlMatch> matches = await mapWithLimit(
      feeds,
      _concurrency,
      matcher.match,
    );

    // Two URLs in one file can point at the same show.
    final Map<int?, Channel> found = {};
    final List<OpmlSuggestion> suggestions = [];
    final List<OpmlFeed> unavailable = [];

    for (final (int i, OpmlMatch match) in matches.indexed) {
      switch (match) {
        case OpmlFound(:final Channel channel):
          found[channel.id] = channel;
        case OpmlSuggested(:final List<Channel> options):
          suggestions.add(OpmlSuggestion(feed: feeds[i], options: options));
        case OpmlMissing():
          unavailable.add(feeds[i]);
      }
    }

    final List<Channel> subscribed = found.values.toList();
    await locator<SubscriptionsLocalData>().subscribe(subscribed);

    // Counts only: private feed URLs carry the user's access token.
    logarte.log(
      'opml import: ${feeds.length} feeds, ${subscribed.length} subscribed, '
      '${suggestions.length} suggested, ${unavailable.length} unavailable',
    );

    return OpmlImport(
      subscribed: subscribed,
      suggestions: suggestions,
      unavailable: unavailable,
    );
  }
}
