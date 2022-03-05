import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget(
      {Key? key,
      this.left,
      this.center,
      this.right,
      this.expanded = true,
      this.crossAxisAlignment = CrossAxisAlignment.center})
      : super(key: key);
  final Widget? left;
  final Widget? center;
  final Widget? right;
  final bool expanded;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        left ?? const SizedBox.shrink(),
        expanded
            ? Expanded(child: center ?? const SizedBox.shrink())
            : Flexible(child: center ?? const SizedBox.shrink()),
        right ?? const SizedBox.shrink(),
      ],
    );
  }
}
