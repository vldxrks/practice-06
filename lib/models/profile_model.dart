import 'package:flutter/foundation.dart';
import 'user_profile.dart';

class ProfileModel extends ChangeNotifier {
  UserProfile? _profile;
  UserProfile? get profile => _profile;
  String get name => _profile?.name ?? '';
  String get email => _profile?.email ?? '';
  String get bio => _profile?.bio ?? '';
  void load(UserProfile profile) {
    _profile = profile;
    notifyListeners();
  }

  String? update({required String name, required String bio}) {
    final cleanName = name.trim();
    if (cleanName.length < 2 || cleanName.length > 40)
      return 'Ім’я має містити від 2 до 40 символів';
    if (bio.trim().length > 160) return 'Опис має містити до 160 символів';
    if (_profile == null) return 'Спочатку увійдіть';
    if (_profile!.name == cleanName && _profile!.bio == bio.trim()) return null;
    _profile = _profile!.copyWith(name: cleanName, bio: bio.trim());
    notifyListeners();
    return null;
  }

  void clear() {
    if (_profile == null) return;
    _profile = null;
    notifyListeners();
  }
}
