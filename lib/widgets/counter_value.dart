import 'package:flutter/material.dart';

import '../state/counter_scope.dart';

class CounterValue extends StatelessWidget {
  const CounterValue({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('build: CounterValue');
    final value = CounterScope.of(context).value;
    final theme = Theme.of(context);
    return Card.filled(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'ПОТОЧНЕ ЗНАЧЕННЯ',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              liveRegion: true,
              label: 'Значення лічильника',
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  '$value',
                  key: const Key('counter-value'),
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 88,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Кожна зміна зберігається в історії.',
              style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}
