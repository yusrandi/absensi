class ResponseModel {
  String responsecode = "";
  String responsemsg = "";

  ResponseModel({required this.responsecode, required this.responsemsg});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemsg = json['responsemsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responsecode'] = responsecode;
    data['responsemsg'] = responsemsg;
    return data;
  }
}
