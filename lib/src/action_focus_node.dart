import 'package:chidori/src/focus_listener.dart';
import 'package:flutter/material.dart';

class ActionFocusNode extends FocusNode {
  final bool unfocusOnTapOutside;
  final Widget Function(FocusNode)? customBar;

  ActionFocusNode({
    this.unfocusOnTapOutside = false,
    this.customBar,
  }) {
    addListener(_handle);
  }

  void _handle() {
    if (hasFocus) {
      FocusListener().request(
        this,
        unfocusOnTapOutside: unfocusOnTapOutside,
        customBar: customBar,
      );
    } else {
      FocusListener().disappear(this);
    }
  }

  @override
  void dispose() {
    removeListener(_handle);
    super.dispose();
  }
}
