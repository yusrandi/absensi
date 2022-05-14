import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_erwin/blocs/user_bloc/user_bloc.dart';
import 'package:flutter_erwin/dashboard_screen.dart';
import 'package:flutter_erwin/login_screen.dart';
import 'package:flutter_erwin/utils/AppColor.dart';

import 'utils/images.dart';
import 'utils/size_config.dart';

class SplashScreen extends StatefulWidget {
  final CameraDescription camera;

  const SplashScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late UserBloc userBloc;

  @override
  void initState() {
    super.initState();

    userBloc = BlocProvider.of(context);
    userBloc.add(CheckLoginEvent());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          loginAction(state);
        },
        child: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Image.asset(Images.logoImage, height: 200),
              SizedBox(height: 16),
              Text(
                'Welcome To Our App',
                style: TextStyle(
                    fontSize: getProportionateScreenWidth(24),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: getProportionateScreenHeight(8)),
              Text(
                'Manage all your activity in this application',
                style: TextStyle(fontSize: getProportionateScreenWidth(14)),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.pushNamed(context, AuthScreen.routeName);
              //   },
              //   child: DefaultButton(
              //     text: "Get Started",
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void loginAction(UserState state) async {
    //replace the below line of code with your login request
    await new Future.delayed(const Duration(seconds: 2));

    if (state is UserLoggedOutState) {
      gotoAnotherPage(LoginScreen(
        userBloc: userBloc,
        camera: widget.camera,
      ));
    } else if (state is UserLoggedInState) {
      gotoAnotherPage(DashboardScreen(
        userId: state.userId.toString(),
        userBloc: userBloc,
        camera: widget.camera,
      ));
    }
  }

  void gotoAnotherPage(Widget widget) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }
}
