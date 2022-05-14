import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_erwin/blocs/user_bloc/user_bloc.dart';
import 'package:flutter_erwin/dashboard_screen.dart';
import 'package:flutter_erwin/utils/AppColor.dart';

import 'config/shared_info.dart';
import 'helper/keyboard.dart';
import 'utils/constants.dart';
import 'utils/images.dart';
import 'utils/size_config.dart';
import 'utils/theme.dart';

class LoginScreen extends StatefulWidget {
  final UserBloc userBloc;
  final CameraDescription camera;

  const LoginScreen({Key? key, required this.userBloc, required this.camera})
      : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var containerRadius = const Radius.circular(30.0);
  late SharedInfo _sharedInfo;

  bool _passwordVisible = false;

  final _formKey = GlobalKey<FormState>();
  final _userEmail = TextEditingController();
  final _userPass = TextEditingController();

  String? validatePass(value) {
    if (value.isEmpty) {
      return kPassNullError;
    } else if (value.length < 8) {
      return kShortPassError;
    } else {
      return null;
    }
  }

  String? validateEmail(value) {
    if (value.isEmpty) {
      return kEmailNullError;
    } else if (!emailValidatorRegExp.hasMatch(value)) {
      return kInvalidEmailError;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    _sharedInfo = SharedInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Sign in with your email and password  \nto continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              print("State $state");
              if (state is UserErrorState) {
                EasyLoading.dismiss();
                EasyLoading.showError(state.errMsg);
              } else if (state is UserSuccessState) {
                EasyLoading.dismiss();
                // ignore: unrelated_type_equality_checks
                if (state.model.responsecode == "1") {
                  EasyLoading.showSuccess("Welcome");
                  _sharedInfo.sharedLoginInfo(state.model.user!.id);
                  gotoAnotherPage(DashboardScreen(
                      userId: state.model.user!.id.toString(),
                      userBloc: widget.userBloc,
                      camera: widget.camera));
                } else {
                  EasyLoading.showError(state.model.responsemsg);
                }
              } else if (state is UserLoadingState || state is UserInitial) {
                EasyLoading.show(status: 'wait a second');
              } else if (state is UserLoggedInState) {
                gotoAnotherPage(DashboardScreen(
                    userId: state.userId.toString(),
                    userBloc: widget.userBloc,
                    camera: widget.camera));
              }
            },
            child: Expanded(
                child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: containerRadius, topRight: containerRadius)),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: containerRadius, topRight: containerRadius)),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(Images.logoImage, height: 100),
                          SizedBox(height: getProportionateScreenHeight(26)),
                          emailField(),
                          SizedBox(height: getProportionateScreenHeight(16)),
                          passwordField(),
                          SizedBox(height: getProportionateScreenHeight(36)),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                var email = _userEmail.text.trim();
                                var password = _userPass.text.trim();

                                KeyboardUtil.hideKeyboard(context);
                                widget.userBloc.add(LoginEvent(
                                    email: email,
                                    password: password,
                                    token: "token"));
                              }
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  color: AppColor.primary,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                  child: Text(
                                "Login",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline6,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
          )
        ],
      ),
    );
  }

  TextFormField emailField() {
    return TextFormField(
      controller: _userEmail,
      validator: validateEmail,
      cursorColor: AppColor.primary,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: const TextStyle(color: Colors.black),

        hintText: 'Enter your email',
        // Here is key idea

        prefixIcon:
            Icon(Icons.alternate_email_rounded, color: AppColor.primary),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColor.primary, width: 1),
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
      ),
    );
  }

  TextFormField passwordField() {
    return TextFormField(
      controller: _userPass,
      validator: validatePass,
      cursorColor: AppColor.primary,
      keyboardType: TextInputType.text,
      obscureText: !_passwordVisible, //This will obscure text dynamically
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(color: Colors.black),

        hintText: 'Enter your password',
        // Here is key idea
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: AppColor.primary,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),

        prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColor.primary),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColor.primary, width: 1),
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
      ),
    );
  }

  void gotoAnotherPage(Widget widget) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }
}
