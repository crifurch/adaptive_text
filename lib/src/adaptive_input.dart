import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:adaptive_text/src/adaptive_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdaptiveInput extends AdaptiveWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType smartDashesType;
  final SmartQuotesType smartQuotesType;
  final bool enableSuggestions;
  final bool expands;
  final bool readOnly;
  final ToolbarOptions toolbarOptions;
  final bool? showCursor;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final DragStartBehavior dragStartBehavior;
  final GestureTapCallback? onTap;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final double? minWidth;
  final InputDecoration decoration;

  AdaptiveInput(
    String text, {
    Key? key,
    TextStyle? textStyle,
    int maxLines = 1,
    TextAlign textAlign = TextAlign.start,
    TextDirection textDirection = TextDirection.ltr,
    AdaptiveGroup? group,
    double heightAccurate = 0.7,
    this.controller,
    this.focusNode,
    TextInputType? keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.textAlignVertical,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    this.enableSuggestions = true,
    this.expands = false,
    this.readOnly = false,
    ToolbarOptions? toolbarOptions,
    this.showCursor,
    this.maxLength,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.onTap,
    this.buildCounter,
    this.scrollPhysics,
    this.scrollController,
    this.minWidth,
    this.decoration = const InputDecoration(),
  })  : smartDashesType = smartDashesType ??
            (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
        smartQuotesType = smartQuotesType ??
            (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
        keyboardType = keyboardType ??
            (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
        toolbarOptions = toolbarOptions ??
            (obscureText
                ? const ToolbarOptions(
                    selectAll: true,
                    paste: true,
                  )
                : const ToolbarOptions(
                    copy: true,
                    cut: true,
                    selectAll: true,
                    paste: true,
                  )),
        super(
          key: key,
          text: TextSpan(text: text, style: textStyle),
          maxLines: maxLines,
          textAlign: textAlign,
          textDirection: textDirection,
          group: group,
          heightAccurate: heightAccurate,
        );

  @override
  State<AdaptiveInput> createState() => _AdaptiveInputState();
}

class _AdaptiveInputState extends State<AdaptiveInput> with AdaptiveState {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = widget.controller ??
        TextEditingController(text: widget.text.toPlainText());
  }

  @override
  void didUpdateWidget(covariant AdaptiveInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != _textEditingController) {
      _textEditingController = widget.controller ?? _textEditingController;
    }
  }

  @override
  Widget buildAdaptive(BuildContext context, TextSpan text,
      TextStyle defaultStyle, double scale) {
    final style = defaultStyle.merge(
      text.style?.merge(
        TextStyle(
            fontSize: (text.style?.fontSize ?? defaultStyle.fontSize!) * scale),
      ),
    );
    return RepaintBoundary(
      child: EditableText(
        maxLines: widget.maxLines,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        style: style,
        autocorrect: widget.autocorrect,
        autofocus: widget.autofocus,
        backgroundCursorColor: Colors.black,
        //buildCounter: widget.buildCounter,
        controller: _textEditingController,
        cursorColor: widget.cursorColor ?? Colors.black,
        cursorRadius: widget.cursorRadius,
        cursorWidth: widget.cursorWidth,
        dragStartBehavior: widget.dragStartBehavior,
        //enabled: widget.enabled,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        enableSuggestions: widget.enableSuggestions,
        expands: widget.expands,
        //focusNode: widget.focusNode,
        inputFormatters: widget.inputFormatters,
        //keyboardAppearance: widget.keyboardAppearance,
        keyboardType: widget.keyboardType,
        //maxLength: widget.maxLength,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        onEditingComplete: widget.onEditingComplete,
        onSubmitted: widget.onSubmitted,
        //onTap: widget.onTap,
        readOnly: widget.readOnly,
        scrollController: widget.scrollController,
        scrollPadding: widget.scrollPadding,
        scrollPhysics: widget.scrollPhysics,
        selectionHeightStyle: widget.selectionHeightStyle,
        selectionWidthStyle: widget.selectionWidthStyle,
        showCursor: widget.showCursor,
        smartDashesType: widget.smartDashesType,
        smartQuotesType: widget.smartQuotesType,
        //textAlignVertical: widget.textAlignVertical,
        textCapitalization: widget.textCapitalization,
        textInputAction: widget.textInputAction,
        toolbarOptions: widget.toolbarOptions,
        focusNode: widget.focusNode ?? FocusNode(),
        //decoration: widget.decoration,
      ),
    );
  }
}
