import 'package:bunpod/bunpod.dart';

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
  'The Mehdi Hasan Show':
      "Mehdi Hasan's fearless interviews and sharp analysis from his "
      'independent outlet Zeteo — holding power to account on politics, the '
      'media, and the Middle East, one uncomfortable question at a time.',
  'The Jordan B. Peterson Podcast':
      'Jordan B. Peterson in long-form conversation on psychology, mythology, '
      'meaning, and responsibility — lectures and interviews with scientists, '
      'artists, and cultural figures on how to live a life that matters.',
  'Y Combinator':
      'The team behind Y Combinator on how to build a startup — candid, '
      'tactical conversations on finding users, fundraising, product, and the '
      'hard lessons of company-building, straight from the source.',
  'Stuff You Should Know':
      'Josh Clark and Chuck Bryant explain how everything works — a curious, '
      'funny romp through science, history, and the delightfully random corners '
      'of the world, one topic at a time.',
  'The Minimalists':
      'Joshua Fields Millburn and Ryan Nicodemus on living a meaningful life '
      'with less — decluttering, intentional spending, and reclaiming your time '
      'and attention from a culture of more.',
  'The Joe Rogan Experience':
      'Long, unfiltered conversations with comedians, scientists, fighters, and '
      'free thinkers — Joe Rogan follows curiosity wherever it goes, from '
      'consciousness and combat sports to AI and the great outdoors.',
  'Good Inside with Dr. Becky':
      'Clinical psychologist Dr. Becky Kennedy on raising resilient kids and '
      'staying steady as a parent — warm, practical guidance on tantrums, '
      'boundaries, and the big feelings underneath everyday moments.',
  "Lenny's Podcast":
      'Lenny Rachitsky interviews the world’s best product leaders, founders, '
      'and growth experts — candid, tactical lessons on building products, '
      'finding product-market fit, and growing a career in tech.',
  'Office Ladies':
      'Jenna Fischer and Angela Kinsey rewatch every episode of The Office, '
      'sharing behind-the-scenes stories, trivia, and fan questions from the '
      'two best friends who lived it.',
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
