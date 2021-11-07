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
  double? fontSize;
  double? _lastMaxWidth;
  double? _lastMaxHeight;

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
      fontSize = null;
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
        final now = DateTime.now();
        _lastMaxHeight ??= constrains.maxHeight;
        _lastMaxWidth ??= constrains.maxWidth;
        if (_lastMaxWidth == constrains.maxWidth &&
            _lastMaxHeight == constrains.maxHeight &&
            fontSize != null) {
          if (fontSize != null) {
            return buildAdaptive(context, widget.text,
                DefaultTextStyle.of(context).style, fontSize!);
          }
        }
        _lastMaxHeight = constrains.maxHeight;
        _lastMaxWidth = constrains.maxWidth;


        final fontCalculator = FontCalculator(widget);
        var defaultFontSize =
            fontCalculator.getBiggestFromSpan(widget.text)?.fontSize;
        defaultFontSize ??= DefaultTextStyle.of(context).style.fontSize;

        fontSize = fontCalculator.calculateFont(
          text: widget.text,
          currentFontSize: defaultFontSize!,
          constrains: constrains,
          maxLines: widget.maxLines,
          scale: MediaQuery.textScaleFactorOf(context),
        );
        widget.group?._updateFontSize(this, fontSize!);
        print(
            '\x1B[31;1;4madaptive:${DateTime.now().difference(now).inMilliseconds}\x1B[0m');
        return buildAdaptive(context, widget.text,
            DefaultTextStyle.of(context).style, fontSize!);
      });

  void _notifySync() {
    setState(() {});
  }
}
