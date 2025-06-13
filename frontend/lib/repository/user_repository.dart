import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/user_service.dart';

class UserRepository {
  final UserService userService;
  UserRepository({required this.userService});

  Future<User> fetchUserProfile(String userId) async {
    final json = await userService.getUserProfile(userId);
    return User.fromJson(json);
  }

  Future<User> updateUserProfile(User user) async {
    final json = await userService.updateUserProfile(user);
    return User.fromJson(json);
  }

  Future<User> updateProfileImage(String userId, String imageUrl) async {
    final json = await userService.updateProfileImage(userId, imageUrl);
    return User.fromJson(json);
  }
}
