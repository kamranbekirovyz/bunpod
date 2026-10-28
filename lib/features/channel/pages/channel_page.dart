import 'package:bunpod/bunpod.dart';
import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:expressive_refresh_indicator/expressive_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:motor/motor.dart';

const double _kCoverSize = 168;
const double _kSubscribeHeight = 58;

class ChannelPage extends StatefulWidget {
  const ChannelPage({super.key, this.id, this.appleId, this.preview});

  final int? id;
  final int? appleId;
  final ChannelPreview? preview;

  static Route<void> route({int? id, int? appleId, ChannelPreview? preview}) {
    return MaterialPageRoute<void>(
      builder: (context) =>
          ChannelPage(id: id, appleId: appleId, preview: preview),
    );
  }

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  late final ChannelCubit _channelCubit;
  late final ChannelEpisodesCubit _episodesCubit;
  late final ChannelFollowCubit _followCubit;

  bool _entered = false;

  @override
  void initState() {
    super.initState();
    _channelCubit = ChannelCubit();
    _episodesCubit = ChannelEpisodesCubit();
    _followCubit = ChannelFollowCubit();
    _load();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _entered = true);
    });
  }

  @override
  void dispose() {
    _channelCubit.close();
    _episodesCubit.close();
    _followCubit.close();
    super.dispose();
  }

  Future<void> _load() async {
    await _channelCubit.load(id: widget.id, appleId: widget.appleId);

    final Channel? channel = _channelCubit.state;
    final int? id = channel?.id;

    _followCubit.set(channel?.subscribed);
    if (id != null) await _episodesCubit.load(id: id);
  }

  void _toggleFollow() {
    final int? id = _channelCubit.state?.id;

    if (id != null && _followCubit.state != null) _followCubit.toggle(id: id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelCubit, Channel?>(
      bloc: _channelCubit,
      builder: (context, channel) {
        return BlocBuilder<ChannelFollowCubit, bool?>(
          bloc: _followCubit,
          builder: (context, subscribed) {
            return _ChannelView(
              channel: channel,
              preview: widget.preview,
              fallbackId: widget.id,
              subscribed: subscribed,
              entered: _entered,
              episodesCubit: _episodesCubit,
              onRefresh: _load,
              onSubscribe: _toggleFollow,
            );
          },
        );
      },
    );
  }
}

class _ChannelView extends StatelessWidget {
  const _ChannelView({
    required this.channel,
    required this.preview,
    required this.fallbackId,
    required this.subscribed,
    required this.entered,
    required this.episodesCubit,
    required this.onRefresh,
    required this.onSubscribe,
  });

  final Channel? channel;
  final ChannelPreview? preview;
  final int? fallbackId;
  final bool? subscribed;
  final bool entered;
  final ChannelEpisodesCubit episodesCubit;
  final Future<void> Function() onRefresh;
  final VoidCallback onSubscribe;

  @override
  Widget build(BuildContext context) {
    final int? id = channel?.id ?? fallbackId;
    final ColorScheme cs = id == null
        ? Theme.of(context).colorScheme
        : Channel.schemeOf(context, id);
    final TextTheme tt = Theme.of(context).textTheme;

    final String title = channel?.title ?? preview?.title ?? '';
    final String author = channel?.author ?? preview?.author ?? '';
    final String image = channel?.image ?? preview?.image ?? '';
    final String description = (channel?.description ?? '')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();

    // The header collapses from a full hero down to a plain back-button bar, so
    // measure the channel name to know exactly how tall the expanded state is.
    final double topPad = MediaQuery.paddingOf(context).top;
    final double maxW = MediaQuery.sizeOf(context).width - 48;
    final TextStyle hostStyle = (tt.labelMedium ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: 0.8,
    );
    final TextPainter hostPainter = TextPainter(
      text: TextSpan(text: author.toUpperCase(), style: hostStyle),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: maxW);

    final TextStyle nameStyle = (tt.displaySmall ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.w800,
      height: 1.05,
    );
    final TextPainter namePainter = TextPainter(
      text: TextSpan(text: title, style: nameStyle),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxW);

    final double minExtent = topPad + kToolbarHeight;
    final double maxExtent =
        minExtent +
        8 +
        _kCoverSize +
        20 +
        hostPainter.height +
        8 +
        namePainter.height +
        24 +
        _kSubscribeHeight;

    return Scaffold(
      backgroundColor: cs.surface,
      body: ExpressiveRefreshIndicator(
        onRefresh: onRefresh,
        color: cs.onPrimaryContainer,
        backgroundColor: cs.primaryContainer,
        edgeOffset: topPad + kToolbarHeight,
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _ChannelHeaderDelegate(
                title: title,
                author: author,
                image: image,
                scheme: cs,
                topPad: topPad,
                minExtentValue: minExtent,
                maxExtentValue: maxExtent,
                entered: entered,
                subscribed: subscribed,
                onSubscribe: onSubscribe,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (description.isNotEmpty) ...[
                      Text(
                        description,
                        style: tt.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      28.gap,
                    ],
                    Text(
                      'Episodes',
                      style: GoogleFonts.unbounded(
                        textStyle: tt.titleLarge,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        color: cs.onSurface,
                      ),
                    ),
                    12.gap,
                  ],
                ),
              ),
            ),
            BlocBuilder<ChannelEpisodesCubit, List<Episode>?>(
              bloc: episodesCubit,
              builder: (context, episodes) {
                if (episodes == null) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: Center(child: LoadingIndicator()),
                    ),
                  );
                }

