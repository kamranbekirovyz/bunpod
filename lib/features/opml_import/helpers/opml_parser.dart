import 'package:bunpod/bunpod.dart';
import 'package:xml/xml.dart';

abstract final class OpmlParser {
  static const int _maxDepth = 10;
  static const int _maxUrlLength = 2048;
  static const int _maxTitleLength = 200;

  static List<OpmlFeed> parse(String xml) {
    // OPML never needs a DTD, and refusing one rules out entity expansion.
    if (RegExp('<!DOCTYPE|<!ENTITY', caseSensitive: false).hasMatch(xml)) {
      throw const FormatException('Not a valid OPML file');
    }

    final XmlElement? body;
    try {
      body = XmlDocument.parse(xml).getElement('opml')?.getElement('body');
    } on XmlException {
      throw const FormatException('Not a valid OPML file');
    }

    if (body == null) throw const FormatException('Not a valid OPML file');

    final Map<String, OpmlFeed> feeds = {};
    _collect(body, 1, feeds);

    return feeds.values.toList();
  }

  static void _collect(
    XmlElement parent,
    int depth,
    Map<String, OpmlFeed> feeds,
  ) {
    if (depth > _maxDepth) return;

    for (final XmlElement outline in parent.findElements('outline')) {
      final String? url = _feedUrl(_attribute(outline, 'xmlUrl'));

      if (url != null && !feeds.containsKey(url)) {
        final String title = _attribute(outline, 'title').isNotEmpty
            ? _attribute(outline, 'title')
            : _attribute(outline, 'text');

        feeds[url] = OpmlFeed(
          title: title.length > _maxTitleLength
              ? title.substring(0, _maxTitleLength)
              : title,
          url: url,
        );
      }

      _collect(outline, depth + 1, feeds);
    }
  }

  // Attribute case varies between apps, e.g. `xmlUrl` vs `xmlurl`.
  static String _attribute(XmlElement outline, String name) {
    final String lower = name.toLowerCase();

    for (final XmlAttribute attribute in outline.attributes) {
      if (attribute.name.local.toLowerCase() == lower) {
        return attribute.value.trim();
      }
    }

    return '';
  }

  static String? _feedUrl(String raw) {
    if (raw.isEmpty || raw.length > _maxUrlLength) return null;

    final Uri? uri = Uri.tryParse(raw);

    return uri != null && (uri.isScheme('http') || uri.isScheme('https'))
        ? raw
        : null;
  }
}
