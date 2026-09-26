import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Text with tappable stretches marked inline as `<link>Terms</link>`.
///
/// Keeping the markers in the string is what makes this translatable: a
/// sentence can put its links anywhere, in any order, without the layout
/// knowing. [onTap] is handed the label that was tapped, so one callback
/// serves every link in the sentence.
class LinkedText extends StatefulWidget {
  final String text;
  final void Function(String label) onTap;
  final TextStyle style;
  final Color linkColor;
  final TextAlign textAlign;

  const LinkedText({
    super.key,
    required this.text,
    required this.onTap,
    required this.linkColor,
    required this.style,
    this.textAlign = .center,
  });

  @override
  State<LinkedText> createState() => _LinkedTextState();
}

class _LinkedTextState extends State<LinkedText> {
  static final RegExp _pattern = RegExp(
    r'<link>(.*?)</link>',
    dotAll: true,
  );

  List<RegExpMatch> _matches = <RegExpMatch>[];
  List<TapGestureRecognizer> _recognizers = <TapGestureRecognizer>[];

  @override
  void initState() {
    super.initState();

    _parse();
  }

  @override
  void didUpdateWidget(LinkedText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text) {
      _disposeRecognizers();
      _parse();
    }
  }

  @override
  void dispose() {
    _disposeRecognizers();

    super.dispose();
  }

  void _parse() {
    _matches = _pattern.allMatches(widget.text).toList();

    _recognizers = List<TapGestureRecognizer>.generate(
      _matches.length,
      (int index) {
        final String label = _matches[index].group(1) ?? '';

        return TapGestureRecognizer()
          ..onTap = () {
            widget.onTap(label);
          };
      },
    );
  }

  void _disposeRecognizers() {
    for (final TapGestureRecognizer recognizer in _recognizers) {
      recognizer.dispose();
    }

    _recognizers = <TapGestureRecognizer>[];
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle style = widget.style;
    final TextStyle linkStyle = style.copyWith(
      color: widget.linkColor,
      fontWeight: .w600,
    );

    if (_matches.isEmpty) {
      return Text(
        widget.text,
        style: style,
        textAlign: widget.textAlign,
      );
    }

    final List<InlineSpan> spans = <InlineSpan>[];
    int cursor = 0;

    for (int index = 0; index < _matches.length; index++) {
      final RegExpMatch match = _matches[index];
      final String before = widget.text.substring(cursor, match.start);

      if (before.isNotEmpty) {
        spans.add(
          TextSpan(
            text: before,
          ),
        );
      }

      spans.add(
        TextSpan(
          text: match.group(1) ?? '',
          style: linkStyle,
          recognizer: _recognizers[index],
        ),
      );

      cursor = match.end;
    }

    final String tail = widget.text.substring(cursor);

    if (tail.isNotEmpty) {
      spans.add(
        TextSpan(
          text: tail,
        ),
      );
    }

    return Text.rich(
      TextSpan(
        children: spans,
        style: style,
      ),
      textAlign: widget.textAlign,
    );
  }
}
