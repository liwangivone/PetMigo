import 'package:equatable/equatable.dart';
import 'package:frontend/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/repository/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  UserBloc({required this.userRepository}) : super(const UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<UpdateUser>(_onUpdateUser);
    on<UpdateUserProfileImage>(_onUpdateUserProfileImage);
    on<LogoutUser>(_onLogoutUser);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      final user = await userRepository.fetchUserProfile(event.userId);
      emit(UserLoaded(user: user));
    } catch (e) {
      emit(UserError(message: 'Failed to load user: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      emit(UserUpdating(user: currentUser));
      try {
        final updatedUser = await userRepository.updateUserProfile(event.user);
        emit(UserUpdateSuccess(user: updatedUser));
        await Future.delayed(const Duration(milliseconds: 100));
        emit(UserLoaded(user: updatedUser));
      } catch (e) {
        emit(UserError(message: 'Failed to update user: ${e.toString()}', user: currentUser));
      }
    }
  }

  Future<void> _onUpdateUserProfileImage(UpdateUserProfileImage event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      emit(UserUpdating(user: currentUser));
      try {
        final updatedUser = await userRepository.updateProfileImage(currentUser.id, event.imagePath);
        emit(UserUpdateSuccess(user: updatedUser, message: 'Profile image updated successfully'));
        await Future.delayed(const Duration(milliseconds: 100));
        emit(UserLoaded(user: updatedUser));
      } catch (e) {
        emit(UserError(message: 'Failed to update profile image: ${e.toString()}', user: currentUser));
      }
    }
  }

  Future<void> _onLogoutUser(LogoutUser event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      await userRepository.logout();
      emit(const UserLoggedOut());
    } catch (e) {
      emit(UserError(message: 'Failed to logout: ${e.toString()}'));
    }
  }
}

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final User user;

  const UserLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

class UserUpdating extends UserState {
  final User user;

  const UserUpdating({required this.user});

  @override
  List<Object?> get props => [user];
}

class UserUpdateSuccess extends UserState {
  final User user;
  final String message;

  const UserUpdateSuccess({
    required this.user,
    this.message = 'Profile updated successfully',
  });

  @override
  List<Object?> get props => [user, message];
}

class UserError extends UserState {
  final String message;
  final User? user;

  const UserError({
    required this.message,
    this.user,
  });

  @override
  List<Object?> get props => [message, user];
}

class UserLoggedOut extends UserState {
  const UserLoggedOut();
}


abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUser extends UserEvent {
  final String userId;
  const LoadUser({required this.userId});
  @override
  List<Object?> get props => [userId];
}

class UpdateUser extends UserEvent {
  final User user;

  const UpdateUser({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateUserProfileImage extends UserEvent {
  final String imagePath;

  const UpdateUserProfileImage({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

class LogoutUser extends UserEvent {
  const LogoutUser();
}