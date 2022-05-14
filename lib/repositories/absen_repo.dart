import 'dart:convert';
import 'dart:io';

import 'package:flutter_erwin/config/api.dart';
import 'package:flutter_erwin/models/absen_model.dart';
import 'package:flutter_erwin/models/response_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

abstract class AbsenRepository {
  Future<AbsenModel> absenFetchData();
  Future<ResponseModel> absenStore(File? file, Absen absen);
}

class AbsenRepositoryImpl implements AbsenRepository {
  static const String TAG = "AbsenRepositoryImpl";

  @override
  Future<AbsenModel> absenFetchData() async {
    var _response = await http.get(Uri.parse(Api.instance.absenURL));
    print("$TAG, AbsenFetchData ${_response.statusCode}");
    if (_response.statusCode == 201) {
      var data = json.decode(_response.body);
      // print("AbsenFetchData $data");
      AbsenModel model = AbsenModel.fromJson(data);
      return model;
    } else {
      throw Exception();
    }
  }

  @override
  Future<ResponseModel> absenStore(File? file, Absen absen) async {
    var request =
        http.MultipartRequest("POST", Uri.parse(Api.instance.absenURL));

    request.fields['userId'] = absen.userId.toString();
    request.fields['role'] = absen.role;
    request.fields['location'] = absen.location;

    if (file != null) {
      final resFile = await http.MultipartFile.fromPath('photo', file.path,
          contentType: MediaType('application', 'x-tar'));
      request.files.add(resFile);
    } else {
      request.fields['photo'] = "";
    }

    final data = await request.send();
    final response = await http.Response.fromStream(data);
    print("response ${response.statusCode}");
    if (response.statusCode == 201) {
      var data = json.decode(response.body);
      print("Data $data");
      ResponseModel model = ResponseModel.fromJson(data);
      return model;
    } else {
      throw Exception();
    }
  }
}
