import 'package:flutter/material.dart';

import '../state/counter_scope.dart';
import '../widgets/history_badge.dart';
import '../widgets/history_list.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('build: HistoryScreen');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Історія'),
        actions: const [HistoryBadge()],
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
                        onPressed: () =>
                            CounterScope.of(context, listen: false).clearHistory(),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Очистити історію'),
                      ),
                    ],
                  ),
                ),
                const Expanded(child: HistoryList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
