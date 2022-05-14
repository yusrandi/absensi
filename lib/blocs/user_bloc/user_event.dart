part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends UserEvent {
  final String email;
  final String password;
  final String token;

  const LoginEvent(
      {required this.email, required this.password, required this.token});
}

class LogOutEvent extends UserEvent {}

class CheckLoginEvent extends UserEvent {}
