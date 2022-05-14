import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_erwin/blocs/user_bloc/user_bloc.dart';
import 'package:flutter_erwin/camera_screen.dart';
import 'package:flutter_erwin/utils/AppColor.dart';

import 'blocs/absen_bloc/absen_bloc.dart';
import 'components/chattile.dart';
import 'components/storybutton.dart';
import 'config/api.dart';
import 'login_screen.dart';
import 'models/absen_model.dart';
import 'utils/images.dart';

class DashboardScreen extends StatefulWidget {
  final CameraDescription camera;
  final UserBloc userBloc;
  final String userId;

  const DashboardScreen(
      {Key? key,
      required this.camera,
      required this.userBloc,
      required this.userId})
      : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //Adding the main color of the app
  Color mainColor = const Color(0xFF177767);
  var containerRadius = const Radius.circular(30.0);
  //Adding a list of image URL to simulate the avatar picture
  List<String> imageUrl = [
    "https://i.pinimg.com/originals/2e/2f/ac/2e2fac9d4a392456e511345021592dd2.jpg",
    "https://randomuser.me/api/portraits/men/86.jpg",
    "https://randomuser.me/api/portraits/women/80.jpg",
    "https://randomuser.me/api/portraits/men/43.jpg",
    "https://randomuser.me/api/portraits/women/49.jpg",
    "https://randomuser.me/api/portraits/women/45.jpg",
    "https://randomuser.me/api/portraits/women/0.jpg",
    "https://randomuser.me/api/portraits/women/1.jpg",
    "https://randomuser.me/api/portraits/men/0.jpg"
  ];

  late AbsenBloc absenBloc;

  @override
  void initState() {
    super.initState();
    absenBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.dismiss();
    absenBloc.add(AbsenFetchData());

    return Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          elevation: 0.0,
          title: Row(
            children: [
              Image.asset(Images.logoImage, height: 30),
              const SizedBox(width: 16),
              const Text("Erwin"),
            ],
          ),
          backgroundColor: mainColor,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            PopupMenuButton<String>(
              onSelected: handleClick,
              color: Colors.white,
              itemBuilder: (BuildContext context) {
                return {'Logout', 'Settings'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserLoggedOutState) {
              gotoAnotherPage(LoginScreen(
                userBloc: widget.userBloc,
                camera: widget.camera,
              ));
            }
          },
          child: body(),
        ));
  }

  Column body() {
    return Column(
      children: [
        //First let's create the Story time line container
        BlocBuilder<AbsenBloc, AbsenState>(
          builder: (context, state) {
            if (state is AbsenLoadedState) {
              List<Absen> list = state.model.absen;

              return SizedBox(
                height: 100.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        var data = list[index];
                        return storyButton(
                            Api.imageURL + '/' + list[index].user!.photo,
                            data.user!.name);
                      }),
                ),
              );
            } else {
              return buildLoadingWhite();
            }
          },
        ),

        //Now let's create our chat timeline
        Expanded(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: containerRadius, topRight: containerRadius),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 12.0, right: 12.0, top: 10.0),
                  child: BlocBuilder<AbsenBloc, AbsenState>(
                    builder: (context, state) {
                      if (state is AbsenInitial || state is AbsenLoadingState) {
                        return buildLoading();
                      } else if (state is AbsenErrorState) {
                        return buildError(state.errorMsg);
                      } else if (state is AbsenLoadedState) {
                        var list = state.model.absen;
                        final allUsersAbleToParty = list.every(
                            (Absen a) => a.userId == int.parse(widget.userId));

                        print(
                            "userId ${widget.userId} visiblity $allUsersAbleToParty");

                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    var data = list[index];
                                    var url = data.date == 'date'
                                        ? Api.imageURL +
                                            '/' +
                                            list[index].user!.photo
                                        : Api.imageAbsenURL +
                                            '/' +
                                            list[index].photo;
                                    return chatTile(
                                        url,
                                        data.user!.name,
                                        data.user!.unit,
                                        data.date != 'date'
                                            ? "Telah Absen pada pukul ${data.date} ${data.time} di daerah ${data.location}"
                                            : 'Belum ada kabar',
                                        data.date == 'date' ? false : true);
                                  }),
                            ),
                            Visibility(
                              visible: true,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CameraScrenn(
                                      userId: widget.userId,
                                      title: 'Take ur picture',
                                      camera: widget.camera,
                                    ),
                                  ));
                                },
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                          Icons.supervised_user_circle_outlined,
                                          color: Colors.white),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Check In",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline6,
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return buildError(state.toString());
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        widget.userBloc.add(LogOutEvent());
        break;
      case 'Settings':
        break;
    }
  }

  void gotoAnotherPage(Widget widget) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }

  Widget buildLoading() {
    return Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary)));
  }

  Widget buildLoadingWhite() {
    return const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
  }

  Widget buildError(String msg) {
    return Center(
      child: Text(msg,
          style:
              const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
    );
  }
}
