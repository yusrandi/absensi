class UserModel {
  String responsecode = "";
  String responsemsg = "";
  User? user;

  UserModel({required this.responsecode, required this.responsemsg, this.user});

  UserModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responsecode'] = responsecode;
    data['responsemsg'] = responsemsg;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int id = 0;
  String uuid = "";
  String name = "";
  String phone = "";
  String birth = "";
  String status = "";
  String unit = "";
  String photo = "";
  String email = "";
  String role = "";

  User(
      {required this.id,
      required this.uuid,
      required this.name,
      required this.phone,
      required this.birth,
      required this.status,
      required this.unit,
      required this.photo,
      required this.email,
      required this.role});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    name = json['name'];
    phone = json['phone'];
    birth = json['birth'];
    status = json['status'];
    unit = json['unit'];
    photo = json['photo'];
    email = json['email'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['name'] = name;
    data['phone'] = phone;
    data['birth'] = birth;
    data['status'] = status;
    data['unit'] = unit;
    data['photo'] = photo;
    data['email'] = email;
    data['role'] = role;
    return data;
  }
}
