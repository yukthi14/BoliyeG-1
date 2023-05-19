import 'package:flutter/cupertino.dart';

import '../constant/strings.dart';

class KeyBoard extends WidgetsBindingObserver {
  final BuildContext context;
  bool isKeyboardVisible = false;
  KeyBoard(this.context);

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      isKeyboardVisible = keyboardHeight > 0;
      streamController.add(isKeyboardVisible);
    });
  }

  bool isOn() {
    return isKeyboardVisible;
  }
}
