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
      logarte.log('⏭️ ${channel.title} · skipped, checked recently');
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
        logarte.log(
          '💤 ${channel.title} · no changes · ${timer.elapsedMilliseconds} ms',
        );
        return;
      }

      final ParsedFeed parsed = RssParser.parse(body.xml);
      final Set<String> known = await _local.guids(url);
      final int fresh = parsed.episodes.where((Episode episode) {
        return !known.contains(episode.id);
      }).length;

      await _local.saveFeed(
        feedUrl: url,
        channel: channel,
        parsed: parsed,
        etag: body.etag,
        lastModified: body.lastModified,
      );

      logarte.log(
        '${fresh > 0 ? '🆕' : '📭'} ${channel.title} · $fresh new of '
        '${parsed.episodes.length} · ${body.xml.length ~/ 1024} KB · '
        '${timer.elapsedMilliseconds} ms',
      );
    } catch (error) {
      logarte.log(
        '❌ ${channel.title} · failed · ${timer.elapsedMilliseconds} ms · $error',
      );
    }
  }
}
