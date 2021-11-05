import 'dart:async';
import 'dart:math';

import 'package:adaptive_text/src/utils/font_calculator.dart';
import 'package:adaptive_text/src/utils/inline_span_extensions.dart';
import 'package:flutter/material.dart';

part 'adaptive_group.dart';

abstract class AdaptiveWidget extends StatefulWidget {
  final double? minFontSize;
  final int maxLines;
  final AdaptiveGroup? group;
  final double heightAccurate;

  final TextSpan text;
  final TextAlign textAlign;
  final TextDirection textDirection;

  const AdaptiveWidget({
    Key? key,
    required this.maxLines,
    required this.heightAccurate,
    required this.text,
    required this.textAlign,
    required this.textDirection,
    this.minFontSize,
    this.group,
  }) : super(key: key);
}

mixin AdaptiveState<T extends AdaptiveWidget> on State<T> {
  late double fontSize;

  @override
  void initState() {
    fontSize = widget.text.style?.fontSize ?? 10000;

    widget.group?._updateFontSize(this, fontSize);
    super.initState();
  }

  @override
  void dispose() {
    widget.group?._remove(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.group != widget.group) {
      oldWidget.group?._remove(this);
      widget.group?._updateFontSize(this, double.infinity);
    }
  }

  Widget buildAdaptive(BuildContext context, TextSpan text);

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constrains) {
        final now = DateTime.now();
        final fontCalculator = FontCalculator(widget);
        var defaultFontSize =
            fontCalculator.getBiggestFromSpan(widget.text)?.fontSize;
        defaultFontSize ??= DefaultTextStyle.of(context).style.fontSize;
        final processSpan = widget.text.mergeDefaultRecursive(context);

        fontSize = fontCalculator.calculateFont(
          processSpan,
          defaultFontSize!,
          constrains,
          widget.maxLines,
        );
        widget.group?._updateFontSize(this, fontSize);
        fontSize = min(fontSize, widget.group?._fontSize ?? double.infinity);
        fontSize = max(widget.minFontSize ?? 0, fontSize);
        final resultSpan =
            widget.text.scaleFontSize(fontSize / defaultFontSize) as TextSpan;
        print('adaptive:${DateTime.now().difference(now).inMilliseconds}');
        return buildAdaptive(context, resultSpan);
      });

  void _notifySync() {
    setState(() {});
  }
}
