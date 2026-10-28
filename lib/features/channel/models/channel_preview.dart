class TrendingPodcast {
  const TrendingPodcast({
    this.appleId,
    this.title,
    this.author,
    this.image,
  });

  final int? appleId;
  final String? title;
  final String? author;
  final String? image;

  factory TrendingPodcast.fromJson(Map<String, dynamic> json) {
    return TrendingPodcast(
      appleId: json['apple_id'],
      title: json['title'],
      author: json['author'],
      image: json['image'],
    );
  }
}
