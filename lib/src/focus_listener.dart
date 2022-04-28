import 'dart:async';

import 'package:flutter/material.dart';

class FocusListener {
  final StreamController<FocusEvent> eventPool =
      StreamController<FocusEvent>.broadcast();

  static final FocusListener _singleton = FocusListener._internal();

  factory FocusListener() {
    return _singleton;
  }

  FocusListener._internal();

  StreamSubscription<FocusEvent> subscribe(Function(FocusEvent event) fn) {
    return eventPool.stream.listen(fn);
  }

  void request(
    FocusNode focusNode, {
    required bool unfocusOnTapOutside,
    Widget Function(FocusNode)? customBar,
  }) {
    eventPool.add(FocusRequested(
      focusNode,
      unfocusOnTapOutside: unfocusOnTapOutside,
      customBar: customBar,
    ));
  }

  void disappear(FocusNode focusNode) {
    eventPool.add(FocusDisappeared(focusNode));
  }
}

class FocusEvent {
  final FocusNode focusNode;

  FocusEvent(this.focusNode);
}

class FocusRequested extends FocusEvent {
  final bool unfocusOnTapOutside;
  final Widget Function(FocusNode)? customBar;

  FocusRequested(
    FocusNode focusNode, {
    this.unfocusOnTapOutside = false,
    this.customBar,
  }) : super(focusNode);
}

class FocusDisappeared extends FocusEvent {
  FocusDisappeared(FocusNode focusNode) : super(focusNode);
}
