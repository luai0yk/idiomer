import 'package:flutter/material.dart';
import 'package:idiomer/core/utils/extensions/context_extension.dart';

/// Renders text containing inline `**...**` highlight markers.
///
/// Spans wrapped in `**...**` are rendered with [highlightStyle] (or a bold
/// [highlightColor] accent by default) without literal asterisk markers.
/// Unmatched asterisks are preserved as plain text.
class HighlightedMarkupText extends StatelessWidget {
  const HighlightedMarkupText(
    this.text, {
    super.key,
    this.style,
    this.highlightStyle,
    this.highlightColor,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
  });

  static final RegExp _markupPattern = RegExp(r'\*\*(.+?)\*\*', dotAll: true);

  final String text;
  final TextStyle? style;
  final TextStyle? highlightStyle;
  final Color? highlightColor;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextOverflow? overflow;

  /// Removes all `**...**` markers from [input] while preserving inner text.
  static String stripMarkers(String input) {
    return input.replaceAllMapped(_markupPattern, (match) => match.group(1)!);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final matches = _markupPattern.allMatches(text);

    if (matches.isEmpty) {
      return Text(
        text,
        style: style,
        textAlign: textAlign,
        textDirection: textDirection,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final baseStyle = style ?? textTheme.bodyMedium;
    final accentStyle =
        highlightStyle ??
        baseStyle?.copyWith(
          color: highlightColor ?? colorScheme.primary,
          fontWeight: FontWeight.w800,
        ) ??
        TextStyle(
          color: highlightColor ?? colorScheme.primary,
          fontWeight: FontWeight.w800,
        );

    final spans = <InlineSpan>[];
    var cursor = 0;

    for (final match in matches) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, match.start)));
      }
      spans.add(TextSpan(text: match.group(1), style: accentStyle));
      cursor = match.end;
    }

    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }

    return Text.rich(
      TextSpan(style: baseStyle, children: spans),
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
