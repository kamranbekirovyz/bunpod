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
    this.subscribed,
  });

  final int? id;
  final int? appleId;
  final String? title;
  final String? author;
  final String? description;
  final String? image;
  final String? language;
  final DateTime? lastEpisodeAt;
  final bool? subscribed;

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
      subscribed: json['subscribed'],
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
      'subscribed': subscribed,
    };
  }

  Color get seed => seedOf(id);

  ColorScheme scheme(BuildContext context) => schemeOf(context, id);

  /// Building a scheme from a seed is slow, and there are only a few seeds,
  /// so each one is built once per brightness and reused.
  static ColorScheme schemeOf(BuildContext context, int? id) {
    final Color seed = seedOf(id);
    final Brightness brightness = Theme.of(context).brightness;

    return _schemes[(seed, brightness)] ??= ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
      dynamicSchemeVariant: .content,
    );
  }

  static final Map<(Color, Brightness), ColorScheme> _schemes = {};

  // TODO: Use the cover art's color instead of a fixed list. Work it out on
  // the server once per channel and send it as a hex field.
  static Color seedOf(int? id) => _seeds[(id ?? 0) % _seeds.length];
}

const List<Color> _seeds = [
  Color(0xFFB01E28),
  Color(0xFF1F7A6B),
  Color(0xFF294B63),
  Color(0xFF4C6EF5),
  Color(0xFF311732),
  Color(0xFFA1836E),
  Color(0xFF2F6E8F),
  Color(0xFF7D6D5E),
];
