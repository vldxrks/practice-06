enum CounterAction { increment, decrement, reset }

/// Незмінний запис однієї успішної зміни лічильника.
class CounterEntry {
  const CounterEntry({
    required this.timestamp,
    required this.action,
    required this.before,
    required this.after,
  });

  final DateTime timestamp;
  final CounterAction action;
  final int before;
  final int after;

  String get label => switch (action) {
    CounterAction.increment => 'Додано ${after - before}',
    CounterAction.decrement => 'Віднято ${before - after}',
    CounterAction.reset => 'Скинуто до нуля',
  };

  String get formattedTime {
    final local = timestamp.toLocal();
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(local.day)}.${two(local.month)}.${local.year} '
        '${two(local.hour)}:${two(local.minute)}:${two(local.second)}';
  }
}
