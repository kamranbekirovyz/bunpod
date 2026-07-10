import 'package:bunpod_flutter/bunpod_flutter.dart';

Episode _episode(String title) {
  return mockEpisodes.firstWhere((episode) => episode.title == title);
}

final List<Download> mockDownloads = [
  Download(
    episode: _episode('Roger Penrose: Physics of the Mind'),
    megabytes: 312,
    received: 187,
    state: .downloading,
  ),
  Download(
    episode: _episode('Ownership and Extreme Accountability'),
    megabytes: 254,
    state: .queued,
  ),
  Download(
    episode: _episode('The Truth About the Culture War'),
    megabytes: 178,
    state: .queued,
  ),
  Download(
    episode: _episode('What Is Meditation, Really?'),
    megabytes: 107,
  ),
  Download(
    episode: _episode('The Art of Letting Go'),
    megabytes: 149,
  ),
  Download(
    episode: _episode('Kaygıyla Başa Çıkmak'),
    megabytes: 132,
  ),
  Download(
    episode: _episode('Comedy, Combat Sports, and Staying Curious'),
    megabytes: 296,
  ),
  Download(
    episode: _episode('Owning Less, Living More'),
    megabytes: 121,
  ),
  Download(
    episode: _episode('On Discipline, Ambition, and the Life Worth Living'),
    megabytes: 262,
  ),
  Download(
    episode: _episode('Qidalanma vərdişləri və sağlamlıq | Dr. Fərhad Burzu'),
    megabytes: 189,
  ),
  Download(
    episode: _episode('Lessons From 20 Years of Funding Startups'),
    megabytes: 142,
  ),
];
