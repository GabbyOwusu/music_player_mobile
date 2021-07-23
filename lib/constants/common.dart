import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_streaming/constants/ui_colors.dart';
import 'package:music_streaming/providers/songs_provider.dart';

class SongTile extends StatefulWidget {
  final SongProvider provider;
  final SongInfo songInfo;
  final Function() onTap;
  final int index;
  final ImageProvider<Object> coverArt;

  const SongTile({
    Key key,
    @required this.index,
    @required this.coverArt,
    @required this.onTap,
    @required this.songInfo,
    @required this.provider,
  }) : super(key: key);

  @override
  _SongTileState createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: UiColors.grey,
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: widget.coverArt ?? AssetImage('images/song_note.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            widget.songInfo.title,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            widget.songInfo.artist,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            '${parseToMinutesSeconds(
              int.parse(widget.songInfo.duration.toString()),
            )}',
          ),
        ),
      ),
    );
  }
}

class CustomForm extends StatelessWidget {
  final String hint;
  final Function onchange;
  const CustomForm({
    Key key,
    @required this.hint,
    @required this.onchange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onchange,
      decoration: InputDecoration(
        hoverColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: Colors.grey[200],
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.black),
        ),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 15),
        fillColor: Colors.grey[100],
        filled: true,
      ),
    );
  }
}

String parseToMinutesSeconds(int ms) {
  String data;
  Duration duration = Duration(milliseconds: ms);
  int minutes = duration.inMinutes;
  int seconds = (duration.inSeconds) - (minutes * 60);
  data = minutes.toString() + ":";
  if (seconds <= 9) data += "0";
  data += seconds.toString();
  return data;
}

double convertToDouble(String value) {
  var myDouble = double.parse(value);
  assert(myDouble is double);
  print(myDouble);
  print(myDouble.runtimeType);
  return myDouble;
}

Widget playArrow = Image.asset(
  'images/play.png',
  width: 25,
  color: Colors.white,
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
  final Function(String) onchange;

  const CustomField({
    Key key,
    @required this.onchange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 10),
      child: TextField(
        onChanged: onchange,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          disabledBorder: InputBorder.none,
          filled: true,
          isDense: true,
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: 'Search',
          hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
        ),
      ),
    );
  }
}
