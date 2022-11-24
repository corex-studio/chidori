import 'dart:async';
import 'package:chidori/chidori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'focus_listener.dart';

class KeyboardActionBarWrapper extends StatefulWidget {
  final Widget Function(ActionFocusNode) defaultActionBar;
  final Widget child;
  final double defaultBarHeight;

  const KeyboardActionBarWrapper({
    Key? key,
    required this.defaultActionBar,
    required this.child,
    this.defaultBarHeight = 50,
  }) : super(key: key);

  @override
  State<KeyboardActionBarWrapper> createState() => _KeyboardActionBarWrapperState();
}

class _KeyboardActionBarWrapperState extends State<KeyboardActionBarWrapper> {
  late final StreamSubscription _subscription;
  late final StreamSubscription _keyboardSubscription;
  ActionFocusNode? currentFocusNode;
  GlobalKey? barKey;

  OverlayEntry? currentEntry;

  bool get _hasFocus => currentFocusNode?.hasFocus ?? false;

  double get barHeight {
    if (currentFocusNode!.barHeight != null) {
      return currentFocusNode!.barHeight!;
    }
    return widget.defaultBarHeight;
  }

  @override
  void initState() {
    super.initState();
    final keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardSubscription = keyboardVisibilityController.onChange.listen(_handleKeyboardFocus);
    _subscription = FocusListener().subscribe(_handleFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: _hasFocus ? barHeight : 0),
      child: widget.child,
    );
  }

  void _handleFocus(FocusEvent event) {
    if (event is FocusRequested) {
      currentFocusNode = event.focusNode;
      _createEntry(
        unfocusOnTapOutside: event.unfocusOnTapOutside,
        customBar: event.customBar,
      );
    }

    if (event is FocusDisappeared) {
      currentFocusNode = null;
      currentEntry?.remove();
    }

    setState(() {});
  }

  void _handleKeyboardFocus(bool event) {
    if (!event) {
      _unfocus();
    }
  }

  void _createEntry({
    required bool unfocusOnTapOutside,
    Widget Function(ActionFocusNode)? customBar,
  }) {
    if (currentFocusNode == null) {
      return;
    }

    final OverlayState? overlayState = Overlay.of(context);
    if (overlayState == null) {
      return;
    }

    final Widget bar = customBar?.call(currentFocusNode!) ??
        widget.defaultActionBar(
          currentFocusNode!,
        );

    currentEntry = OverlayEntry(builder: (context) {
      final MediaQueryData queryData = MediaQuery.of(context);
      return Stack(
        children: [
          if (unfocusOnTapOutside)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _unfocus,
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: queryData.viewInsets.bottom,
            child: bar,
          ),
        ],
      );
    });
    overlayState.insert(currentEntry!);
  }

  void _unfocus() {
    currentFocusNode?.unfocus();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _keyboardSubscription.cancel();
    super.dispose();
  }
}
