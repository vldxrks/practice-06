import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:practice_06_provider/app.dart';
import 'package:practice_06_provider/models/auth_model.dart';
import 'package:practice_06_provider/services/fake_api.dart';
import 'package:practice_06_provider/widgets/build_probe.dart';

void main() {
  Future<void> open(WidgetTester t, {bool failFirst = false}) async {
    await t.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => t.binding.setSurfaceSize(null));
    await t.pumpWidget(
      ProfileApp(
        api: FakeApi(
          delay: const Duration(seconds: 1),
          failureRate: 0,
          failFirstRequest: failFirst,
        ),
      ),
    );
  }

  Future<void> credentials(WidgetTester t) async {
    await t.enterText(find.byKey(const Key('email')), FakeApi.demoEmail);
    await t.enterText(find.byKey(const Key('password')), FakeApi.demoPassword);
  }

  testWidgets('validates fields, isolates text entry and password toggle', (
    t,
  ) async {
    await open(t);
    await t.tap(find.byKey(const Key('login')));
    await t.pump();
    expect(find.text('Введіть коректний email'), findsOneWidget);
    expect(find.text('Щонайменше 8 символів'), findsOneWidget);
    BuildProbe.reset();
    await credentials(t);
    await t.pump();
    expect(BuildProbe.counts['AuthGate'] ?? 0, 0);
    expect(BuildProbe.counts['LoginScreen'] ?? 0, 0);
    await t.tap(find.byKey(const Key('show-password')));
    await t.pump();
    expect(
      t
          .widget<TextFormField>(find.byKey(const Key('password')))
          .controller!
          .text,
      FakeApi.demoPassword,
    );
    final editable = t.widget<EditableText>(
      find.descendant(
        of: find.byKey(const Key('password')),
        matching: find.byType(EditableText),
      ),
    );
    expect(editable.obscureText, isFalse);
    expect(BuildProbe.counts['AuthGate'] ?? 0, 0);
  });
  testWidgets(
    'loading disables login, error retries, profile saves, logout clears form',
    (t) async {
      await open(t, failFirst: true);
      await credentials(t);
      await t.tap(find.byKey(const Key('login')));
      await t.pump();
      expect(
        t.widget<FilledButton>(find.byKey(const Key('login'))).onPressed,
        isNull,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await t.pump(const Duration(seconds: 1));
      await t.pumpAndSettle();
      expect(
        find.text('Сервер недоступний. Спробуйте ще раз.'),
        findsOneWidget,
      );
      expect(find.text('Повторити'), findsOneWidget);
      await t.tap(find.byKey(const Key('login')));
      await t.pump();
      await t.pump(const Duration(seconds: 1));
      await t.pumpAndSettle();
      expect(find.text('Вітаємо, Студент!'), findsOneWidget);
      await t.tap(find.byKey(const Key('edit-profile')));
      await t.pumpAndSettle();
      await t.enterText(find.byKey(const Key('edit-name')), 'Олена');
      await t.enterText(
        find.byKey(const Key('edit-bio')),
        'Створюю застосунки Flutter.',
      );
      await t.tap(find.byKey(const Key('save-profile')));
      await t.pumpAndSettle();
      expect(find.text('Вітаємо, Олена!'), findsOneWidget);
      expect(find.text('Створюю застосунки Flutter.'), findsOneWidget);
      final auth = t.element(find.byKey(const Key('logout'))).read<AuthModel>();
      expect(auth.isAuthenticated, isTrue);
      await t.tap(find.byKey(const Key('logout')));
      await t.pumpAndSettle();
      expect(find.byKey(const Key('login')), findsOneWidget);
      expect(
        t
            .widget<TextFormField>(find.byKey(const Key('password')))
            .controller!
            .text,
        isEmpty,
      );
    },
  );
}
