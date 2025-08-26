import 'dart:async';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(Function action) {
    _timer?.cancel();
    _timer = Timer(Duration(microseconds: milliseconds), () {
      action();
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}
