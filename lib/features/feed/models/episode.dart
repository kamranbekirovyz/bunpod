import 'package:bunpod/bunpod.dart';
import 'package:flutter/material.dart';

class Episode {
  const Episode({
    this.id,
    this.channelId,
    this.channel,
    this.title,
    this.description,
    this.image,
    this.publishedAt,
    this.duration,
    this.audioUrl,
    this.audioBytes,
    this.position,
    this.completed,
  });

  final int? id;
  final int? channelId;
  final Channel? channel;
  final String? title;
  final String? description;
  final String? image;
  final DateTime? publishedAt;
  final int? duration;
  final String? audioUrl;
  final int? audioBytes;
  final num? position;
  final bool? completed;

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      channelId: json['podcast_id'],
      channel: json['podcast'] == null
          ? null
          : Channel.fromJson(json['podcast']),
      title: json['title'],
      description: json['description'],
      image: json['image'],
      publishedAt: DateTime.tryParse(json['published_at'] ?? '')?.toLocal(),
      duration: json['duration'],
      audioUrl: json['audio_url'],
      audioBytes: json['audio_bytes'],
      position: json['position'],
      completed: json['completed'],
    );
  }

  String get cover => channel?.image ?? image ?? '';

  Duration get total => Duration(seconds: duration ?? 0);

  Duration get listened =>
      completed == true ? total : Duration(seconds: (position ?? 0).round());

  double get progress =>
      total.inSeconds == 0 ? 0 : listened.inSeconds / total.inSeconds;

  Color get seed => Channel.seedOf(channelId);

  Bucket get bucket {
    final DateTime date = publishedAt ?? DateTime.now();
    final DateTime now = DateTime.now();
    final int daysAgo = DateTime(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime(date.year, date.month, date.day)).inDays;

    if (daysAgo <= 0) return Bucket.today;
    if (daysAgo == 1) return Bucket.yesterday;
    if (daysAgo < 7) return Bucket.thisWeek;
    if (daysAgo < 30) return Bucket.thisMonth;

    return Bucket.earlier;
  }

  String get date {
    final DateTime date = publishedAt ?? DateTime.now();
    final String short = '${_months[date.month - 1]} ${date.day}';

    return date.year == DateTime.now().year ? short : '$short, ${date.year}';
  }

  ColorScheme scheme(BuildContext context) => ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Theme.of(context).brightness,
    dynamicSchemeVariant: DynamicSchemeVariant.content,
  );
}

const List<String> _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
