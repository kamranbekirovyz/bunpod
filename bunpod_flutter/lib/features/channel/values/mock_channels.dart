import 'package:bunpod_flutter/bunpod_flutter.dart';

/// Editorial blurbs per channel — the only channel-level data not already on the
/// episodes. Everything else is derived from [mockEpisodes].
const Map<String, String> _channelDescriptions = <String, String>{
  'Deep Questions':
      "Cal Newport's weekly deep dive into work, focus, and the deep life — "
      'answering listener questions about productivity, technology, and living '
      'with intention in a distracted world.',
  'Candace':
      'Political and cultural commentary from Candace Owens — unfiltered takes '
      'on the news, the media, and the stories shaping the West.',
  'Jocko Podcast':
      'Jocko Willink on discipline, leadership, and extreme ownership — lessons '
      'forged on the battlefield and applied to business and everyday life.',
  'Lex Fridman Podcast':
      'Long-form conversations with scientists, engineers, and thinkers on '
      'intelligence, consciousness, power, love, and the nature of reality.',
  'Krishnamurti':
      'Recorded talks from Jiddu Krishnamurti on freedom, fear, meditation, and '
      'the quiet workings of the mind.',
  'Being in The Way':
      'Classic Alan Watts lectures on Zen, presence, and the art of letting go '
      '— a meditation on being fully here, now.',
  'Merdiven Altı Terapi':
      'Psikoloji, ilişkiler ve kişisel gelişim üzerine samimi ve içten '
      'sohbetler.',
  'Naval':
      'Naval Ravikant on wealth, happiness, and clear thinking — timeless ideas '
      'on building a life of meaning and freedom.',
  'Kurcala Podcast Yaptı':
      'Günlük hayata dair merak edilenleri kurcalayan, eğlenceli ve içten bir '
      'sohbet podcast’i.',
  'MANPASI':
      'İctimai Radionun 90FM səhər proqramının rəsmi podkastı — DJ Fateh və '
      'Rəvan Bağırov ilə gündəm, məsləhətli mövzular və dinləyici zəngləri '
      'üzərində canlı, isti səhər söhbətləri.',
  'Söhbətgah':
      'DJ Tural və Əli Xəyyamın hər həftə fərqli qonaqla mövzunu dərinliyinə '
      'qədər açdığı Azərbaycan söhbət podkastı — mədəniyyət, texnologiya, '
      'sağlamlıq və biznes üzərinə təzadlı baxışlar.',
};

/// All channels in the catalog, derived from [mockEpisodes] in first-seen order
/// so identity (host, seed, cover) always matches the episode feed.
List<Channel> get mockChannels {
  final Set<String> seen = <String>{};
  final List<Channel> channels = <Channel>[];
  for (final Episode e in mockEpisodes) {
    if (seen.add(e.channel)) {
      channels.add(
        Channel(
          name: e.channel,
          host: e.host,
          seed: e.seed,
          image: e.image,
          description: _channelDescriptions[e.channel] ?? '',
        ),
      );
    }
  }
  return channels;
}

/// The channel for [name], or `null` if no episodes carry that channel.
Channel? channelByName(String name) {
  for (final Channel c in mockChannels) {
    if (c.name == name) return c;
  }
  return null;
}
