class Podcast {
  const Podcast({
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

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
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
}
