import 'package:flutter/foundation.dart';
import '../services/fake_api.dart';
import 'profile_model.dart';

enum AuthStatus { idle, loading, error, authenticated }

class AuthModel extends ChangeNotifier {
  AuthModel(this._api, this._profile);
  final FakeApi _api;
  final ProfileModel _profile;
  AuthStatus _status = AuthStatus.idle;
  String? _error;
  int _generation = 0;
  bool _disposed = false;
  AuthStatus get status => _status;
  String? get error => _error;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  static String? validateEmail(String? value) =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value?.trim() ?? '')
      ? null
      : 'Введіть коректний email';
  static String? validatePassword(String? value) =>
      (value?.length ?? 0) >= 8 ? null : 'Щонайменше 8 символів';

  Future<void> signIn(String email, String password) async {
    if (_disposed || isLoading || isAuthenticated) return;
    final validation = validateEmail(email) ?? validatePassword(password);
    if (validation != null) {
      _error = validation;
      _status = AuthStatus.error;
      notifyListeners();
      return;
    }
    final generation = ++_generation;
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();
    try {
      final user = await _api.signIn(email, password);
      if (_disposed || generation != _generation) return;
      _profile.load(user);
      _status = AuthStatus.authenticated;
    } on ApiException catch (error) {
      if (_disposed || generation != _generation) return;
      _error = error.message;
      _status = AuthStatus.error;
    } catch (_) {
      if (_disposed || generation != _generation) return;
      _error = 'Не вдалося увійти. Повторіть спробу.';
      _status = AuthStatus.error;
    }
    // Password is only a request argument; it is never stored in this model.
    if (!_disposed && generation == _generation) notifyListeners();
  }

  void signOut() {
    if (_disposed) return;
    _generation++;
    _profile.clear();
    _error = null;
    _status = AuthStatus.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    super.dispose();
  }
}
