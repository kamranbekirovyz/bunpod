import 'package:bunpod/bunpod.dart';

Episode _episode(String title) {
  return mockEpisodes.firstWhere((episode) => episode.title == title);
}

/// A seed row: which episode, how many days back the sitting was, the local
/// hour/minute it happened, and how long it lasted.
typedef _Seed = ({String title, int daysAgo, int hour, int minute, int mins});

// Days 0-4 are unbroken so the streak reads as 5; day 5 is intentionally
// empty, and days 6/9 fall on either side of the "this week" boundary so the
// grouping shows a weekday name and then a dated header.
const List<_Seed> _seeds = [
  (
    title: 'How to Escape the Productivity Trap',
    daysAgo: 0,
    hour: 8,
    minute: 12,
    mins: 22,
  ),
  (
    title: 'Detach to Win the Hard Fights',
    daysAgo: 0,
    hour: 13,
    minute: 40,
    mins: 41,
  ),
  (
    title: 'How Bioluminescence Works',
    daysAgo: 0,
    hour: 21,
    minute: 5,
    mins: 33,
  ),
  (
    title: 'The Future of AI and Humanity',
    daysAgo: 1,
    hour: 9,
    minute: 30,
    mins: 58,
  ),
  (
    title: 'Owning Less, Living More',
    daysAgo: 1,
    hour: 18,
    minute: 15,
    mins: 24,
  ),
  (title: 'Freedom from the Known', daysAgo: 1, hour: 22, minute: 48, mins: 37),
  (
    title: 'How to Get Rich Without Getting Lucky',
    daysAgo: 2,
    hour: 7,
    minute: 55,
    mins: 46,
  ),
  (
    title: 'The Deepest Feelings Behind Tantrums',
    daysAgo: 2,
    hour: 20,
    minute: 10,
    mins: 29,
  ),
  (
    title: 'Comedy, Combat Sports, and Staying Curious',
    daysAgo: 3,
    hour: 12,
    minute: 20,
    mins: 63,
  ),
  (
    title: 'Slow Productivity in a Busy World',
    daysAgo: 3,
    hour: 19,
    minute: 2,
    mins: 18,
  ),
  (
    title: 'Roger Penrose: Physics of the Mind',
    daysAgo: 4,
    hour: 10,
    minute: 45,
    mins: 51,
  ),
  (
    title: 'How Great Products Actually Get Built',
    daysAgo: 6,
    hour: 14,
    minute: 33,
    mins: 39,
  ),
  (title: 'Kaygıyla Başa Çıkmak', daysAgo: 6, hour: 23, minute: 12, mins: 26),
  (
    title: 'Ownership and Extreme Accountability',
    daysAgo: 9,
    hour: 16,
    minute: 5,
    mins: 44,
  ),
  (title: 'The Art of Letting Go', daysAgo: 9, hour: 21, minute: 40, mins: 31),
];

/// Listen history for the current session, anchored to the moment it is read
/// so `Today` / `Yesterday` always land right. Newest sitting first.
///
/// TODO(kamran): swap for real play-history storage when it lands.
List<ListenEntry> get mockHistory {
  final DateTime now = DateTime.now();

  final List<ListenEntry> entries = [
    for (final _Seed seed in _seeds)
      ListenEntry(
        episode: _episode(seed.title),
        playedAt: DateTime(
          now.year,
          now.month,
          now.day,
          seed.hour,
          seed.minute,
        ).subtract(Duration(days: seed.daysAgo)),
        listened: Duration(minutes: seed.mins),
      ),
  ];

  entries.sort((a, b) => b.playedAt.compareTo(a.playedAt));

  return entries;
}
