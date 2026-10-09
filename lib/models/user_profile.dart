class UserProfile {
  const UserProfile({required this.email, required this.name, this.bio = ''});
  final String email;
  final String name;
  final String bio;
  UserProfile copyWith({String? name, String? bio}) =>
      UserProfile(email: email, name: name ?? this.name, bio: bio ?? this.bio);
}
