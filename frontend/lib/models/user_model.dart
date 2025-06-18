class User {
  final String id;
  final String uid;
  final String name;
  final String email;
  final String password;
  final String phone;
  final String? profileImageUrl;
  final bool isPremium;

  const User({
    required this.id,
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.profileImageUrl,
    this.isPremium = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userid']?.toString() ?? '',
      uid: json['uid']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phonenumber'] ?? '',
      password: json['password'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      isPremium: json['isPremium'] ?? false,
    );
  }

  User copyWith({
    String? id,
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? password,
    String? profileImageUrl,
    bool? isPremium,
  }) {
    return User(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': id,
      'uid': uid,
      'name': name,
      'email': email,
      'phonenumber': phone,
      'password': password,
      'profileImageUrl': profileImageUrl,
      'isPremium': isPremium,
    };
  }
}
