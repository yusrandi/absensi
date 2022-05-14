import 'dart:convert';

import 'package:flutter_erwin/config/api.dart';
import 'package:flutter_erwin/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class UserRepository {
  Future<UserModel> userLogin(String email, String password, String token);
}

class UserRepositoryImpl implements UserRepository {
  @override
  Future<UserModel> userLogin(
      String email, String password, String token) async {
    var _response = await http.post(
      Uri.parse(Api.instance.loginURL),
      body: {
        "email": email,
        "password": password,
        "token": token,
      },
    );

    print("UserRepositoryImpl ${email}");
    if (_response.statusCode == 201) {
      var data = json.decode(_response.body);
      print("Data $data");
      UserModel model = UserModel.fromJson(data);
      return model;
    } else {
      throw Exception();
    }
  }
}
