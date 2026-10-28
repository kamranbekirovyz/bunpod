import 'package:flutter/material.dart';

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

  Color get seed => seedOf(id);

  ColorScheme scheme(BuildContext context) => schemeOf(context, id);

  static ColorScheme schemeOf(BuildContext context, int? id) {
    return ColorScheme.fromSeed(
      seedColor: seedOf(id),
      brightness: Theme.of(context).brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.content,
    );
  }

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
