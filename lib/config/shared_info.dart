import 'package:shared_preferences/shared_preferences.dart';

class SharedInfo {
  late SharedPreferences sharedPref;

  void sharedLoginInfo(int id) async {
    sharedPref = await SharedPreferences.getInstance();
    sharedPref.setInt("id", id);
  }
}
