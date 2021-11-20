import 'dart:math';
import 'dart:ui';

import 'package:adaptive_text/src/adaptive_widget.dart';
import 'package:flutter/material.dart';

class FontCalculator {
  final AdaptiveWidget widget;

  FontCalculator(this.widget);

  double calculateFont({
    required TextSpan text,
    required double currentFontSize,
    required BoxConstraints constrains,
    required double scale,
    int maxLines = 1,
    int tries = 0,
  }) {
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

  double _proccesSingleLine({
    required TextSpan text,
    required double scale,
    required BoxConstraints constrains,
  }) {
    final tp = TextPainter(
      text: text,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      maxLines: 1,
      textWidthBasis: TextWidthBasis.longestLine,
      textScaleFactor: scale,
    );
    tp.layout(maxWidth: double.infinity);
    var scaleHeight = 1.0;
    var scaleWidth = 1.0;
    final textHeight = tp.height;
    final textWidth = tp.width;
    if (textWidth > constrains.maxWidth) {
      scaleWidth = constrains.maxWidth / textWidth;
    }
    if (textHeight > constrains.maxHeight) {
      scaleHeight = constrains.maxHeight / textHeight;
    }
    return min(scaleHeight, scaleWidth) * scale;
  }

  double _proccesMultiLine({
    required TextSpan text,
    required double scale,
    required BoxConstraints constrains,
    required int maxlines,

  }) {
    var oe1 = checkFitsOverflow(
      text,
      maxlines,
      scale,
      constrains.biggest,
      constrainWidth: constrains.maxWidth,
    );
    if (oe1.fit) {
      return scale;
    }
    var scaleDown = 1.0;
    while (!oe1.fit) {
      var sK = oe1.overflowSize.height / constrains.maxHeight;
      var lK = oe1.overflowLines / maxlines;
      //todo Make maxLines fits k
      lK = 1;
      if (oe1.overflowLines == 0) {
        lK = 1;
      }
      lK = lK.clamp(0, 1);
      sK = sK.clamp(0, 1);
      scaleDown *= lerpDouble(0.97, 0.6, sK)!;
      oe1 = checkFitsOverflow(
        text,
        maxlines,
        scale * scaleDown,
        constrains.biggest,
        constrainWidth: constrains.maxWidth,
      );
      log3(oe1.toString());
    }

    return scale * scaleDown;
  }

  OverflowEntry checkFitsOverflow(
      TextSpan text, int maxLines, double scale, Size container,
      {double? constrainWidth, bool checkLines = false}) {
    final tp = TextPainter(
      text: text,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      maxLines: 10000000,
      textScaleFactor: scale,
    );
    tp.layout(maxWidth: constrainWidth ?? double.maxFinite);
   // final lines = tp.computeLineMetrics();
    final overflowEntry = OverflowEntry(
      Size(
        max(tp.width - container.width, 0),
        max(tp.height - container.height, 0),
      ),
      0,//max(lines.length - maxLines, 0),
    );

    return overflowEntry;
  }

  log(String message) {
    print('\x1B[32;1;4m${'=' * 40}\n$message\n${'=' * 40}\x1B[0m');
  }

  log2(String message) {
    print('\x1B[31;1;4m${'=' * 40}\n$message\n${'=' * 40}\x1B[0m');
  }

  log3(String message) {
    print('\x1B[34;1;4m${'=' * 40}\n$message\n${'=' * 40}\x1B[0m');
  }

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

  TextStyle? getMinimalFromSpan(TextSpan span) {
    TextStyle? resultStyle;
    span.visitChildren((span) {
      if ((span.style?.fontSize ?? 0) <
          (resultStyle?.fontSize ?? double.maxFinite)) {
        resultStyle = span.style;
      }
      return true;
    });
    return resultStyle;
  }
}

class OverflowEntry {
  final Size overflowSize;
  final int overflowLines;

  bool get fit => overflowSize == Size.zero && overflowLines == 0;

  OverflowEntry(this.overflowSize, this.overflowLines);

  @override
  String toString() => 'OverflowEntry: \n'
      'width: ${overflowSize.width}\n'
      'height: ${overflowSize.height}\n'
      'overflow:$overflowLines';
}
