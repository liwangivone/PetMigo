import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';
import '../../services/user_service.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService userService;

  UserBloc({required this.userService}) : super(const UserInitial()) {
    on<GetUserData>((event, emit) async {
      emit(const UserLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userid');
        if (userId == null || userId.isEmpty) {
          emit(const UserError("User ID tidak ditemukan di penyimpanan lokal"));
          return;
        }
        final userData = await userService.getUserProfile(userId);
        final user = User.fromJson(userData);
        emit(UserLoaded(user));
      } catch (e) {
        emit(const UserError("Failed to load user data"));
      }
    });

    on<UpdateUserProfile>((event, emit) async {
      emit(const UserUpdating());
      try {
        final updatedData = await userService.updateUserProfile(event.user);
        final updatedUser = User.fromJson(updatedData);
        emit(UserUpdated(updatedUser));
        emit(UserLoaded(updatedUser));
      } catch (e) {
        emit(const UserError("Nama Atau Email Telah Dipakai"));
      }
    });

    on<UpdateProfileImage>((event, emit) async {
      emit(const UserUpdating());
      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userid');
        if (userId == null || userId.isEmpty) {
          emit(const UserError("User ID tidak ditemukan di penyimpanan lokal"));
          return;
        }
        final updatedData = await userService.updateProfileImage(userId, event.imageUrl);
        final updatedUser = User.fromJson(updatedData);
        emit(UserUpdated(updatedUser));
        emit(UserLoaded(updatedUser));
      } catch (e) {
        emit(const UserError("Failed to update profile image"));
      }
    });

    on<LogoutUser>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      emit(const UserLoggedOut());
    });
  }
}
