import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice_06_counter/app.dart';

void main() {
  testWidgets('counter, history, clear and non-negative guard', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const CounterApp());
    expect(find.byKey(const Key('counter-value')), findsOneWidget);
    await tester.tap(find.byKey(const Key('decrement')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Значення не може бути від’ємним.'),
      findsOneWidget,
    );
    expect(
      tester.widget<Text>(find.byKey(const Key('counter-value'))).data,
      '0',
    );

    await tester.tap(find.text('5'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('increment')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.byKey(const Key('counter-value'))).data,
      '5',
    );
    await tester.tap(find.byKey(const Key('reset')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.byKey(const Key('counter-value'))).data,
      '0',
    );

    await tester.tap(find.byKey(const Key('open-history')));
    await tester.pumpAndSettle();
    expect(find.text('Скинуто до нуля'), findsOneWidget);
    expect(find.text('Додано 5'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('history-count'))).data,
      '2',
    );

    await tester.tap(find.byKey(const Key('clear-history')));
    await tester.pumpAndSettle();
    expect(find.text('Історія порожня'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.byKey(const Key('history-count'))).data,
      '0',
    );
    await tester.tap(find.byKey(const Key('open-history')));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('counter-value')), findsOneWidget);
    expect(find.byKey(const Key('clear-history')), findsNothing);
  });
}
