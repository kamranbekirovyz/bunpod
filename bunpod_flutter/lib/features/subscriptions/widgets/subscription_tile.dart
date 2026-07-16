import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:bunpod_flutter/features/subscriptions/widgets/unsubscribe_swipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:material_shapes/material_shapes.dart';

/// One followed show in the library list: shaped cover, host, name. Drag the
/// row left to unsubscribe, or long-press for the same confirmation if you'd
/// rather not use the gesture.
class SubscriptionTile extends StatelessWidget {
  const SubscriptionTile({
    super.key,
    required this.channel,
    required this.borderRadius,
    required this.onTap,
    required this.onUnsubscribe,
    this.removing = false,
    this.onRemoved,
  });

  final Channel channel;
  final BorderRadius borderRadius;
  final VoidCallback onTap;

  /// Asks to unsubscribe, resolving true once the row is on its way out.
  final Future<bool> Function() onUnsubscribe;

  /// When flipped to true, the row plays its removal and calls [onRemoved]
  /// once its slot has closed. Only then should the owner drop it.
  final bool removing;
  final VoidCallback? onRemoved;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    return RemovalCollapse(
      removing: removing,
      onRemoved: onRemoved,
      child: Semantics(
        button: true,
        label: '${channel.name}, ${channel.host}',
        // The swipe is a shortcut, not the only way out.
        customSemanticsActions: <CustomSemanticsAction, VoidCallback>{
          const CustomSemanticsAction(label: 'Unsubscribe'): onUnsubscribe,
        },
        child: UnsubscribeSwipe(
          borderRadius: borderRadius,
          onConfirm: onUnsubscribe,
          child: Material(
            color: cs.surfaceContainer,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            clipBehavior: .antiAlias,
            child: InkWell(
              onTap: onTap,
              onLongPress: onUnsubscribe,
              child: Padding(
                padding: const .fromLTRB(12, 12, 16, 12),
                child: Row(
                  children: [
                    ClipPath(
                      clipper: ShapeBorderClipper(
                        shape: MaterialShapeBorder(shape: ShapeValues.cover),
                      ),
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: SmoothImage(
                          url: channel.image,
                          placeholderColor: channel.seed,
                          placeholderChild: Icon(
                            Icons.podcasts_rounded,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    14.gap,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        mainAxisSize: .min,
                        children: [
                          Text(
                            channel.host.toUpperCase(),
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: tt.labelSmall?.copyWith(
                              color: cs.onSurfaceVariant,
                              fontWeight: .w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                          2.gap,
                          Text(
                            channel.name,
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: tt.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

