part of 'absen_bloc.dart';

abstract class AbsenState extends Equatable {
  const AbsenState();

  @override
  List<Object> get props => [];
}

class AbsenInitial extends AbsenState {}

class AbsenLoadingState extends AbsenState {}

class AbsenLoadedState extends AbsenState {
  final AbsenModel model;
  const AbsenLoadedState(this.model);
}

class AbsenSuccessState extends AbsenState {
  final String successMsg;
  const AbsenSuccessState(this.successMsg);
}

class AbsenErrorState extends AbsenState {
  final String errorMsg;
  const AbsenErrorState(this.errorMsg);
}
