import 'package:flutter/foundation.dart';

import '../models/counter_entry.dart';

/// Єдине джерело спільного стану. Не зберігає крок чи стан навігації.
class CounterModel extends ChangeNotifier {
  CounterModel({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;
  int _value = 0;
  final List<CounterEntry> _history = [];

  int get value => _value;
  int get historyCount => _history.length;

  // Новіші записи зверху; зовнішній код не може змінити список.
  List<CounterEntry> get history => List.unmodifiable(_history.reversed);

  /// false означає відхилену від'ємну зміну; стан не змінюється.
  bool change(int delta) {
    final next = _value + delta;
    if (next < 0) return false;
    if (delta == 0) return true;
    _record(
      next,
      delta > 0 ? CounterAction.increment : CounterAction.decrement,
    );
    return true;
  }

  void reset() {
    if (_value == 0) return;
    _record(0, CounterAction.reset);
  }

  void clearHistory() {
    if (_history.isEmpty) return;
    _history.clear();
    notifyListeners();
  }

  void _record(int next, CounterAction action) {
    _history.add(
      CounterEntry(
        timestamp: _now(),
        action: action,
        before: _value,
        after: next,
      ),
    );
    _value = next;
    notifyListeners();
  }
}
