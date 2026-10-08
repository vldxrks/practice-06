import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice_06_counter/app.dart';

void main() {
  testWidgets('only subscribed widgets rebuild after increment', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final messages = <String>[];
    final originalDebugPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null && message.startsWith('build:'))
        messages.add(message);
    };

    try {
      await tester.pumpWidget(const CounterApp());
      await tester.pumpAndSettle();
      messages.clear();
      await tester.tap(find.byKey(const Key('increment')));
      await tester.pumpAndSettle();

      expect(
        messages,
        unorderedEquals(['build: CounterValue', 'build: HistoryBadge']),
      );
      expect(
        tester.widget<Text>(find.byKey(const Key('counter-value'))).data,
        '1',
      );

      messages.clear();
      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();
      expect(messages, ['build: CounterControls']);
      expect(
        tester.widget<Text>(find.byKey(const Key('history-count'))).data,
        '1',
      );
    } finally {
      debugPrint = originalDebugPrint;
    }
  });

  testWidgets(
    'step persists while visiting history; clearing preserves value',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const CounterApp());
      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('increment')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('open-history')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('clear-history')));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.byKey(const Key('counter-value'))).data,
        '10',
      );
      expect(
        tester
            .widget<SegmentedButton<int>>(find.byType(SegmentedButton<int>))
            .selected,
        {10},
      );
      await tester.tap(find.byKey(const Key('increment')));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.byKey(const Key('counter-value'))).data,
        '20',
      );
      expect(
        tester.widget<Text>(find.byKey(const Key('history-count'))).data,
        '1',
      );
      expect(tester.takeException(), isNull);
    },
  );
}
