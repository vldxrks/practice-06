import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice_06_counter/app.dart';

/// Writes real Flutter renders and rebuild logs only when explicitly requested.
void main() {
  const capture = bool.fromEnvironment('CAPTURE_EVIDENCE');

  testWidgets('capture screenshots and a measured rebuild journal', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final font = FontLoader('EvidenceFont')
      ..addFont(rootBundle.load('assets/fonts/DejaVuSans.ttf'));
    await font.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();

    final boundaryKey = GlobalKey();
    final messages = <String>[];
    final journal = <String>[];
    final originalPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null && message.startsWith('build:'))
        messages.add(message);
    };
    try {
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundaryKey,
          child: CounterApp(now: () => DateTime(2026, 10, 8, 9, 30)),
        ),
      );
      await tester.pumpAndSettle();

      Future<void> screenshot(String name) async {
        final boundary =
            boundaryKey.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        await tester.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: 2);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          image.dispose();
          if (bytes == null) throw StateError('Screenshot encoding failed');
          final directory = Directory('docs/screenshots')
            ..createSync(recursive: true);
          await File('${directory.path}/$name.png').writeAsBytes(
            bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
          );
        });
      }

      messages.clear();
      await tester.tap(find.byKey(const Key('increment')));
      await tester.pumpAndSettle();
      expect(
        messages,
        unorderedEquals(['build: HistoryBadge', 'build: CounterValue']),
      );
      journal.addAll(['ACTION: increment by 1', ...messages, '']);

      messages.clear();
      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();
      expect(messages, ['build: CounterControls']);
      journal.addAll(['ACTION: select step 5', ...messages, '']);

      await tester.tap(find.byKey(const Key('increment')));
      await tester.pumpAndSettle();
      await screenshot('counter');
      await tester.tap(find.byKey(const Key('decrement')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('open-history')));
      await tester.pumpAndSettle();
      await screenshot('history');

      messages.clear();
      await tester.tap(find.byKey(const Key('clear-history')));
      await tester.pumpAndSettle();
      expect(find.text('Історія порожня'), findsOneWidget);
      expect(messages, contains('build: HistoryList'));
      expect(messages, isNot(contains('build: HistoryScreen')));
      journal.addAll(['ACTION: clear history', ...messages, '']);
      await screenshot('empty-history');

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.byKey(const Key('counter-value'))).data,
        '1',
      );
      await tester.tap(find.byKey(const Key('decrement')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Значення не може бути від’ємним.'),
        findsOneWidget,
      );
      await screenshot('non-negative-guard');
      await tester.runAsync(
        () =>
            File('docs/rebuilds.log').writeAsString('${journal.join('\n')}\n'),
      );
      expect(tester.takeException(), isNull);
    } finally {
      debugPrint = originalPrint;
    }
  }, skip: !capture);
}
