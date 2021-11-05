import 'package:flutter/material.dart';

extension MergeStyleSpan on InlineSpan {
  InlineSpan _transformStyleRecursive(
      TextStyle? Function(TextStyle? style) transformer) {
    final mergedStyle = style?.merge(transformer(style));
    if (this is TextSpan) {
      final thisSpan = this as TextSpan;
      List<InlineSpan>? children;
      if (thisSpan.children != null) {
        children = [];
        for (final element in thisSpan.children!) {
          children.add(element._transformStyleRecursive(transformer));
        }
      }
      return TextSpan(
        text: thisSpan.text,
        children: children,
        style: mergedStyle,
        recognizer: thisSpan.recognizer,
        mouseCursor: thisSpan.mouseCursor,
        onEnter: thisSpan.onEnter,
        onExit: thisSpan.onExit,
        semanticsLabel: thisSpan.semanticsLabel,
        locale: thisSpan.locale,
        spellOut: thisSpan.spellOut,
      );
    } else {
      final thisSpan = this as WidgetSpan;
      return WidgetSpan(
        child: thisSpan.child,
        alignment: thisSpan.alignment,
        baseline: thisSpan.baseline,
        style: mergedStyle,
      );
    }
  }

  InlineSpan scaleFontSize(double scale) => _transformStyleRecursive(
        (style) {
          var mainFontSize = style?.fontSize;
          if (mainFontSize != null) {
            mainFontSize = mainFontSize * scale;
          }
          return style?.merge(TextStyle(fontSize: mainFontSize));
        },
      );

  InlineSpan mergeStyleRecursive(TextStyle style) =>
      _transformStyleRecursive((style1) => style1?.merge(style));

  InlineSpan mergeStyle(TextStyle style) {
    final mergedStyle = this.style?.merge(style);
    if (this is TextSpan) {
      final thisSpan = this as TextSpan;
      return TextSpan(
        text: thisSpan.text,
        children: thisSpan.children,
        style: mergedStyle,
        recognizer: thisSpan.recognizer,
        mouseCursor: thisSpan.mouseCursor,
        onEnter: thisSpan.onEnter,
        onExit: thisSpan.onExit,
        semanticsLabel: thisSpan.semanticsLabel,
        locale: thisSpan.locale,
        spellOut: thisSpan.spellOut,
      );
    } else {
      final thisSpan = this as WidgetSpan;
      return WidgetSpan(
        child: thisSpan.child,
        alignment: thisSpan.alignment,
        baseline: thisSpan.baseline,
        style: mergedStyle,
      );
    }
  }

  InlineSpan mergeDefaultRecursive(BuildContext context) =>
      _transformStyleRecursive(
        (style) =>
            style?.merge(DefaultTextStyle.of(context).style.merge(style)),
      );
}
