import 'dart:async';
import 'dart:math';

import 'package:adaptive_text/src/utils/font_calculator.dart';
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
  final bool haveScrollableBody;

  const AdaptiveWidget({
    Key? key,
    required this.maxLines,
    required this.heightAccurate,
    required this.text,
    required this.textAlign,
    required this.textDirection,
    this.minFontSize,
    this.group,
    this.haveScrollableBody = false,
  }) : super(key: key);
}

mixin AdaptiveState<T extends AdaptiveWidget> on State<T> {
  double? fontScale;

  @override
  void initState() {
    widget.group?._updateFontSize(this, double.infinity);
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
    if (widget.text.compareTo(oldWidget.text) != RenderComparison.identical) {
      fontScale = null;
    }
    if (oldWidget.group != widget.group) {
      oldWidget.group?._remove(this);
      widget.group?._updateFontSize(this, double.infinity);
    }
  }

  Widget buildAdaptive(BuildContext context, TextSpan text,
      TextStyle defaultStyle, double scale);

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constrains) {
        // _lastMaxHeight ??= constrains.maxHeight;
        // _lastMaxWidth ??= constrains.maxWidth;
        // if (_lastMaxWidth == constrains.maxWidth &&
        //     _lastMaxHeight == constrains.maxHeight &&
        //     fontScale != null) {
        //   if (fontScale != null) {
        //     return buildAdaptive(context, widget.text,
        //         DefaultTextStyle.of(context).style, fontScale!);
        //   }
        // }
        // _lastMaxHeight = constrains.maxHeight;
        // _lastMaxWidth = constrains.maxWidth;

        final fontCalculator = FontCalculator(widget);
        var defaultFontSize =
            fontCalculator.getBiggestFromSpan(widget.text)?.fontSize;
        defaultFontSize ??= DefaultTextStyle.of(context).style.fontSize;
        final scale = MediaQuery.textScaleFactorOf(context);
        final span = TextSpan(
          text: widget.text.text,
          style: DefaultTextStyle.of(context).style.merge(widget.text.style),
          children: widget.text.children,
        );
        fontScale = fontCalculator.calculateFont(
          text: span,
          currentFontSize: defaultFontSize!,
          constrains: constrains.copyWith(
              maxWidth: widget.haveScrollableBody
                  ? double.infinity
                  : constrains.maxWidth),
          maxLines: widget.maxLines,
          scale: scale,
        );
        final size = fontCalculator.getBiggestFromSpan(span)!.fontSize!;
        widget.group?._updateFontSize(this, size * fontScale!);
        if (widget.group != null) {
          final minFont = min(widget.group!._fontSize, size);
          fontScale = min(fontScale!, minFont / size);
        }
        // print(
        //     '\x1B[31;1;4madaptive:${DateTime.now().difference(now).inMilliseconds}\x1B[0m');
        return buildAdaptive(context, widget.text,
            DefaultTextStyle.of(context).style, fontScale!);
      });

  void _notifySync() {
    setState(() {});
  }
}
