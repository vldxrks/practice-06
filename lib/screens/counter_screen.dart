import 'package:flutter/material.dart';

import '../widgets/counter_controls.dart';
import '../widgets/counter_value.dart';
import '../widgets/history_badge.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({
    super.key,
    required this.value,
    required this.historyCount,
    required this.onChange,
    required this.onReset,
    required this.onOpenHistory,
  });

  final int value;
  final int historyCount;
  final bool Function(int delta) onChange;
  final VoidCallback onReset;
  final VoidCallback onOpenHistory;

  @override
  Widget build(BuildContext context) {
    debugPrint('build: CounterScreen');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лічильник'),
        actions: [
          HistoryBadge(count: historyCount),
          IconButton(
            key: const Key('open-history'),
            tooltip: 'Відкрити історію',
            onPressed: onOpenHistory,
            icon: const Icon(Icons.history),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'Маленькі кроки. Повна історія.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                CounterValue(value: value),
                const SizedBox(height: 32),
                CounterControls(onChange: onChange, onReset: onReset),
                const SizedBox(height: 24),
                const Text(
                  'Мінімальне значення - 0. '
                  'Крок можна змінювати в будь-який момент.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
