import 'dart:async';

import 'package:flutter/cupertino.dart';

class Debouncer {
  late final int milliseconds;
  late VoidCallback action;
  Timer? timer;

  Debouncer({
    required this.milliseconds,
  });

  run(VoidCallback action) {
    if (timer != null) {
      timer?.cancel();
    }
    timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
