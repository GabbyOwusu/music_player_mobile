import 'dart:ffi';

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
          title: Text(songTitle, overflow: TextOverflow.ellipsis),
          subtitle: Text(artist, overflow: TextOverflow.ellipsis),
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

Widget backbutton(BuildContext context) {
  return IconButton(
    onPressed: () {
      Navigator.pop(context);
    },
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    icon: Icon(Icons.arrow_back),
    color: Colors.black,
  );
}

AppBar appBAr(
  BuildContext context,
  String title,
  Widget trailing,
  Widget leadingIcon,
) {
  return AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: leadingIcon,
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

class CustomField extends StatelessWidget {
  final Function(void) onchange;

  const CustomField({
    Key? key,
    required this.onchange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onchange,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        disabledBorder: InputBorder.none,
        suffixIcon: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Icon(
              Icons.search,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.only(left: 20),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: 'Search',
        hintStyle: TextStyle(
          fontSize: 17,
          color: Colors.grey,
        ),
      ),
    );
  }
}
