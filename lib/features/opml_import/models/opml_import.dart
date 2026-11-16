import 'package:bunpod/bunpod.dart';

class OpmlImport {
  const OpmlImport({
    required this.subscribed,
    required this.suggestions,
    required this.unavailable,
  });

  final List<Channel> subscribed;
  final List<OpmlSuggestion> suggestions;
  final List<OpmlFeed> unavailable;

  factory OpmlImport.fromJson(Map<String, dynamic> json) {
    final List<dynamic> subscribed = json['subscribed'] ?? [];
    final List<dynamic> suggestions = json['suggestions'] ?? [];
    final List<dynamic> unavailable = json['unavailable'] ?? [];

    return OpmlImport(
      subscribed: [
        for (final dynamic item in subscribed) Channel.fromJson(item),
      ],
      suggestions: [
        for (final dynamic item in suggestions) OpmlSuggestion.fromJson(item),
      ],
      unavailable: [
        for (final dynamic item in unavailable) OpmlFeed.fromJson(item),
      ],
    );
  }
}

class OpmlFeed {
  const OpmlFeed({this.title, this.url});

  final String? title;

  final String? url;

  factory OpmlFeed.fromJson(Map<String, dynamic> json) {
    return OpmlFeed(
      title: json['title'],
      url: json['url'],
    );
  }
}

class OpmlSuggestion {
  const OpmlSuggestion({required this.feed, required this.options});

  final OpmlFeed feed;
  final List<Channel> options;

  factory OpmlSuggestion.fromJson(Map<String, dynamic> json) {
    final List<dynamic> options = json['options'] ?? [];

    return OpmlSuggestion(
      feed: OpmlFeed.fromJson(json),
      options: [
        for (final dynamic item in options) Channel.fromJson(item),
      ],
    );
  }
}
