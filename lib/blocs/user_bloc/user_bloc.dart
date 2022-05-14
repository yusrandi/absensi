import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_erwin/models/user_model.dart';
import 'package:flutter_erwin/repositories/user_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc(this.repository) : super(UserInitial());

  late SharedPreferences sharedpref;

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is LoginEvent) {
      try {
        yield UserLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.userLogin(
            event.email, event.password, event.token);
        yield UserSuccessState(data);
      } catch (e) {
        yield UserErrorState(e.toString());
      }
    } else if (event is CheckLoginEvent) {
      sharedpref = await SharedPreferences.getInstance();
      var userId = sharedpref.get("id");
      print("data $userId");
      if (userId != null) {
        yield UserLoggedInState(int.parse(userId.toString()));
      } else {
        yield UserLoggedOutState();
      }
    } else if (event is LogOutEvent) {
      sharedpref = await SharedPreferences.getInstance();
      await sharedpref.clear();
      yield UserLoggedOutState();
    }
  }
}
