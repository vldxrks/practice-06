import 'package:flutter/material.dart';

class HistoryBadge extends StatelessWidget {
  const HistoryBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    debugPrint('build: HistoryBadge');
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Записів в історії: $count',
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colors.secondaryContainer,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.receipt_long_outlined,
              size: 18, color: colors.onSecondaryContainer),
          const SizedBox(width: 6),
          Text('$count', key: const Key('history-count'),
              style: TextStyle(color: colors.onSecondaryContainer)),
        ]),
      ),
    );
  }
}
