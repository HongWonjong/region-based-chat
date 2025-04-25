import 'dart:async';

class PollingTimer {
  Timer? _timer;

  void start(Duration interval, void Function() callback) {
    _timer ??= Timer.periodic(interval, (timer) => callback());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
