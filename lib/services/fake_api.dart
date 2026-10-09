import 'dart:math';
import '../models/user_profile.dart';

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// No real network or credentials storage. Failure injection makes tests repeatable.
class FakeApi {
  FakeApi({Random? random, this.delay = const Duration(seconds: 1),
    this.failureRate = .2, this.failFirstRequest = false}) : _random = random ?? Random();
  static const demoEmail = 'student@example.com';
  static const demoPassword = 'Flutter123!';
  final Random _random;
  final Duration delay;
  final double failureRate;
  final bool failFirstRequest;
  int _requests = 0;

  Future<UserProfile> signIn(String email, String password) async {
    await Future<void>.delayed(delay);
    _requests++;
    if (email.trim().toLowerCase() != demoEmail || password != demoPassword) {
      throw const ApiException('Невірний email або пароль');
    }
    if ((failFirstRequest && _requests == 1) || _random.nextDouble() < failureRate) {
      throw const ApiException('Сервер недоступний. Спробуйте ще раз.');
    }
    return const UserProfile(email: demoEmail, name: 'Студент',
      bio: 'Вивчаю Flutter та керування станом.');
  }
}
