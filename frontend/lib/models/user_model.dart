// models/user.dart

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? dateOfBirth;
  final String? profileImageUrl;
  final bool isPremium;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.dateOfBirth,
    this.profileImageUrl,
    this.isPremium = false,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? dateOfBirth,
    String? profileImageUrl,
    bool? isPremium,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'dateOfBirth': dateOfBirth,
      'profileImageUrl': profileImageUrl,
      'isPremium': isPremium,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      dateOfBirth: map['dateOfBirth'],
      profileImageUrl: map['profileImageUrl'],
      isPremium: map['isPremium'] ?? false,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phone: $phone, dateOfBirth: $dateOfBirth, profileImageUrl: $profileImageUrl, isPremium: $isPremium)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.dateOfBirth == dateOfBirth &&
        other.profileImageUrl == profileImageUrl &&
        other.isPremium == isPremium;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        dateOfBirth.hashCode ^
        profileImageUrl.hashCode ^
        isPremium.hashCode;
  }
}