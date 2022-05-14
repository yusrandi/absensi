part of 'absen_bloc.dart';

abstract class AbsenEvent extends Equatable {
  const AbsenEvent();

  @override
  List<Object> get props => [];
}

class AbsenFetchData extends AbsenEvent {}

class AbsenStoreEvent extends AbsenEvent {
  final File? file;
  final Absen absen;

  const AbsenStoreEvent({this.file, required this.absen});

  @override
  List<Object> get props => [];
}
