import 'package:flutter/material.dart';

Widget chatTile(
    String imgUrl, String userName, String msg, String date, bool seen) {
  return InkWell(
    onTap: () {},
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(imgUrl),
            radius: 28.0,
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(msg),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Expanded(child: Text(date)),
                    Icon(
                        seen
                            ? Icons.done_all_rounded
                            : Icons.remove_done_rounded,
                        color: seen ? Colors.green : Colors.red,
                        size: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
