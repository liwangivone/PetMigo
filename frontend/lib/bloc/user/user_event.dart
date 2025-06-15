import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class GetUserData extends UserEvent {
  const GetUserData();
}

class LogoutUser extends UserEvent {
  const LogoutUser();
}

class UpdateUserProfile extends UserEvent {
  final User user;

  const UpdateUserProfile(this.user);

  @override
  List<Object?> get props => [user];
}

class UpdateProfileImage extends UserEvent {
  final String imageUrl;

  const UpdateProfileImage(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}

