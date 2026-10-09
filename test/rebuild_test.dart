import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:practice_06_provider/app.dart';
import 'package:practice_06_provider/models/profile_model.dart';
import 'package:practice_06_provider/services/fake_api.dart';
import 'package:practice_06_provider/widgets/build_probe.dart';

void main() {
  testWidgets('measure real rebuilds for three controlled actions', (t) async {
    await t.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => t.binding.setSurfaceSize(null));
    await t.pumpWidget(
      ProfileApp(
        api: FakeApi(delay: const Duration(seconds: 1), failureRate: 0),
      ),
    );
    final results = <String, Map<String, int>>{};
    await t.enterText(find.byKey(const Key('email')), 'wrong@example.com');
    await t.enterText(find.byKey(const Key('password')), 'wrongpass');
    await t.pumpAndSettle();
    BuildProbe.reset();
    await t.tap(find.byKey(const Key('login')));
    await t.pump();
    await t.pump(const Duration(seconds: 1));
    await t.pumpAndSettle();
    results['failed_login'] = Map.of(BuildProbe.counts);
    await t.enterText(find.byKey(const Key('email')), FakeApi.demoEmail);
    await t.enterText(find.byKey(const Key('password')), FakeApi.demoPassword);
    await t.tap(find.byKey(const Key('login')));
    await t.pump();
    await t.pump(const Duration(seconds: 1));
    await t.pumpAndSettle();
    final profile = t
        .element(find.byKey(const Key('profile-name')))
        .read<ProfileModel>();
    BuildProbe.reset();
    profile.update(name: 'Олена', bio: profile.bio);
    await t.pumpAndSettle();
    results['change_name'] = Map.of(BuildProbe.counts);
    BuildProbe.reset();
    profile.update(name: profile.name, bio: 'Новий опис');
    await t.pumpAndSettle();
    results['change_bio'] = Map.of(BuildProbe.counts);
    expect(results['failed_login'], {'AuthFeedback': 2, 'LoginAction': 2});
    expect(results['change_name'], {'ProfileName': 1});
    expect(results['change_bio'], {'ProfileBio': 1});
    expect(find.text('Вітаємо, Олена!'), findsOneWidget);
    expect(find.text('Новий опис'), findsOneWidget);
    if (const bool.fromEnvironment('MEASURE')) {
      const label = String.fromEnvironment(
        'MEASUREMENT_LABEL',
        defaultValue: 'after',
      );
      Directory('docs/verification').createSync(recursive: true);
      File(
        'docs/verification/rebuilds-$label.json',
      ).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(results));
    }
  });
}
