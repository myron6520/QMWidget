// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qm_widget/builder/text_field_builder.dart';
import 'package:qm_widget/pub/app.dart';
import 'package:qm_widget/pub/extensions/extensions.dart';
import 'package:qm_widget/pub/qm_color.dart';
import 'package:qm_widget/row/input_widget.dart';

class QM {
  static AppBar buildAppBar({
    BuildContext? context,
    String? title,
    Color backgroundColor = Colors.white,
    List<Widget>? actions,
    double elevation = 1,
    bool showBack = true,
    void Function()? backAction,
    Widget? titleWidget,
    Color tintColor = QMColor.COLOR_333333,
    Widget? flexibleSpace,
  }) {
    return AppBar(
      centerTitle: true,
      title: titleWidget ??
          (title ?? "").toText(
            color: tintColor,
            fontSize: 17,
          ),
      elevation: elevation,
      actions: actions,
      backgroundColor: backgroundColor,
      flexibleSpace: flexibleSpace,
      leading: showBack
          ? Container(
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_ios,
                color: tintColor,
                size: 20,
              ),
            ).onClick(() {
              if (backAction != null) {
                backAction.call();
                return;
              }
              if (context != null) {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
                return;
              }
              App.tryToPop();
            })
          : null,
    );
  }

  static Widget buildTextFiled({
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    String hintText = "请输入",
    InputDecoration? decoration,
    TextStyle hintStyle = const TextStyle(
      color: QMColor.COLOR_999999,
      fontSize: 14,
    ),
    TextStyle style = const TextStyle(
      color: QMColor.COLOR_333333,
      fontSize: 14,
    ),
    bool obscureText = false,
    bool expands = false,
    bool enable = true,
    int? maxLines,
    int? maxLength,
    TextInputType inputType = TextInputType.text,
    TextAlign textAlign = TextAlign.left,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    List<TextInputFormatter>? inputFormatters,
    Widget? left,
    Widget? right,
  }) {
    return InputWidget(
      key: key,
      right: right,
      left: left,
      builder: TextFieldBuilder(
        textAlign: textAlign,
        controller: controller,
        focusNode: focusNode,
        hintText: hintText,
        hintStyle: hintStyle,
        style: style,
        expands: expands,
        enabled: enable,
        maxLines: maxLines,
        decoration: decoration,
        obscureText: obscureText,
        inputType: inputType,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
      ),
    );
  }

  static void showLoading({BuildContext? context, String? msg}) {
    if (_loading_showing) return;
    BuildContext? ctx = context ?? App.navigatorKey.currentContext;
    if (ctx == null) return;
    _loading_showing = true;
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      context: ctx,
      builder: (_) => [
        const CircularProgressIndicator(
          strokeWidth: 1.5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ).applyBackground(height: 20, width: 20),
        ((msg ?? "").isNotEmpty).toWidget(
          () => msg!
              .toText(color: Colors.white, fontSize: 12)
              .applyPadding(EdgeInsets.only(top: 10)),
        ),
      ]
          .toColumn(mainAxisSize: MainAxisSize.min)
          .applyBackground(
            height: 90,
            width: 90,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black.applyOpacity(0.7),
              borderRadius: BorderRadius.circular(5),
            ),
          )
          .applyUnconstrainedBox(),
    );
  }

  static bool _loading_showing = false;
  static void dismissLoading({BuildContext? context}) {
    if (_loading_showing) {
      App.pop();
      _loading_showing = false;
    }
  }

  static void dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static Widget buildArrow(
          {Color? color, double size = 20, int quarterTurns = 0}) =>
      RotatedBox(
        quarterTurns: quarterTurns,
        child: Icon(
          Icons.keyboard_arrow_right,
          color: color ?? QMColor.COLOR_999999,
          size: size,
        ),
      );
}
