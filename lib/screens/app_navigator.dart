import 'package:flutter/material.dart';

import 'counter_screen.dart';
import 'history_screen.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  bool _historyVisible = false;

  @override
  Widget build(BuildContext context) {
    debugPrint('build: AppNavigator');
    return Navigator(
      pages: [
        MaterialPage<void>(
          key: const ValueKey('counter-page'),
          child: CounterScreen(
            onOpenHistory: () => setState(() => _historyVisible = true),
          ),
        ),
        if (_historyVisible)
          const MaterialPage<void>(
            key: ValueKey('history-page'),
            child: HistoryScreen(),
          ),
      ],
      onDidRemovePage: (page) {
        if (page.key == const ValueKey('history-page')) {
          setState(() => _historyVisible = false);
        }
      },
    );
  }
}
