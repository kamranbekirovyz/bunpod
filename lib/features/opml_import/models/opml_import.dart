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
}

class OpmlFeed {
  const OpmlFeed({this.title, this.url});

  final String? title;
  final String? url;
}

class OpmlSuggestion {
  const OpmlSuggestion({required this.feed, required this.options});

  final OpmlFeed feed;
  final List<Channel> options;
}
