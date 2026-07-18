import 'package:bunpod_flutter/bunpod_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_shapes/material_shapes.dart';

/// "Crafted by {bun} Kamran Bekirov" footer; opens the [DeveloperSheet].
class DeveloperSignature extends StatelessWidget {
  const DeveloperSignature({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme tt = Theme.of(context).textTheme;

    final TextStyle style = GoogleFonts.nanumPenScript(
      textStyle: tt.titleMedium,
      color: cs.onSurfaceVariant,
    );

    return Material(
      color: Colors.transparent,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          DeveloperSheet.show(context);
        },
        child: Container(
          height: 48,
          padding: const .symmetric(horizontal: 40),
          alignment: .center,
          child: Row(
            mainAxisSize: .min,
            children: [
              Text(
                'Crafted by',
                style: style,
              ),
              8.gap,
              ClipPath(
                clipper: ShapeBorderClipper(
                  shape: MaterialShapeBorder(
                    shape: MaterialShapes.bun,
                  ),
                ),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: SmoothImage(
                    url: AppValues.makerImageUrl,
                  ),
                ),
              ),
              4.gap,
              Text(
                AppValues.makerName,
                style: style,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
