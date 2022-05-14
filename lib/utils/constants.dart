import 'package:flutter/material.dart';
import 'package:flutter_erwin/utils/AppColor.dart';

import 'size_config.dart';

const kPrimaryColor = Color(0xFF1BD15D);
const kPrimaryLightColor = Color(0xFF1BD15D);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF16BE53), Color(0xFF3bb78f)],
);
const kSecondaryColor = Color(0xFF16BE53);
const kTextColor = Color(0xFF757575);
const Color kHintTextColor = Color(0xFFBB9B9B9);
const Color kBackgroundColor = Color(0xFFF0F0F0);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.white,
  height: 1.5,
);
final titleDarkStyle =
    TextStyle(fontSize: getProportionateScreenWidth(18), color: kTextColor);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";
const String kFieldNullError = "This Field is Required!";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

InputDecoration buildInputDecoration(IconData icon, String hinttext) {
  return InputDecoration(
      hintText: 'Masukkan $hinttext',
      prefixIcon: Icon(icon, color: AppColor.primary),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.green, width: 1),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: kSecondaryColor,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: kHintTextColor,
          width: 1,
        ),
      ),
      labelText: hinttext,
      labelStyle: const TextStyle(color: Colors.black));
}
