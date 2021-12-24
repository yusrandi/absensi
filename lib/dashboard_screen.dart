import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_erwin/camera_screen.dart';
import 'package:flutter_erwin/utils/size_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'blocs/absen_bloc/absen_bloc.dart';
import 'components/chattile.dart';
import 'components/storybutton.dart';
import 'config/api.dart';
import 'models/absen_model.dart';

class DashboardScreen extends StatefulWidget {
  final CameraDescription camera;

  const DashboardScreen({Key? key, required this.camera}) : super(key: key);

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
    absenBloc.add(AbsenFetchData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("WhatsApp Clone"),
        backgroundColor: mainColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: BlocBuilder<AbsenBloc, AbsenState>(
        builder: (context, state) {
          print(state);
          if (state is AbsenInitial || state is AbsenLoadingState) {
            return buildLoading();
          } else if (state is AbsenErrorState) {
            return buildError(state.errorMsg);
          } else if (state is AbsenLoadedState) {
            List<Absen> list = state.model.absen;
            return body(list);
          } else {
            return buildError(state.toString());
          }
        },
      ),
    );
  }

  Column body(List<Absen> list) {
    return Column(
      children: [
        //First let's create the Story time line container
        SizedBox(
          height: 100.0,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        var data = list[index];
                        var url = data.date == 'date'
                            ? Api.imageURL + '/' + list[index].user!.photo
                            : Api.imageAbsenURL + '/' + list[index].photo;
                        return chatTile(
                            url,
                            data.user!.name,
                            data.user!.unit,
                            data.date != 'date'
                                ? "${data.date} ${data.time}"
                                : 'Belum ada kabar',
                            data.date == 'date' ? false : true);
                      }),
                ),
              ),
              Positioned(
                  left: MediaQuery.of(context).size.width * 0.15,
                  right: MediaQuery.of(context).size.width * 0.15,
                  bottom: MediaQuery.of(context).size.height * 0.10,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CameraScrenn(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.supervised_user_circle_outlined,
                              color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            "Check In",
                            style: Theme.of(context).primaryTextTheme.headline6,
                          ),
                        ],
                      )),
                    ),
                  )),
            ],
          ),
        )
      ],
    );
  }

  Widget buildLoading() {
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
