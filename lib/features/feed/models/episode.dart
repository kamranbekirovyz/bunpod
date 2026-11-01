import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'podcast_id': channelId,
      'podcast': channel?.toJson(),
      'title': title,
      'description': description,
      'image': image,
      'published_at': publishedAt?.toUtc().toIso8601String(),
      'duration': duration,
      'audio_url': audioUrl,
      'audio_bytes': audioBytes,
      'position': position,
      'completed': completed,
    };
  }

  Episode withPosition(Duration? listened) {
    if (listened == null) return this;

    return _copyWith(position: listened.inSeconds);
  }

  /// Replaces the listed length with the audio's real one, which can differ
  /// from what the feed reports.
  Episode withTotal(Duration? total) {
    if (total == null || total <= Duration.zero) return this;

    return _copyWith(duration: total.inSeconds);
  }

  Episode _copyWith({int? duration, num? position}) {
    return Episode(
      id: id,
      channelId: channelId,
      channel: channel,
      title: title,
      description: description,
      image: image,
      publishedAt: publishedAt,
      duration: duration ?? this.duration,
      audioUrl: audioUrl,
      audioBytes: audioBytes,
      position: position ?? this.position,
      completed: completed,
    );
  }

  String get cover => channel?.image ?? image ?? '';

  Duration get total => Duration(seconds: duration ?? 0);

  Duration get listened =>
      completed == true ? total : Duration(seconds: (position ?? 0).round());

  Duration get remaining {
    final Duration left = total - listened;

    return left > Duration.zero ? left : Duration.zero;
  }

  bool get played =>
      completed == true ||
      (total > Duration.zero && remaining == Duration.zero);

  double get progress =>
      total.inSeconds == 0 ? 0 : listened.inSeconds / total.inSeconds;

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

  ColorScheme scheme(BuildContext context) {
    return Channel.schemeOf(context, id: channelId, image: cover);
  }
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
