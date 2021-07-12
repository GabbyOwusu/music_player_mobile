import 'package:flutter/material.dart';
import 'package:music_streaming/constants/common.dart';

class Songs extends StatefulWidget {
  const Songs({Key? key}) : super(key: key);

  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 30, right: 30),
      child: Column(
        children: [
          ...List.generate(5, (index) {
            return SongTile(
              songTitle: 'Bebo',
              artist: 'Burna boy, Lexus , Joey B ',
              timestamp: '4:30',
              onTap: () {},
            );
          })
        ],
      ),
    );
  }
}
