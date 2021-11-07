import 'dart:math';

import 'package:adaptive_text/src/adaptive_widget.dart';
import 'package:flutter/material.dart';

class FontCalculator {
  final AdaptiveWidget widget;

  FontCalculator(this.widget);

  TextStyle? getBiggestFromSpan(TextSpan span) {
    var resultStyle = span.style;
    span.visitChildren((span) {
      if ((span.style?.fontSize ?? 0) > (resultStyle?.fontSize ?? 0)) {
        resultStyle = span.style;
      }
      return true;
    });
    return resultStyle;
  }

  double _proccesSingleLine({
    required InlineSpan text,
    required double scale,
    required BoxConstraints constrains,
  }) {
    final tp = TextPainter(
      text: text,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      maxLines: 1,
      textScaleFactor: scale,
    );
    tp.layout(maxWidth: double.infinity);
    var scaleHeight = 1.0;
    var scaleWidth = 1.0;
    if (tp.width > constrains.maxWidth) {
      scaleWidth = constrains.maxWidth / tp.width;
    }
    if (tp.height > constrains.maxHeight) {
      scaleHeight = constrains.maxHeight / tp.height;
    }
    final scaleDown = min(scaleHeight, scaleWidth);
    if (scaleDown == 1) {
      return scale;
    }
    return scale * scaleDown * 0.97;
  }

  double _proccesMultiLine({
    required InlineSpan text,
    required double scale,
    required BoxConstraints constrains,
    required int maxlines,
  }) {
    final directLinesCount = text.toPlainText().allMatches(r'\n').length + 1;
    final linesCount = min(directLinesCount, maxlines);
    final tp = TextPainter(
      text: text,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      maxLines: directLinesCount,
      textScaleFactor: scale,
    );
    tp.layout(maxWidth: double.infinity);
    var scaleDown = 1.0;
    if (tp.height > constrains.maxHeight) {
      scaleDown = constrains.maxHeight / tp.height;
    }
    if (tp.width > constrains.maxWidth) {
      scaleDown = min(constrains.maxWidth / tp.width, scaleDown);
    }
    final linesMetric1 = tp.computeLineMetrics();
    var scaledTextHei1 = 0.0;
    for (final element in linesMetric1) {
      scaledTextHei1 += element.height;
      scaledTextHei1 += element.ascent;
      scaledTextHei1 += element.ascent;
    }

    log(
      'scaleDown: $scaleDown\n'
      'textHei: $scaledTextHei1\n'
      'linesCount: ${linesMetric1.length}\n'
      'tpHeight: ${tp.height}\n'
      'tpWid: ${tp.width}\n'
      'constrainsWid: ${constrains.maxWidth}\n'
      'constrainsHeight: ${constrains.maxHeight}',
    );
    final tp2 = TextPainter(
      text: text,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      maxLines: linesCount,
      textScaleFactor: scale * scaleDown,
    );

    tp2.layout(maxWidth: constrains.maxWidth);
    final linesMetric = tp2.computeLineMetrics();
    var scaledTextHei = 0.0;
    for (final element in linesMetric) {
      scaledTextHei += element.height;
      scaledTextHei += element.ascent;
      scaledTextHei += element.ascent;
    }
    var scaleDown2 = 1.0;
    if (tp2.height > constrains.maxHeight) {
      scaleDown2 = constrains.maxHeight / tp2.height;
    }
    log(
      'scaleDown2: $scaleDown2\n'
      'textHei: $scaledTextHei\n'
      'test: ${constrains.maxHeight / maxlines}\n'
      'linesCount: ${linesMetric.length}\n'
      'tp2Height: ${tp2.height}\n'
      'tp2Wid: ${tp2.width}\n'
      'constrainsWid: ${constrains.maxWidth}\n'
      'constrainsHeight: ${constrains.maxHeight}',
    );
    if (scaledTextHei < constrains.maxHeight) {
      final freeSpace = (constrains.maxHeight - scaledTextHei);
      final perLineSize = constrains.maxHeight / maxlines;
      scaleDown2 = perLineSize / scaledTextHei;
    }
    tp2.didExceedMaxLines;
    return scale * scaleDown * scaleDown2;
  }

  double calculateFont({
    required InlineSpan text,
    required double currentFontSize,
    required BoxConstraints constrains,
    required double scale,
    int maxLines = 1,
    int tries = 0,
  }) {
    if (text is TextSpan && text.text == null) {
      return scale;
    }
    if (maxLines == 1) {
      return _proccesSingleLine(
          text: text, scale: scale, constrains: constrains);
    } else {
      return _proccesMultiLine(
        text: text,
        scale: scale,
        constrains: constrains,
        maxlines: maxLines,
      );
    }
  }

  log(String message) {
    print('\x1B[32;1;4m${'=' * 40}\n$message\n${'=' * 40}\x1B[0m');
  }
}
