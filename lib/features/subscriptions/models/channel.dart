import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';

class Channel {
  const Channel({
    this.id,
    this.appleId,
    this.title,
    this.author,
    this.description,
    this.image,
    this.language,
    this.lastEpisodeAt,
    this.feedUrl,
  });

  final int? id;
  final int? appleId;
  final String? title;
  final String? author;
  final String? description;
  final String? image;
  final String? language;
  final DateTime? lastEpisodeAt;
  final String? feedUrl;

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'],
      appleId: json['apple_id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      image: json['image'],
      language: json['language'],
      lastEpisodeAt: DateTime.tryParse(
        json['last_episode_at'] ?? '',
      ),
      feedUrl: json['feed_url'],
    );
  }

  factory Channel.fromPodcastIndex(Map<String, dynamic> json) {
    final int? newest = json['newestItemPublishTime'];
    final String? artwork = json['artwork'];

    return Channel(
      id: json['id'],
      appleId: json['itunesId'],
      feedUrl: json['url'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      image: artwork == null || artwork.isEmpty ? json['image'] : artwork,
      language: json['language'],
      lastEpisodeAt: newest == null || newest == 0
          ? null
          : DateTime.fromMillisecondsSinceEpoch(newest * 1000),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'apple_id': appleId,
      'title': title,
      'author': author,
      'description': description,
      'image': image,
      'language': language,
      'last_episode_at': lastEpisodeAt?.toIso8601String(),
      'feed_url': feedUrl,
    };
  }

  Color seed(BuildContext context) {
    return ChannelColors.seedOf(context, id: id, image: image);
  }

  ColorScheme scheme(BuildContext context) {
    return schemeOf(context, id: id, image: image);
  }

  static ColorScheme schemeOf(
    BuildContext context, {
    required int? id,
    required String? image,
  }) {
    final Color seed = ChannelColors.seedOf(context, id: id, image: image);
    final Brightness brightness = Theme.of(context).brightness;

    return _schemes[(seed, brightness)] ??= ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
      dynamicSchemeVariant: .content,
    );
  }

  static final Map<(Color, Brightness), ColorScheme> _schemes = {};
}
