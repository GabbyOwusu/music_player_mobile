import 'package:flutter/material.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    Key? key,
    required this.songTitle,
    required this.artist,
    required this.timestamp,
    required this.onTap,
  }) : super(key: key);

  final String songTitle;
  final String artist;
  final String timestamp;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.music_note),
          ),
          title: Text(songTitle),
          subtitle: Text(artist),
          trailing: Text(timestamp),
        ),
      ),
    );
  }
}

Widget playArrow = Image.asset(
  'images/play.png',
  width: 25,
  color: Colors.black,
);

AppBar appBAr(BuildContext context, String title, Widget trailing) {
  return AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      icon: Icon(Icons.arrow_back),
      color: Colors.black,
    ),
    title: Text(
      title,
      style: TextStyle(color: Colors.black),
    ),
    actions: [
      trailing,
      SizedBox(width: 20),
    ],
  );
}