                return SliverList.builder(
                  itemCount: episodes.length,
                  itemBuilder: (context, i) {
                    final Episode episode = episodes[i];

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                      child: FeedEpisodeCard(
                        episode: episode,
                        playing: false,
                        onTap: () => Navigator.of(
                          context,
                        ).push(PlayerPage.route(episode, fromChannel: true)),
                      ),
                    );
                  },
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

/// Collapsing channel header. The back button is pinned at the top at all times;
/// everything else (cover, host, name, subscribe) parallaxes upward and fades as
/// the user scrolls, while a compact channel name crossfades into the bar.
class _ChannelHeaderDelegate extends SliverPersistentHeaderDelegate {
  _ChannelHeaderDelegate({
    required this.title,
    required this.author,
    required this.image,
    required this.scheme,
    required this.topPad,
    required this.minExtentValue,
    required this.maxExtentValue,
    required this.entered,
    required this.subscribed,
    required this.onSubscribe,
  });

  final String title;
  final String author;
  final String image;
  final ColorScheme scheme;
  final double topPad;
  final double minExtentValue;
  final double maxExtentValue;
  final bool entered;
  final bool? subscribed;
  final VoidCallback onSubscribe;

  @override
  double get minExtent => minExtentValue;

  @override
  double get maxExtent => maxExtentValue;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    final ColorScheme cs = scheme;
    final TextTheme tt = Theme.of(context).textTheme;
    final double range = maxExtentValue - minExtentValue;
    final double t = range <= 0 ? 1 : (shrinkOffset / range).clamp(0.0, 1.0);

    // Hero fades out a touch before fully collapsed so it's gone by the time the
    // compact title takes over.
    final double heroOpacity = (1 - t * 1.25).clamp(0.0, 1.0);
    final double barTitleOpacity = ((t - 0.45) / 0.55).clamp(0.0, 1.0);

    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: cs.surface),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: heroOpacity,
              child: Transform.translate(
                offset: Offset(0, -shrinkOffset * 0.4),
                child: IgnorePointer(
                  ignoring: t > 0.5,
                  child: _hero(context, cs, tt),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: kToolbarHeight,
                child: Row(
                  children: [
                    StyledBackButton(color: cs.onSurface),
                    Expanded(
                      child: Opacity(
                        opacity: barTitleOpacity,
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: tt.titleMedium?.copyWith(
                            color: cs.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context, ColorScheme cs, TextTheme tt) {
    return Column(
      children: [
        // Reserve the pinned bar's space so the cover sits below the back button.
        SizedBox(height: topPad + kToolbarHeight),
        8.gap,
        SingleMotionBuilder(
          motion: const MaterialSpringMotion.expressiveSpatialSlow(),
          value: entered ? 1.0 : 0.0,
          builder: (context, t, child) {
            final double tc = t.clamp(0.0, 1.0);
            return Opacity(
              opacity: tc,
              child: Transform.scale(scale: 0.8 + 0.2 * t, child: child),
            );
          },
          child: ClipPath(
            clipper: ShapeBorderClipper(
              shape: MaterialShapeBorder(shape: ShapeValues.cover),
            ),
            child: SizedBox(
              width: _kCoverSize,
              height: _kCoverSize,
              child: _Cover(image: image, scheme: cs),
            ),
          ),
        ),
        20.gap,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            author.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tt.labelMedium?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        8.gap,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: tt.displaySmall?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
        ),
        24.gap,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _SubscribeButton(
            subscribed: subscribed,
            scheme: cs,
            onTap: onSubscribe,
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant _ChannelHeaderDelegate old) {
    return old.title != title ||
        old.author != author ||
        old.image != image ||
        old.scheme != scheme ||
        old.topPad != topPad ||
        old.minExtentValue != minExtentValue ||
        old.maxExtentValue != maxExtentValue ||
        old.entered != entered ||
        old.subscribed != subscribed;
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.image, required this.scheme});

  final String image;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final Widget glyph = Icon(
      Icons.podcasts_rounded,
      color: scheme.onPrimaryContainer,
      size: 48,
    );
    return SmoothImage(
      url: image,
      placeholderColor: scheme.primaryContainer,
      placeholderChild: glyph,
      errorChild: glyph,
    );
  }
}

/// Full-width expressive subscribe toggle. Not subscribed is the loud primary
/// call-to-action; subscribed settles into a calm tonal pill, and the corners
/// morph squarer as it flips. A spring drives the colour/shape, plus a
/// press-scale for tactility.
class _SubscribeButton extends StatefulWidget {
  const _SubscribeButton({
    required this.subscribed,
    required this.scheme,
    required this.onTap,
  });

  final bool? subscribed;
  final ColorScheme scheme;
  final VoidCallback onTap;

  @override
  State<_SubscribeButton> createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<_SubscribeButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = widget.scheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: SingleMotionBuilder(
          motion: const MaterialSpringMotion.expressiveSpatialFast(),
          value: widget.subscribed == true ? 1.0 : 0.0,
          builder: (context, t, _) {
            final double tc = t.clamp(0.0, 1.0);
            final Color bg = Color.lerp(
              cs.primary,
              cs.surfaceContainerHigh,
              tc,
            )!;
            final Color fg = Color.lerp(cs.onPrimary, cs.onSurface, tc)!;
            final double radius = 30 - 12 * tc;
            return Container(
              height: _kSubscribeHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(radius < 0 ? 0 : radius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.subscribed == true
                        ? Icons.check_rounded
                        : Icons.add_rounded,
                    size: 22,
                    color: fg,
                  ),
                  10.gap,
                  Text(
                    widget.subscribed == true ? 'Subscribed' : 'Subscribe',
                    style: tt.titleMedium?.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
