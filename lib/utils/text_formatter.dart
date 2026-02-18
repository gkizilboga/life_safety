import 'package:flutter/material.dart';

class TextFormatter {
  /// Parses a string containing ... tags and returns a TextSpan.
  static TextSpan parse(
    String text, {
    required TextStyle baseStyle,
    TextStyle? boldStyle,
  }) {
    final List<InlineSpan> spans = [];
    final RegExp regExp = RegExp(r'(.*?)', dotAll: true);

    int lastMatchEnd = 0;
    final matches = regExp.allMatches(text);

    for (final match in matches) {
      // Add text before the match
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: baseStyle,
          ),
        );
      }

      // Add the bolded text
      spans.add(
        TextSpan(
          text: match.group(1),
          style: boldStyle ?? baseStyle.copyWith(fontWeight: FontWeight.bold),
        ),
      );

      lastMatchEnd = match.end;
    }

    // Add remaining text
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd), style: baseStyle));
    }

    return TextSpan(children: spans, style: baseStyle);
  }
}

/// A widget that renders text with  tags support.
class FormattedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const FormattedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? DefaultTextStyle.of(context).style;

    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      text: TextFormatter.parse(text, baseStyle: baseStyle),
    );
  }
}
