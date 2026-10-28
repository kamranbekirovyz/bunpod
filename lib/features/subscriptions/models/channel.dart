import 'package:flutter/material.dart';

class Channel {
  const Channel({
    this.id,
    this.title,
    this.author,
    this.description,
    this.image,
    this.language,
    this.lastEpisodeAt,
  });

  final int? id;
  final String? title;
  final String? author;
  final String? description;
  final String? image;
  final String? language;
  final DateTime? lastEpisodeAt;

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      image: json['image'],
      language: json['language'],
      lastEpisodeAt: DateTime.tryParse(
        json['last_episode_at'] ?? '',
      ),
    );
  }

  Color get seed => seedOf(id);

  ColorScheme scheme(BuildContext context) => ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Theme.of(context).brightness,
    dynamicSchemeVariant: DynamicSchemeVariant.content,
  );

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
