import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/user_model.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String name;
  final String phone;
  final String email;
  final String? dateOfBirth;
  final String? photoUrl;

  UpdateProfile({
    required this.name,
    required this.phone,
    required this.email,
    this.dateOfBirth,
    this.photoUrl,
  });
}

// Profile States
abstract class ProfileState {
  final UserProfile userProfile;
  
  const ProfileState(this.userProfile);
}

class ProfileInitial extends ProfileState {
  ProfileInitial() : super(
    UserProfile(
      id: '13237',
      name: 'Ivone Liwang',
      email: 'liwangivone@gmail.com',
      phone: '+62-895-1697-3495',
      dateOfBirth: null,
      photoUrl: null,
      subscriptionType: 'free',
    ),
  );
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(UserProfile userProfile) : super(userProfile);
}

class ProfileLoading extends ProfileState {
  const ProfileLoading(UserProfile userProfile) : super(userProfile);
}

class ProfileError extends ProfileState {
  final String message;
  
  const ProfileError(UserProfile userProfile, this.message) : super(userProfile);
}

// Profile BLoC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading(state.userProfile));
    
    try {
      // In a real app, you'd fetch the profile from an API or local storage
      // For this example, we'll just use the initial data
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      emit(ProfileLoaded(state.userProfile));
    } catch (e) {
      emit(ProfileError(state.userProfile, e.toString()));
    }
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading(state.userProfile));
    
    try {
      // In a real app, you'd send the update to an API
      // For this example, we'll just update the local state
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      final updatedProfile = state.userProfile.copyWith(
        name: event.name,
        email: event.email,
        phone: event.phone,
        dateOfBirth: event.dateOfBirth,
        photoUrl: event.photoUrl,
      );
      
      emit(ProfileLoaded(updatedProfile));
    } catch (e) {
      emit(ProfileError(state.userProfile, e.toString()));
    }
  }
}