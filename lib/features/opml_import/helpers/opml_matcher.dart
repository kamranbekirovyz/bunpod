import 'package:bunpod/bunpod.dart';

class OpmlMatcher {
  const OpmlMatcher();

  static const int _titleSearchSize = 10;

  static const int _maxOptions = 3;

  static const Set<String> _fillerWords = {
    'show',
    'podcast',
    'podcasts',
    'the',
    'official',
    'with',
    'and',
    'a',
    'of',
    'radio',
    'feed',
  };

  PodcastIndexRemoteData get _podcastIndex => locator<PodcastIndexRemoteData>();

  Future<OpmlMatch> match(OpmlFeed feed) async {
    final String title = feed.title ?? '';
    final String? url = feed.url;

    final Channel? byUrl = url == null
        ? null
        : await _podcastIndex.byFeedUrl(url);

    if (byUrl != null) return OpmlFound(byUrl);
    if (_normalize(title).isEmpty) return const OpmlMissing();

    final Channel? byTitle = await _sameTitle(title);
    if (byTitle != null) return OpmlFound(byTitle);

    final List<Channel> options = await _suggest(title);

    return options.isEmpty ? const OpmlMissing() : OpmlSuggested(options);
  }

  // Several feeds can share a title, the newest is the likely pick.
  Future<Channel?> _sameTitle(String title) async {
    final List<Channel> found = await _podcastIndex.searchByTitle(
      title,
      max: _titleSearchSize,
    );

    final List<Channel> same = [
      for (final Channel channel in found)
        if (_normalize(channel.title ?? '') == _normalize(title)) channel,
    ];

    same.sort((a, b) {
      final DateTime never = DateTime.fromMillisecondsSinceEpoch(0);

      return (b.lastEpisodeAt ?? never).compareTo(a.lastEpisodeAt ?? never);
    });

    return same.firstOrNull;
  }

  // Search needs every word to match, so each miss retries with fewer.
  Future<List<Channel>> _suggest(String title) async {
    for (final String query in _searchQueries(title)) {
      final List<Channel> found = await _podcastIndex.searchByTerm(
        query,
        max: _maxOptions,
      );

      if (found.isNotEmpty) return found;
    }

    return const [];
  }

  List<String> _searchQueries(String title) {
    final List<String> words = title.split(RegExp(r'\s+'))
      ..removeWhere((word) => word.isEmpty);
    final List<String> core = [
      for (final String word in words)
        if (!_fillerWords.contains(word.toLowerCase())) word,
    ];

    final Set<String> queries = {
      words.join(' '),
      core.join(' '),
      for (int count = core.length - 1; count >= 2; count--)
        core.take(count).join(' '),
    };

    return [
      for (final String query in queries)
        if (query.length >= 3) query,
    ];
  }

  String _normalize(String title) {
    return title.toLowerCase().replaceAll(
      RegExp(r'[^\p{L}\p{N}]', unicode: true),
      '',
    );
  }
}
