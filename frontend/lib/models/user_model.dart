class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? dateOfBirth;
  final String? photoUrl;
  final String subscriptionType;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.dateOfBirth,
    this.photoUrl,
    required this.subscriptionType,
  });

  // Create a copy of the current user with updated fields
  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? dateOfBirth,
    String? photoUrl,
    String? subscriptionType,
  }) {
    return UserProfile(
      id: this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      photoUrl: photoUrl ?? this.photoUrl,
      subscriptionType: subscriptionType ?? this.subscriptionType,
    );
  }

  // Create a UserProfile from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      dateOfBirth: json['dateOfBirth'] as String?,
      photoUrl: json['photoUrl'] as String?,
      subscriptionType: json['subscriptionType'] as String,
    );
  }

  // Convert UserProfile to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'dateOfBirth': dateOfBirth,
      'photoUrl': photoUrl,
      'subscriptionType': subscriptionType,
    };
  }
}