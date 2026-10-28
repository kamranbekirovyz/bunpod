import 'package:bunpod/bunpod.dart';

class ChannelPreview {
  const ChannelPreview({
    this.appleId,
    this.title,
    this.author,
    this.image,
  });

  final int? appleId;
  final String? title;
  final String? author;
  final String? image;

  factory ChannelPreview.fromJson(Map<String, dynamic> json) {
    return ChannelPreview(
      appleId: json['apple_id'],
      title: json['title'],
      author: json['author'],
      image: json['image'],
    );
  }

  factory ChannelPreview.fromChannel(Channel? channel) {
    return ChannelPreview(
      title: channel?.title,
      author: channel?.author,
      image: channel?.image,
    );
  }
}
