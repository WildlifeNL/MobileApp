import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

extension CacheRef<T> on AutoDisposeRef<T> {
  KeepAliveLink cache(Duration duration, {bool setTimerInCancel = false}) {
    var keepAliveLink = keepAlive();
    Timer? timer;

    onDispose(() => timer?.cancel());

    onCancel(() {
      if (setTimerInCancel) {
        timer = Timer(duration, () {
          keepAliveLink.close();
        });
      }
    });

    onResume(() => timer?.cancel());

    return keepAliveLink;
  }
}
