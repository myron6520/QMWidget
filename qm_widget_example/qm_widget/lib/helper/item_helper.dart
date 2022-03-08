import 'package:flutter/material.dart';
import 'package:qm_widget/pub/extensions/extensions.dart';

class ItemHelper {
  final StringWrap? icon;
  final StringWrap? title;

  ItemHelper(this.icon, this.title);
  ItemHelper.only({this.icon, this.title});
  ItemHelperWidget toItemHelperWidget({double span = 0}) => ItemHelperWidget(
        first: icon?.widget,
        second: title?.widget,
        span: span,
      );
}

class ItemHelperWidget {
  final Widget? first;
  final Widget? second;
  final double span;
  ItemHelperWidget({this.first, this.second, this.span = 0});
}

extension ItemHelperWidgetEx on ItemHelperWidget {
  Widget toRow(
          {bool reversed = false,
          CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center}) =>
      [
        first ?? const SizedBox.shrink(),
        span.inRow,
        second ?? const SizedBox.shrink(),
      ].toRow(
          reversed: reversed,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: crossAxisAlignment);
  Widget toColumn(
          {bool reversed = false,
          CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center}) =>
      [
        first ?? const SizedBox.shrink(),
        span.inColumn,
        second ?? const SizedBox.shrink(),
      ].toColumn(
          reversed: reversed,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: crossAxisAlignment);
}
