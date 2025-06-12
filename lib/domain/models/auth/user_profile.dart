class UserProfile {
  const UserProfile({
    required this.id,
    this.avatarPhoto,
    this.birthday,
    required this.email,
    this.name,
    this.phone,
  });

  final String id;
  final String? name;
  final String? phone;
  final String email;
  final String? birthday;
  final String? avatarPhoto;

  UserProfile copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? birthday,
    String? avatarPhoto,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      birthday: birthday ?? this.birthday,
      avatarPhoto: avatarPhoto ?? this.avatarPhoto,
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, email: $email, name: $name, phone: $phone, birthday: $birthday, avatarPhoto: $avatarPhoto)';
  }
}
