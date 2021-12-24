import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget storyButton(String imgUrl, String userName) {
  return Padding(
    padding: const EdgeInsets.only(right: 10.0),
    child: Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(imgUrl),
              radius: 26.0,
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: Icon(Icons.circle,
                    color: Colors.lightGreenAccent, size: 20)),
          ],
        ),
        const SizedBox(height: 5.0),
        Text(
          userName,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
}
