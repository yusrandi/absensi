import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_erwin/models/absen_model.dart';
import 'package:flutter_erwin/repositories/absen_repo.dart';

part 'absen_event.dart';
part 'absen_state.dart';

class AbsenBloc extends Bloc<AbsenEvent, AbsenState> {
  final AbsenRepository repository;

  AbsenBloc(this.repository) : super(AbsenInitial());
  @override
  Stream<AbsenState> mapEventToState(AbsenEvent event) async* {
    if (event is AbsenFetchData) {
      try {
        yield AbsenLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.absenFetchData();
        yield AbsenLoadedState(data);
      } catch (e) {
        yield AbsenErrorState(e.toString());
      }
    }
  }
}
