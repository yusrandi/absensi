import 'user_model.dart';

class AbsenModel {
  String responsecode = "";
  String responsemsg = "";
  List<Absen> absen = [];

  AbsenModel(
      {required this.responsecode,
      required this.responsemsg,
      required this.absen});

  AbsenModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    if (json['absen'] != null) {
      absen = <Absen>[];
      json['absen'].forEach((v) {
        absen.add(Absen.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responsecode'] = responsecode;
    data['responsemsg'] = responsemsg;
    data['absen'] = absen.map((v) => v.toJson()).toList();
    return data;
  }
}

class Absen {
  int userId = 0;
  String date = "";
  String time = "";
  String role = "";
  String photo = "";
  String location = "";
  User? user;

  Absen(
      {required this.userId,
      required this.date,
      required this.time,
      required this.role,
      required this.photo,
      required this.location,
      this.user});

  Absen.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    date = json['date'];
    time = json['time'];
    role = json['role'];
    photo = json['photo'];
    location = json['location'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['date'] = date;
    data['time'] = time;
    data['role'] = role;
    data['photo'] = photo;
    data['location'] = location;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
