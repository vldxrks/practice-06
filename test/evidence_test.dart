import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice_06_provider/app.dart';
import 'package:practice_06_provider/services/fake_api.dart';

void main() {
  testWidgets(
    'capture real application states',
    (t) async {
      await t.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => t.binding.setSurfaceSize(null));
      await (FontLoader(
        'EvidenceFont',
      )..addFont(rootBundle.load('assets/fonts/DejaVuSans.ttf'))).load();
      await (FontLoader(
        'MaterialIcons',
      )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
      final key = GlobalKey();
      await t.pumpWidget(
        RepaintBoundary(
          key: key,
          child: ProfileApp(
            api: FakeApi(failureRate: 0, failFirstRequest: true),
          ),
        ),
      );
      await t.pumpAndSettle();
      Future<void> capture(String name) async {
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        await t.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: 2);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          image.dispose();
          Directory('docs/screenshots').createSync(recursive: true);
          File(
            'docs/screenshots/$name.png',
          ).writeAsBytesSync(bytes!.buffer.asUint8List());
        });
      }

      await capture('login');
      await t.enterText(find.byKey(const Key('email')), FakeApi.demoEmail);
      await t.enterText(
        find.byKey(const Key('password')),
        FakeApi.demoPassword,
      );
      await t.tap(find.byKey(const Key('login')));
      await t.pump();
      await t.pump(const Duration(milliseconds: 200));
      await capture('loading');
      await t.pump(const Duration(seconds: 1));
      await t.pumpAndSettle();
      await capture('error');
      await t.tap(find.byKey(const Key('login')));
      await t.pump();
      await t.pump(const Duration(seconds: 1));
      await t.pumpAndSettle();
      await capture('home');
      await t.tap(find.byKey(const Key('edit-profile')));
      await t.pumpAndSettle();
      await t.enterText(find.byKey(const Key('edit-name')), 'Олена');
      await t.enterText(
        find.byKey(const Key('edit-bio')),
        'Створюю застосунки Flutter.',
      );
      await t.pumpAndSettle();
      await capture('edit');
      await t.tap(find.byKey(const Key('save-profile')));
      await t.pumpAndSettle();
      await capture('updated');
    },
    skip: !const bool.fromEnvironment('CAPTURE_EVIDENCE'),
  );
}
