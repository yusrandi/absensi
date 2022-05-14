part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoadingState extends UserState {}

class UserSuccessState extends UserState {
  final UserModel model;
  const UserSuccessState(this.model);
}

class UserErrorState extends UserState {
  final String errMsg;
  const UserErrorState(this.errMsg);
}

class UserLoggedInState extends UserState {
  final int userId;
  const UserLoggedInState(this.userId);
}

class UserLoggedOutState extends UserState {}
