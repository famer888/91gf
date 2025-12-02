import 'dart:async';
import 'dart:ui';

class Debounce {
  static const duration = Duration(milliseconds: 350);
  final Map<String, Timer> _timers = {};

  Debounce();

  run({required String id, required VoidCallback action}) {
    _timers[id]?.cancel();
    _timers[id] = Timer(duration, () {
      _timers[id]?.cancel();
      _timers.remove(id);
      action();
    });
  }

  bool containsKey(String id) => _timers.containsKey(id);

  void cancelAndRemove(String id) => _timers.remove(id)?.cancel();

  void cancelAll() {
    for (final operation in _timers.values) {
      operation.cancel();
    }
    _timers.clear();
  }
}
