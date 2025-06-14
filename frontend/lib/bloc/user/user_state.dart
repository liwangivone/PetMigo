import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';

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
  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserUpdating extends UserState {
  const UserUpdating();
}

class UserUpdated extends UserState {
  final User user;
  const UserUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String message;
  final User? user;

  const UserError(this.message, {this.user});

  @override
  List<Object?> get props => [message, user];
}

class UserLoggedOut extends UserState {
  const UserLoggedOut();
}
