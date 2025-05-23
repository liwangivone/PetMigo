import 'package:equatable/equatable.dart';
import 'package:frontend/models/user_model.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<UpdateUser>(_onUpdateUser);
    on<UpdateUserName>(_onUpdateUserName);
    on<UpdateUserEmail>(_onUpdateUserEmail);
    on<UpdateUserPhone>(_onUpdateUserPhone);
    on<UpdateUserDateOfBirth>(_onUpdateUserDateOfBirth);
    on<UpdateUserProfileImage>(_onUpdateUserProfileImage);
    on<LogoutUser>(_onLogoutUser);
  }

  // Hardcoded user data - replace with actual data source later
  User _getHardcodedUser() {
    return const User(
      id: '#13237',
      name: 'Ivone Liwang',
      email: 'liwangivone@gmail.com',
      phone: '+62-895-1697-3495',
      dateOfBirth: null,
      profileImageUrl: null,
      isPremium: false,
    );
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    
    try {
      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Get hardcoded user data
      final user = _getHardcodedUser();
      
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
        // Simulate update delay
        await Future.delayed(const Duration(milliseconds: 800));
        
        // Validate user data
        if (event.user.name.isEmpty) {
          emit(UserError(
            message: 'Name cannot be empty',
            user: currentUser,
          ));
          return;
        }
        
        if (event.user.email.isEmpty || !event.user.email.contains('@')) {
          emit(UserError(
            message: 'Please enter a valid email',
            user: currentUser,
          ));
          return;
        }
        
        // Simulate successful update
        emit(UserUpdateSuccess(user: event.user));
        
        // Transition back to loaded state
        await Future.delayed(const Duration(milliseconds: 100));
        emit(UserLoaded(user: event.user));
        
      } catch (e) {
        emit(UserError(
          message: 'Failed to update user: ${e.toString()}',
          user: currentUser,
        ));
      }
    }
  }

  Future<void> _onUpdateUserName(UpdateUserName event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      final updatedUser = currentUser.copyWith(name: event.name);
      add(UpdateUser(user: updatedUser));
    }
  }

  Future<void> _onUpdateUserEmail(UpdateUserEmail event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      final updatedUser = currentUser.copyWith(email: event.email);
      add(UpdateUser(user: updatedUser));
    }
  }

  Future<void> _onUpdateUserPhone(UpdateUserPhone event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      final updatedUser = currentUser.copyWith(phone: event.phone);
      add(UpdateUser(user: updatedUser));
    }
  }

  Future<void> _onUpdateUserDateOfBirth(UpdateUserDateOfBirth event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      final updatedUser = currentUser.copyWith(dateOfBirth: event.dateOfBirth);
      add(UpdateUser(user: updatedUser));
    }
  }

  Future<void> _onUpdateUserProfileImage(UpdateUserProfileImage event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      emit(UserUpdating(user: currentUser));
      
      try {
        // Simulate image upload delay
        await Future.delayed(const Duration(seconds: 1));
        
        final updatedUser = currentUser.copyWith(profileImageUrl: event.imagePath);
        emit(UserUpdateSuccess(
          user: updatedUser,
          message: 'Profile image updated successfully',
        ));
        
        await Future.delayed(const Duration(milliseconds: 100));
        emit(UserLoaded(user: updatedUser));
        
      } catch (e) {
        emit(UserError(
          message: 'Failed to update profile image: ${e.toString()}',
          user: currentUser,
        ));
      }
    }
  }

  Future<void> _onLogoutUser(LogoutUser event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    
    try {
      // Simulate logout delay
      await Future.delayed(const Duration(milliseconds: 500));
      
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
  const LoadUser();
}

class UpdateUser extends UserEvent {
  final User user;

  const UpdateUser({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateUserName extends UserEvent {
  final String name;

  const UpdateUserName({required this.name});

  @override
  List<Object?> get props => [name];
}

class UpdateUserEmail extends UserEvent {
  final String email;

  const UpdateUserEmail({required this.email});

  @override
  List<Object?> get props => [email];
}

class UpdateUserPhone extends UserEvent {
  final String phone;

  const UpdateUserPhone({required this.phone});

  @override
  List<Object?> get props => [phone];
}

class UpdateUserDateOfBirth extends UserEvent {
  final String dateOfBirth;

  const UpdateUserDateOfBirth({required this.dateOfBirth});

  @override
  List<Object?> get props => [dateOfBirth];
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