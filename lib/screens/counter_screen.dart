import 'package:flutter/material.dart';

import '../widgets/counter_controls.dart';
import '../widgets/counter_value.dart';
import '../widgets/history_badge.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({
    super.key,
    required this.onOpenHistory,
  });

  final VoidCallback onOpenHistory;

  @override
  Widget build(BuildContext context) {
    debugPrint('build: CounterScreen');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лічильник'),
        actions: [
          const HistoryBadge(),
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
                Text('Маленькі кроки. Повна історія.',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 24),
                const CounterValue(),
                const SizedBox(height: 32),
                const CounterControls(),
                const SizedBox(height: 24),
                const Text('Мінімальне значення - 0. '
                    'Крок можна змінювати в будь-який момент.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
