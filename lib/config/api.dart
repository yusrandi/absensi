class Api {
  //* Creating instance constructor;
  static Api instance = Api();
  //* Base API URL
  static const domain = "http://192.168.189.43/erwin";
  static const baseURL = domain + "/public/api";
  static const imageURL = "$domain/public/storage/photos_thumb";
  static const imageAbsenURL = "$domain/public/storage/absens_thumb";

  String absenURL = "$baseURL/absen";
  String loginURL = "$baseURL/login";
}
