import 'package:flutter/material.dart';

import '../models/counter_entry.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key, required this.history});

  final List<CounterEntry> history;

  @override
  Widget build(BuildContext context) {
    debugPrint('build: HistoryList');
    if (history.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history, size: 64),
              SizedBox(height: 20),
              Text('Історія порожня', style: TextStyle(fontSize: 24)),
              SizedBox(height: 8),
              Text(
                'Змініть лічильник, і перший запис з’явиться тут.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      key: const Key('history-list'),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      itemCount: history.length,
      itemBuilder: (context, index) => HistoryEntryTile(entry: history[index]),
    );
  }
}

class HistoryEntryTile extends StatelessWidget {
  const HistoryEntryTile({super.key, required this.entry});

  final CounterEntry entry;

  @override
  Widget build(BuildContext context) {
    final icon = switch (entry.action) {
      CounterAction.increment => Icons.add,
      CounterAction.decrement => Icons.remove,
      CounterAction.reset => Icons.restart_alt,
    };
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(child: Icon(icon)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.formattedTime,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${entry.before} → ${entry.after}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
