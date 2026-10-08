import 'package:flutter/material.dart';

import 'models/counter_entry.dart';
import 'screens/counter_screen.dart';
import 'screens/history_screen.dart';

class CounterApp extends StatefulWidget {
  const CounterApp({super.key, this.now});

  final DateTime Function()? now;

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int _value = 0;
  final List<CounterEntry> _history = [];
  bool _historyVisible = false;

  bool _change(int delta) {
    if (_value + delta < 0) return false;
    if (delta == 0) return true;
    _record(
      _value + delta,
      delta > 0 ? CounterAction.increment : CounterAction.decrement,
    );
    return true;
  }

  void _record(int next, CounterAction action) {
    setState(() {
      _history.insert(
        0,
        CounterEntry(
          timestamp: (widget.now ?? DateTime.now)(),
          action: action,
          before: _value,
          after: next,
        ),
      );
      _value = next;
    });
  }

  void _reset() {
    if (_value != 0) _record(0, CounterAction.reset);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build: CounterApp');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Лічильник з історією',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF315DA8)),
        useMaterial3: true,
      ),
      home: NavigatorPopHandler<void>(
        enabled: _historyVisible,
        onPopWithResult: (_) => setState(() => _historyVisible = false),
        child: Navigator(
          pages: [
            MaterialPage<void>(
              key: const ValueKey('counter-page'),
              child: CounterScreen(
                value: _value,
                historyCount: _history.length,
                onChange: _change,
                onReset: _reset,
                onOpenHistory: () => setState(() => _historyVisible = true),
              ),
            ),
            if (_historyVisible)
              MaterialPage<void>(
                key: const ValueKey('history-page'),
                child: HistoryScreen(
                  history: List.unmodifiable(_history),
                  onClear: () => setState(_history.clear),
                ),
              ),
          ],
          onDidRemovePage: (page) {
            if (_historyVisible && page.key == const ValueKey('history-page')) {
              setState(() => _historyVisible = false);
            }
          },
        ),
      ),
    );
  }
}
