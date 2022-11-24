import 'dart:async';

import 'package:chidori/chidori.dart';
import 'package:flutter/material.dart';

class FocusListener {
  final StreamController<FocusEvent> eventPool = StreamController<FocusEvent>.broadcast();

  static final FocusListener _singleton = FocusListener._internal();

  factory FocusListener() {
    return _singleton;
  }

  FocusListener._internal();

  StreamSubscription<FocusEvent> subscribe(Function(FocusEvent event) fn) {
    return eventPool.stream.listen(fn);
  }

  void request(
    ActionFocusNode focusNode, {
    required bool unfocusOnTapOutside,
    Widget Function(ActionFocusNode)? customBar,
  }) {
    eventPool.add(FocusRequested(
      focusNode,
      unfocusOnTapOutside: unfocusOnTapOutside,
      customBar: customBar,
    ));
  }

  void disappear(ActionFocusNode focusNode) {
    eventPool.add(FocusDisappeared(focusNode));
  }
}

class FocusEvent {
  final ActionFocusNode focusNode;

  FocusEvent(this.focusNode);
}

class FocusRequested extends FocusEvent {
  final bool unfocusOnTapOutside;
  final Widget Function(ActionFocusNode)? customBar;

  FocusRequested(
    ActionFocusNode focusNode, {
    this.unfocusOnTapOutside = false,
    this.customBar,
  }) : super(focusNode);
}

class FocusDisappeared extends FocusEvent {
  FocusDisappeared(ActionFocusNode focusNode) : super(focusNode);
}
