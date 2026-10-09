import 'package:flutter_test/flutter_test.dart';
import 'package:practice_06_provider/models/auth_model.dart';
import 'package:practice_06_provider/models/profile_model.dart';
import 'package:practice_06_provider/services/fake_api.dart';

void main() {
  test('validates email and password', () {
    expect(AuthModel.validateEmail('invalid'), isNotNull);
    expect(AuthModel.validateEmail('student@example.com'), isNull);
    expect(AuthModel.validatePassword('short'), isNotNull);
    expect(AuthModel.validatePassword('Flutter123!'), isNull);
  });
  test('valid account loads profile then logout clears it', () async {
    final profile = ProfileModel();
    final auth = AuthModel(
      FakeApi(delay: Duration.zero, failureRate: 0),
      profile,
    );
    final states = <AuthStatus>[];
    auth.addListener(() => states.add(auth.status));
    await auth.signIn(FakeApi.demoEmail, FakeApi.demoPassword);
    expect(states, [AuthStatus.loading, AuthStatus.authenticated]);
    expect(profile.name, 'Студент');
    auth.signOut();
    expect(profile.profile, isNull);
    expect(auth.status, AuthStatus.idle);
    auth.dispose();
    profile.dispose();
  });
  test('incorrect account produces an explicit credential error', () async {
    final p = ProfileModel();
    final a = AuthModel(FakeApi(delay: Duration.zero, failureRate: 0), p);
    await a.signIn('other@example.com', 'wrongpass');
    expect(a.error, 'Невірний email або пароль');
    expect(p.profile, isNull);
    a.dispose();
    p.dispose();
  });
  test('server failure permits retry without retaining credentials', () async {
    final p = ProfileModel();
    final a = AuthModel(
      FakeApi(delay: Duration.zero, failureRate: 0, failFirstRequest: true),
      p,
    );
    await a.signIn(FakeApi.demoEmail, FakeApi.demoPassword);
    expect(a.status, AuthStatus.error);
    await a.signIn(FakeApi.demoEmail, FakeApi.demoPassword);
    expect(a.isAuthenticated, isTrue);
    a.dispose();
    p.dispose();
  });
  test('profile validation and no-op do not notify', () async {
    final p = ProfileModel();
    final a = AuthModel(FakeApi(delay: Duration.zero, failureRate: 0), p);
    await a.signIn(FakeApi.demoEmail, FakeApi.demoPassword);
    var notices = 0;
    p.addListener(() => notices++);
    expect(p.update(name: 'A', bio: ''), isNotNull);
    expect(notices, 0);
    p.update(name: p.name, bio: p.bio);
    expect(notices, 0);
    p.update(name: 'Олена', bio: 'Новий опис');
    expect(notices, 1);
    expect(p.name, 'Олена');
    a.dispose();
    p.dispose();
  });
  test('sign out cancels the result of a pending request', () async {
    final p = ProfileModel();
    final a = AuthModel(
      FakeApi(delay: const Duration(milliseconds: 10), failureRate: 0),
      p,
    );
    final pending = a.signIn(FakeApi.demoEmail, FakeApi.demoPassword);
    a.signOut();
    await pending;
    expect(a.status, AuthStatus.idle);
    expect(p.profile, isNull);
    a.dispose();
    p.dispose();
  });
  test('dispose during request produces no late notification', () async {
    final p = ProfileModel();
    final a = AuthModel(
      FakeApi(delay: const Duration(milliseconds: 10), failureRate: 0),
      p,
    );
    final pending = a.signIn(FakeApi.demoEmail, FakeApi.demoPassword);
    a.dispose();
    p.dispose();
    await pending;
  });
}
