import 'dart:math';

import 'package:adaptive_text/src/adaptive_widget.dart';
import 'package:adaptive_text/src/utils/inline_span_extensions.dart';
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

  double calculateFont(
    InlineSpan text,
    double currentFontSize,
    BoxConstraints constrains,
    int maxLines, {
    int tries = 0,
  }) {
    if (text is TextSpan && text.text == null) {
      return currentFontSize;
    }
    if (tries >= 25) {
      return currentFontSize;
    }

    final tp = TextPainter(
      text: text,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      maxLines: maxLines,
    );
    tp.layout(maxWidth: maxLines > 1 ? constrains.maxWidth : double.infinity);
    if (maxLines > 1) {
      final tp2 = TextPainter(
        text: text,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        maxLines: 100000,
      );
      tp2.layout(maxWidth: constrains.maxWidth);

      if (tp2.height > tp.height) {
        var scaleFactor = tp.height / tp2.height;
        scaleFactor = max(scaleFactor, widget.heightAccurate);

        return calculateFont(
          text.scaleFontSize(scaleFactor),
          currentFontSize * scaleFactor,
          constrains,
          maxLines,
          tries: tries + 1,
        );
      }
    }

    if (tp.width <= 1 || tp.height <= 1) {
      return currentFontSize;
    }

    var scaleDownWid = 1.0;
    var scaleDownHei = 1.0;
    if (tp.width > constrains.maxWidth) {
      scaleDownWid = constrains.maxWidth / tp.width;
    }
    if (tp.height > constrains.maxHeight) {
      scaleDownHei = constrains.maxHeight / tp.height;
      scaleDownHei = max(scaleDownHei, widget.heightAccurate);
    }

    final min2 = min(scaleDownWid, scaleDownHei);
    if (min2 == 1) {
      return currentFontSize;
    }
    final scaleFactor = min(min2, 0.99);

    return calculateFont(
      text.scaleFontSize(scaleFactor),
      currentFontSize * scaleFactor,
      constrains,
      maxLines,
      tries: tries + 1,
    );
  }
}
