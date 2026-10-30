import 'package:bunpod/bunpod.dart';
import 'package:material_ui/material_ui.dart' hide MaterialShapes, MaterialShapeBorder, RoundedPolygon, CornerRounding;
import 'package:flutter/rendering.dart';
import 'package:expressive_shapes/expressive_shapes.dart';
import 'package:motor/motor.dart';

class _Tab {
  const _Tab({
    required this.channel,
    required this.label,
    required this.accent,
    required this.onAccent,
    this.image,
    this.shape,
    this.icon,
  });

  final Channel? channel;
  final String label;
  final Color accent;
  final Color onAccent;
  final String? image;
  final RoundedPolygon? shape;
  final IconData? icon;
}

/// Horizontal, single-select filter strip. The selected pill fills with its
/// own accent, morphs squarish → fully-rounded, and is auto-scrolled
/// into view (centered) like a Material scrollable TabBar.
class FeedChannelTabs extends StatefulWidget {
  const FeedChannelTabs({
    super.key,
    required this.channels,
    required this.selected,
    required this.onSelected,
    this.height = 44,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final List<Channel> channels;
  final Channel? selected;
  final ValueChanged<Channel?> onSelected;
  final double height;
  final EdgeInsetsGeometry padding;

  @override
  State<FeedChannelTabs> createState() => _FeedChannelTabsState();
}

class _FeedChannelTabsState extends State<FeedChannelTabs>
    with SingleTickerProviderStateMixin {
  final Map<int?, GlobalKey> _keys = {};

  final _scroll = ScrollController();

  // Spring that drives the scroll offset. Standard (not expressive) spatial /
  // fast token: the strip is navigation chrome, so it centers quickly and calmly
  // without the attention-grabbing overshoot of the expressive springs.
  late final SingleMotionController _scrollMotion =
      SingleMotionController(
        motion: MaterialSpringMotion.standardSpatialFast(),
        vsync: this,
      )..addListener(() {
        if (!_scroll.hasClients) return;
        final p = _scroll.position;
        _scroll.jumpTo(
          _scrollMotion.value.clamp(p.minScrollExtent, p.maxScrollExtent),
        );
      });

  @override
  void initState() {
    super.initState();
    if (widget.selected != null) _scrollToSelected();
  }

  @override
  void didUpdateWidget(FeedChannelTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) _scrollToSelected();
  }

  @override
  void dispose() {
    _scrollMotion.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToSelected() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      final keyContext = _keys[widget.selected?.id]?.currentContext;
      final box = keyContext?.findRenderObject();
      if (box is! RenderBox) return;

      final p = _scroll.position;
      final viewport = RenderAbstractViewport.of(box);
      final current = _scroll.offset;

      // Keep the selected chip within the comfortable middle band (25%..75% of
      // the viewport) rather than dead-center. If it's already in that band,
      // leave it. If it has drifted into the outer 25% margin (jammed near an
      // edge), nudge it just to the margin line so the neighbouring chip peeks
      // in — no full recenter.
      final near = viewport
          .getOffsetToReveal(box, 0.25)
          .offset; // 25% from lead
      final far = viewport
          .getOffsetToReveal(box, 0.75)
          .offset; // 25% from trail
      final lo = far < near ? far : near;
      final hi = far < near ? near : far;
      if (current >= lo - 0.5 && current <= hi + 0.5) return;

      final target = (current < lo ? lo : hi).clamp(
        p.minScrollExtent,
        p.maxScrollExtent,
      );
      _scrollMotion.animateTo(target, from: current);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    final List<_Tab> tabs = [
      _Tab(
        channel: null,
        label: 'All',
        accent: cs.primary,
        onAccent: cs.onPrimary,
        icon: Icons.grid_view_rounded,
      ),
      for (final Channel channel in widget.channels)
        _Tab(
          channel: channel,
          label: channel.title ?? '',
          accent: channel.scheme(context).primary,
          onAccent: channel.scheme(context).onPrimary,
          image: channel.image,
          shape: ShapeValues.coverFocused,
        ),
    ];

    return SizedBox(
      height: widget.height,
      child: ListView.builder(
        controller: _scroll,
        scrollDirection: Axis.horizontal,
        padding: widget.padding,
        itemCount: tabs.length,
        itemBuilder: (context, i) {
          final _Tab tab = tabs[i];
          return _FilterChip(
            key: _keys.putIfAbsent(tab.channel?.id, GlobalKey.new),
            tab: tab,
            selected: tab.channel?.id == widget.selected?.id,
            onTap: () => widget.onSelected(tab.channel),
          );
        },
      ),
    );
  }
}

/// A single pill. Fills with the tab's accent when selected, otherwise sits on a
/// calm surface. Material animates both the color and the shape morph.
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final _Tab tab;
  final bool selected;
  final VoidCallback onTap;

  // Idle corner radius. The selected chip springs out to a full pill.
  static const double _idleRadius = 12;
  static const double _pillRadius = 22;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      // Selection morph driven by a spring: as a chip becomes selected, `t`
      // springs 0 -> 1, rounding the corners squarish -> pill and drenching the
      // fill in its accent. Standard (calm) spatial/fast spring, since the strip
      // is chrome and shouldn't pull attention with an expressive overshoot.
      child: SingleMotionBuilder(
        motion: MaterialSpringMotion.standardSpatialFast(),
        value: selected ? 1.0 : 0.0,
        builder: (context, t, _) {
          final tc = t.clamp(0.0, 1.0);
          final bg = Color.lerp(cs.surfaceContainerHigh, tab.accent, tc)!;
          final fg = Color.lerp(cs.onSurfaceVariant, tab.onAccent, tc)!;
          final radius = _idleRadius + (_pillRadius - _idleRadius) * t;

          return Material(
            color: bg,
            // Let the spring be the sole driver: no implicit Material tween.
            animationDuration: Duration.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(radius < 0 ? 0 : radius),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  tab.image != null ? 6 : 14,
                  6,
                  16,
                  6,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (tab.image != null) ...[
                      ClipPath(
                        // Idle covers stay calm circles; only the selected
                        // chip's cover morphs to its expressive material shape.
                        clipper: ShapeBorderClipper(
                          shape: MaterialShapeBorder(
                            shape: selected
                                ? (tab.shape ?? MaterialShapes.circle)
                                : MaterialShapes.circle,
                          ),
                        ),
                        child: SizedBox(
                          width: 26,
                          height: 26,
                          child: SmoothImage(
                            url: tab.image!,
                            placeholderColor: cs.surfaceContainerHighest,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ] else if (tab.icon != null) ...[
                      Icon(tab.icon, size: 18, color: fg),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      tab.label,
                      style: tt.labelLarge?.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
