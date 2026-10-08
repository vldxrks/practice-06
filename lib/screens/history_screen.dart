import 'package:flutter/material.dart';

import '../models/counter_entry.dart';
import '../widgets/history_badge.dart';
import '../widgets/history_list.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    super.key,
    required this.history,
    required this.onClear,
  });

  final List<CounterEntry> history;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    debugPrint('build: HistoryScreen');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Історія'),
        actions: [HistoryBadge(count: history.length)],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Найновіші зміни - на початку списку.'),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        key: const Key('clear-history'),
                        onPressed: onClear,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Очистити історію'),
                      ),
                    ],
                  ),
                ),
                Expanded(child: HistoryList(history: history)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
