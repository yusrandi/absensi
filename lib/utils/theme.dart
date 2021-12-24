import 'package:flutter/material.dart';
import 'package:flutter_erwin/utils/AppColor.dart';

ThemeData theme() {
  return ThemeData(
      fontFamily: "Nunito",
      appBarTheme: appBarTheme(),
      textTheme: textTheme(),
      inputDecorationTheme: inputDecorationTheme(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: AppColor.primary,
      accentColor: AppColor.primarySoft);
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: BorderSide(color: AppColor.kTextColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    // If  you are using latest version of flutter then lable text and hint text shown like this
    // if you r using flutter less then 1.20.* then maybe this is not working properly
    // if we are define our floatingLabelBehavior in our theme then it's not applayed
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}

TextTheme textTheme() {
  return TextTheme(
    bodyText1: TextStyle(color: AppColor.kTextColor),
    bodyText2: TextStyle(color: AppColor.kTextColor),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    color: AppColor.primary,
    elevation: 0,
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
    ),
  );
}

InputDecoration inputForm(String label, String hint) {
  return InputDecoration(
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.teal),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColor.kTextColor),
    ),
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColor.kTextColor)),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.teal),
    ),
    disabledBorder: InputBorder.none,
    fillColor: AppColor.kTextColor,
    hoverColor: AppColor.kTextColor,
    focusColor: AppColor.kTextColor,
    labelText: label,
    hintText: hint,
    hintStyle: TextStyle(color: AppColor.kTextColor),
    labelStyle: TextStyle(color: AppColor.kTextColor),
// If  you are using latest version of flutter then lable text and hint text shown like this
// if you r using flutter less then 1.20.* then maybe this is not working properly
    floatingLabelBehavior: FloatingLabelBehavior.never,
    contentPadding: EdgeInsets.only(left: 15, bottom: 11, right: 15),
  );
}
