import 'package:flutter/material.dart';

import '../state/counter_scope.dart';

class CounterControls extends StatefulWidget {
  const CounterControls({super.key});

  @override
  State<CounterControls> createState() => _CounterControlsState();
}

class _CounterControlsState extends State<CounterControls> {
  // Крок потрібен лише елементам керування - це ефемерний стан.
  int _step = 1;

  void _change(int delta) {
    if (!CounterScope.of(context, listen: false).change(delta)) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(const SnackBar(
        content: Text('Значення не може бути від’ємним. Оберіть менший крок '
            'або спочатку збільште лічильник.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build: CounterControls');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Крок зміни', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 1, label: Text('1')),
            ButtonSegment(value: 5, label: Text('5')),
            ButtonSegment(value: 10, label: Text('10')),
          ],
          selected: {_step},
          onSelectionChanged: (selection) {
            setState(() => _step = selection.single);
          },
        ),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(
            child: FilledButton.tonalIcon(
              key: const Key('decrement'),
              onPressed: () => _change(-_step),
              icon: const Icon(Icons.remove),
              label: const Text('Відняти'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              key: const Key('increment'),
              onPressed: () => _change(_step),
              icon: const Icon(Icons.add),
              label: const Text('Додати'),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          key: const Key('reset'),
          onPressed: () => CounterScope.of(context, listen: false).reset(),
          icon: const Icon(Icons.restart_alt),
          label: const Text('Скинути'),
        ),
      ],
    );
  }
}
