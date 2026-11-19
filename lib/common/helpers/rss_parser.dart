import 'package:bunpod/bunpod.dart';
import 'package:xml/xml.dart';

class ParsedFeed {
  const ParsedFeed({
    this.title,
    this.author,
    this.description,
    this.image,
    this.language,
    this.episodes = const [],
  });

  final String? title;
  final String? author;
  final String? description;
  final String? image;
  final String? language;
  final List<Episode> episodes;
}

class RssParser {
  const RssParser._();

  static ParsedFeed parse(String xml) {
    final XmlElement root = XmlDocument.parse(xml).rootElement;

    return root.name.local == 'feed' ? _atom(root) : _rss(root);
  }

  static ParsedFeed _rss(XmlElement root) {
    final XmlElement? channel = _child(root, 'channel');
    if (channel == null) return const ParsedFeed();

    final String? image =
        _url(_child(channel, 'itunes:image')?.getAttribute('href')) ??
        _url(_text(_child(channel, 'image'), 'url'));

    final List<Episode> episodes = [];
    DateTime? newest;

    for (final XmlElement item in _children(channel, 'item')) {
      final XmlElement? enclosure = _child(item, 'enclosure');
      final String? audioUrl = _url(enclosure?.getAttribute('url'));
      final String? guid = _text(item, 'guid') ?? audioUrl;
      if (guid == null) continue;

      // An undated item sits with the one before it.
      final DateTime publishedAt =
          _date(_text(item, 'pubDate')) ?? newest ?? DateTime.now();
      newest = publishedAt;

      episodes.add(
        Episode(
          id: guid,
          title: _text(item, 'title') ?? _text(item, 'itunes:title'),
          description:
              _text(item, 'content:encoded') ??
              _text(item, 'description') ??
              _text(item, 'itunes:summary'),
          image:
              _url(_child(item, 'itunes:image')?.getAttribute('href')) ?? image,
          audioUrl: audioUrl,
          audioBytes: int.tryParse(enclosure?.getAttribute('length') ?? ''),
          duration: _duration(_text(item, 'itunes:duration')),
          publishedAt: publishedAt,
        ),
      );
    }

    return ParsedFeed(
      title: _text(channel, 'title'),
      author: _text(channel, 'itunes:author'),
      description:
          _text(channel, 'description') ?? _text(channel, 'itunes:summary'),
      image: image,
      language: _text(channel, 'language'),
      episodes: episodes,
    );
  }

  static ParsedFeed _atom(XmlElement root) {
    final String? image =
        _url(_text(root, 'logo')) ?? _url(_text(root, 'icon'));

    final List<Episode> episodes = [];
    DateTime? newest;

    for (final XmlElement entry in _children(root, 'entry')) {
      final XmlElement? enclosure = _children(
        entry,
        'link',
      ).where((link) => link.getAttribute('rel') == 'enclosure').firstOrNull;
      final String? audioUrl = _url(enclosure?.getAttribute('href'));
      final String? guid = _text(entry, 'id') ?? audioUrl;
      if (guid == null) continue;

      final DateTime publishedAt =
          _date(_text(entry, 'published') ?? _text(entry, 'updated')) ??
          newest ??
          DateTime.now();
      newest = publishedAt;

      episodes.add(
        Episode(
          id: guid,
          title: _text(entry, 'title'),
          description: _text(entry, 'content') ?? _text(entry, 'summary'),
          image: image,
          audioUrl: audioUrl,
          audioBytes: int.tryParse(enclosure?.getAttribute('length') ?? ''),
          duration: _duration(_text(entry, 'itunes:duration')),
          publishedAt: publishedAt,
        ),
      );
    }

    return ParsedFeed(
      title: _text(root, 'title'),
      author: _text(_child(root, 'author'), 'name'),
      description: _text(root, 'subtitle'),
      image: image,
      language: root.getAttribute('xml:lang'),
      episodes: episodes,
    );
  }

  static Iterable<XmlElement> _children(XmlElement parent, String name) {
    return parent.childElements.where((child) => child.name.qualified == name);
  }

  static XmlElement? _child(XmlElement parent, String name) {
    return _children(parent, name).firstOrNull;
  }

  static String? _text(XmlElement? parent, String name) {
    if (parent == null) return null;

    final String? text = _child(parent, name)?.innerText.trim();

    return text == null || text.isEmpty ? null : text;
  }

  static String? _url(String? value) {
    final String? url = value?.trim();
    if (url == null) return null;

    return url.startsWith('https://') || url.startsWith('http://') ? url : null;
  }

  // HH:MM:SS, MM:SS or plain seconds.
  static int? _duration(String? value) {
    if (value == null) return null;

    int seconds = 0;
    for (final String part in value.split(':')) {
      final double? number = double.tryParse(part.trim());
      if (number == null) return null;

      seconds = seconds * 60 + number.round();
    }

    return seconds;
  }

  // RFC 822 as feeds really write it, falling back to ISO 8601.
  static DateTime? _date(String? value) {
    if (value == null) return null;

    final RegExpMatch? match = _rfc822.firstMatch(value);
    if (match == null) return DateTime.tryParse(value)?.toLocal();

    final int? month = _monthIndex[match[2]!.substring(0, 3).toLowerCase()];
    if (month == null) return null;

    int year = int.parse(match[3]!);
    if (year < 100) year += 2000;

    final DateTime utc = DateTime.utc(
      year,
      month,
      int.parse(match[1]!),
      int.parse(match[4]!),
      int.parse(match[5]!),
      int.parse(match[6] ?? '0'),
    );

    return utc.subtract(_offset(match[7])).toLocal();
  }

  static Duration _offset(String? zone) {
    if (zone == null) return Duration.zero;

    if (zone.startsWith('+') || zone.startsWith('-')) {
      final int sign = zone.startsWith('-') ? -1 : 1;
      final int hours = int.parse(zone.substring(1, 3));
      final int minutes = int.parse(zone.substring(3, 5));

      return Duration(minutes: sign * (hours * 60 + minutes));
    }

    return Duration(hours: _zones[zone.toUpperCase()] ?? 0);
  }

  static final RegExp _rfc822 = RegExp(
    r'(\d{1,2})\s+([A-Za-z]{3,})\.?\s+(\d{2,4})\s+'
    r'(\d{1,2}):(\d{2})(?::(\d{2}))?\s*([+-]\d{4}|[A-Za-z]{1,4})?',
  );

  static const Map<String, int> _monthIndex = {
    'jan': 1,
    'feb': 2,
    'mar': 3,
    'apr': 4,
    'may': 5,
    'jun': 6,
    'jul': 7,
    'aug': 8,
    'sep': 9,
    'oct': 10,
    'nov': 11,
    'dec': 12,
  };

  static const Map<String, int> _zones = {
    'EST': -5,
    'EDT': -4,
    'CST': -6,
    'CDT': -5,
    'MST': -7,
    'MDT': -6,
    'PST': -8,
    'PDT': -7,
  };
}
