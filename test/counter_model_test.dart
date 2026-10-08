import 'package:flutter_test/flutter_test.dart';
import 'package:practice_06_counter/models/counter_entry.dart';
import 'package:practice_06_counter/state/counter_model.dart';

void main() {
  late CounterModel model;
  final time = DateTime(2026, 10, 8, 9, 30);

  setUp(() => model = CounterModel(now: () => time));
  tearDown(() => model.dispose());

  test('starts at zero with empty history', () {
    expect(model.value, 0);
    expect(model.history, isEmpty);
  });

  test('records time, action, before/after and newest-first order', () {
    model.change(1);
    model.change(10);
    model.change(-5);
    expect(model.value, 6);
    expect(model.historyCount, 3);
    expect(model.history.map((entry) => entry.after), [6, 11, 1]);
    final last = model.history.first;
    expect(last.timestamp, time);
    expect(last.action, CounterAction.decrement);
    expect(last.before, 11);
    expect(last.after, 6);
    expect(last.label, 'Віднято 5');
  });

  test('rejects negative results without mutation or notification', () {
    model.change(5);
    var notifications = 0;
    model.addListener(() => notifications++);
    expect(model.change(-10), isFalse);
    expect(model.value, 5);
    expect(model.historyCount, 1);
    expect(notifications, 0);
    expect(model.change(-5), isTrue);
    expect(model.value, 0);
    expect(notifications, 1);
  });

  test('reset is recorded; resetting zero is a no-op', () {
    model.change(10);
    model.reset();
    expect(model.value, 0);
    expect(model.history.first.action, CounterAction.reset);
    expect(model.history.first.before, 10);
    expect(model.history.first.after, 0);
    model.reset();
    expect(model.historyCount, 2);
  });

  test('clear history preserves the counter', () {
    model.change(5);
    model.clearHistory();
    expect(model.value, 5);
    expect(model.historyCount, 0);
    model.change(1);
    expect(model.history.single.before, 5);
    expect(model.history.single.after, 6);
  });

  test('returned history is immutable and is a stable snapshot', () {
    model.change(1);
    final snapshot = model.history;
    expect(snapshot.clear, throwsUnsupportedError);
    model.change(5);
    expect(snapshot.length, 1);
    expect(model.history.length, 2);
  });

  test('one notification per mutation, none for no-ops', () {
    var notifications = 0;
    model.addListener(() => notifications++);
    model.clearHistory();
    model.reset();
    model.change(0);
    expect(notifications, 0);
    model.change(5);
    model.reset();
    model.clearHistory();
    expect(notifications, 3);
  });
}
