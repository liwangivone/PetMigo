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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['uid']?.toString() ?? json['userid']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phonenumber'] ?? '',
      dateOfBirth: json['dateOfBirth'],
      profileImageUrl: json['profileImageUrl'],
      isPremium: json['isPremium'] ?? false,
    );
  }

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
}