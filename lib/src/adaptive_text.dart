import 'package:flutter/material.dart';

import 'adaptive_widget.dart';

class AdaptiveText extends AdaptiveWidget {
  AdaptiveText(
    String text, {
    super.key,
    TextStyle? textStyle,
    super.maxLines = 1,
    super.textAlign = TextAlign.start,
    super.textDirection = TextDirection.ltr,
    super.group,
    super.heightAccurate = 0.7,
  }) : super(
          text: TextSpan(text: text, style: textStyle),
        );

  const AdaptiveText.rich(
    TextSpan text, {
    super.key,
    super.maxLines = 1,
    super.textAlign = TextAlign.start,
    super.textDirection = TextDirection.ltr,
    super.group,
    super.heightAccurate = 0.7,
  }) : super(
          text: text,
        );

  @override
  State<AdaptiveText> createState() => _AdaptiveTextState();
}

class _AdaptiveTextState extends State<AdaptiveText> with AdaptiveState {
  @override
  Widget buildAdaptive(BuildContext context, TextSpan text,
          TextStyle defaultStyle, double scale) =>
      Text.rich(
        text,
        maxLines: widget.maxLines,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
         softWrap: widget.maxLines>1,
         textScaleFactor: scale,
        style: defaultStyle,
      );
}
