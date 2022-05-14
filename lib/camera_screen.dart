import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_erwin/blocs/absen_bloc/absen_bloc.dart';
import 'package:flutter_erwin/blocs/user_bloc/user_bloc.dart';
import 'package:flutter_erwin/dashboard_screen.dart';
import 'package:flutter_erwin/models/absen_model.dart';
import 'package:flutter_erwin/utils/AppColor.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CameraScrenn extends StatefulWidget {
  const CameraScrenn(
      {Key? key,
      required this.title,
      required this.camera,
      required this.userId})
      : super(key: key);

  final String title;
  final String userId;
  final CameraDescription camera;

  @override
  State<CameraScrenn> createState() => _CameraScrennState();
}

class _CameraScrennState extends State<CameraScrenn> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  int cameraview = 1;

  FlutterFFmpeg fFmpeg = FlutterFFmpeg();

  String imgPath = "";

  String resLocation = "";
  String resRole = "1";
  late File? resFile = null;

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    // print(placemarks);
    Placemark place = placemarks[0];
    var loc =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}';
    print(loc);
    resLocation = loc;

    if (resLocation != "") {
      absenBloc.add(AbsenStoreEvent(
          absen: Absen(
              userId: int.parse(widget.userId),
              date: "date",
              time: "time",
              role: resRole,
              photo: "photo",
              location: resLocation),
          file: resFile));
    } else {}
    setState(() {});
  }

  late AbsenBloc absenBloc;

  @override
  void initState() {
    super.initState();

    absenBloc = BlocProvider.of(context);

    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: BlocListener<AbsenBloc, AbsenState>(
        listener: (context, state) {
          print(state);
          if (state is AbsenInitial || state is AbsenLoadingState) {
            EasyLoading.show();
          } else if (state is AbsenErrorState) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.errorMsg);
          } else if (state is AbsenSuccessState) {
            EasyLoading.dismiss();
            EasyLoading.showSuccess(state.successMsg);

            gotoHomePage();
          }
        },
        child: Container(
            height: size.height,
            width: size.width,
            child: imgPath == ""
                ? takePictureSelfi()
                : previewImageFromSelfi(imgPath)),
      ),
    );
  }

  Stack takePictureSelfi() {
    return Stack(
      children: [
        FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              // return Center(
              //   child: Transform.scale(
              //     scale: 1 / (_controller.value.aspectRatio * size.aspectRatio),
              //     alignment: Alignment.center,
              //     child: CameraPreview(_controller),
              //   ),
              // );

              return Center(
                child: CameraPreview(_controller),
              );
            } else {
              // Otherwise, display a loading indicator.
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: GestureDetector(
            onTap: () async {
              try {
                // Ensure that the camera is initialized.
                await _initializeControllerFuture;

                // Attempt to take a picture and get the file `image`
                // where it was saved.
                final image = await _controller.takePicture();

                // await fFmpeg.execute(
                //     "-y -i " + image.path + " -vf transpose=3 " + image.path);

                setState(() {
                  imgPath = image.path;
                  resFile = File(image.path);
                });
              } catch (e) {
                // If an error occurs, log the error to the console.
                print(e);
              }
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_rounded, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    "Take Picture",
                    style: Theme.of(context).primaryTextTheme.headline6,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Stack previewImageFromSelfi(String imagePath) {
    return Stack(
      children: [
        Center(child: Image.file(File(imagePath), fit: BoxFit.cover)),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      imgPath = "";
                    });
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.replay_rounded, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          "Take again",
                          style: Theme.of(context).primaryTextTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    Position position = await _getGeoLocationPosition();
                    print(
                        'Lat: ${position.latitude} , Long: ${position.longitude}');
                    GetAddressFromLatLong(position);
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.done_all_rounded, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          "Check In",
                          style: Theme.of(context).primaryTextTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void gotoHomePage() {
    UserBloc userBloc = BlocProvider.of(context);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => DashboardScreen(
                userBloc: userBloc,
                userId: widget.userId,
                camera: widget.camera)),
        (Route<dynamic> route) => false);
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Container(
          height: size.height,
          width: size.width,
          child: Center(child: Image.file(File(imagePath), fit: BoxFit.cover))),
    );
  }
}

class _MediaSizeClipper extends CustomClipper<Rect> {
  final Size mediaSize;
  const _MediaSizeClipper(this.mediaSize);
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, mediaSize.width, mediaSize.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
