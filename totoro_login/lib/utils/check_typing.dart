import 'dart:async';

import 'package:flutter/material.dart';

class CheckTyping {
  final int milliseconds;

  Timer? timer;

  CheckTyping({this.milliseconds = 1000});

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
