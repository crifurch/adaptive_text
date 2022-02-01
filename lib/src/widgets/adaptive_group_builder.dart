import 'package:adaptive_text/adaptive_text.dart';
import 'package:flutter/material.dart';

typedef AdaptiveBuilder = Widget Function(
    BuildContext context, AdaptiveGroup group);

class AdaptiveGroupBuilder extends StatefulWidget {
  final AdaptiveBuilder builder;

  const AdaptiveGroupBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  _AdaptiveGroupBuilderState createState() => _AdaptiveGroupBuilderState();
}

class _AdaptiveGroupBuilderState extends State<AdaptiveGroupBuilder> {
  final AdaptiveGroup _group = AdaptiveGroup();

  @override
  Widget build(BuildContext context) => widget.builder(context, _group);
}
