// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:async';

import 'package:flutter/material.dart';

class BannerController extends ChangeNotifier {
  bool autoScroll = true;
  void startAutoScroll() {
    autoScroll = true;
    notifyListeners();
  }

  void stopAutoScroll() {
    autoScroll = false;
    notifyListeners();
  }
}

class BannerWidget extends StatefulWidget {
  BannerWidget({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    this.scrollDirection,
    this.onChanged,
    this.viewportFraction = 1,
    this.showSeconds = 5,
    this.transitionDuration = 500,
    this.controller,
  }) : super(key: key);
  final Widget Function(BuildContext context, int index) itemBuilder;
  final void Function(int index)? onChanged;
  final int itemCount;
  final Axis? scrollDirection;
  final double viewportFraction;
  final int showSeconds;
  final int transitionDuration;
  final BannerController? controller;

  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.itemCount > 0
        ? PageView.builder(
            scrollDirection: widget.scrollDirection ?? Axis.horizontal,
            controller: controller,
            itemBuilder: (BuildContext context, int index) => Listener(
              child: widget.itemBuilder.call(context, index % widget.itemCount),
              onPointerDown: (_) => listener?.cancel(),
              onPointerMove: (_) => listener?.cancel(),
              onPointerUp: (_) => tryToAutoScrollToNext(),
            ),
          )
        : Container();
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(bannerControllerChanged);
    int itemCount = widget.itemCount;
    if (itemCount > 0) {
      int index = totalCount ~/ 2;
      index = (index ~/ itemCount) * itemCount;
      controller = PageController(
          initialPage: index, viewportFraction: widget.viewportFraction);
      if (bannerController.autoScroll) {
        tryToAutoScrollToNext();
      }
    }
  }

  late PageController controller;
  int totalCount = 10000;
  StreamSubscription<void>? listener;
  late BannerController bannerController =
      widget.controller ?? BannerController();

  void bannerControllerChanged() {
    if (bannerController.autoScroll) {
      tryToAutoScrollToNext();
    } else {
      listener?.cancel();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    listener?.cancel();
    controller.removeListener(bannerControllerChanged);
    super.dispose();
  }

  void tryToAutoScrollToNext() {
    if (!bannerController.autoScroll) return;
    Future future = Future.delayed(Duration(seconds: widget.showSeconds));
    listener = future.asStream().listen((_) => scrollToNextPage());
  }

  void scrollToNextPage() {
    int index = controller.page?.toInt() ?? 0;
    index += 1;
    if (index >= totalCount) {
      int itemCount = widget.itemCount;
      int idx = index % itemCount;
      index = totalCount ~/ 2;
      index = (index ~/ itemCount) * itemCount + idx;
      controller.jumpToPage(index);
    } else {
      controller.animateToPage(index,
          duration: Duration(milliseconds: widget.transitionDuration),
          curve: Curves.linear);
    }
    widget.onChanged?.call(index % widget.itemCount);
    tryToAutoScrollToNext();
  }
}
