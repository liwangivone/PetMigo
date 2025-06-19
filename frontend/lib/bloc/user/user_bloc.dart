import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService userService;
  Timer? _pingTimer;

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
        startPingTimer(userId); // Start timer after successful login
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
      stopPingTimer(); // Stop timer on logout
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      emit(const UserLoggedOut());
    });

    on<PingUser>((event, emit) async {
      try {
        final status = await userService.pingUser(event.id);
        emit(UserPingResult(status));
      } catch (e) {
        emit(UserError("Ping failed: ${e.toString()}"));
      } finally {
        // Return to loaded state if needed
        if (state is! UserError) {
          final prefs = await SharedPreferences.getInstance();
          final userId = prefs.getString('userid');
          if (userId != null) {
            final userData = await userService.getUserProfile(userId);
            emit(UserLoaded(User.fromJson(userData)));
          }
        }
      }
    });
  }

  void startPingTimer(String userId) {
    stopPingTimer(); // Cancel any existing timer
    _pingTimer = Timer.periodic(const Duration(seconds: 9), (timer) {
      add(PingUser(userId));
    });
  }

  void stopPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  @override
  Future<void> close() {
    stopPingTimer(); // Clean up timer when bloc is closed
    return super.close();
  }
}