import 'package:bunpod/bunpod.dart';

class FeedSync {
  FeedSync();

  static const int _concurrency = 3;
  static const Duration _fresh = Duration(minutes: 15);

  // A second caller waits on the same fetch.
  final Map<String, Future<void>> _running = {};

  EpisodesLocalData get _local => locator<EpisodesLocalData>();

  Future<void> syncAll(List<Channel> channels, {bool force = false}) {
    return mapWithLimit(channels, _concurrency, (channel) {
      return sync(channel, force: force);
    });
  }

  // Never throws: a failed feed keeps what it had.
  Future<void> sync(Channel channel, {bool force = false}) {
    final String? url = channel.feedUrl;
    if (url == null) return Future.value();

    return _running[url] ??= _sync(channel, url, force: force).whenComplete(() {
      _running.remove(url);
    });
  }

  Future<void> _sync(Channel channel, String url, {required bool force}) async {
    final RssFeed? stored = await _local.feed(url);
    final DateTime? refreshedAt = stored?.refreshedAt;

    if (!force &&
        refreshedAt != null &&
        DateTime.now().difference(refreshedAt) < _fresh) {
      return;
    }

    final Stopwatch timer = Stopwatch()..start();

    try {
      final RssBody? body = await locator<RssRemoteData>().fetch(
        url,
        etag: stored?.etag,
        lastModified: stored?.lastModified,
      );

      if (body == null) {
        await _local.touchFeed(url);
        logarte.log('rss $url status=304 total=${timer.elapsedMilliseconds}');
        return;
      }

      final ParsedFeed parsed = RssParser.parse(body.xml);
      await _local.saveFeed(
        feedUrl: url,
        channel: channel,
        parsed: parsed,
        etag: body.etag,
        lastModified: body.lastModified,
      );

      logarte.log(
        'rss $url status=200 total=${timer.elapsedMilliseconds} '
        'bytes=${body.xml.length} items=${parsed.episodes.length}',
      );
    } catch (error) {
      logarte.log(
        'rss $url status=err total=${timer.elapsedMilliseconds} $error',
      );
    }
  }
}
