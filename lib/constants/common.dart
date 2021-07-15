import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class SongTile extends StatefulWidget {
  final SongInfo songInfo;
  final Function() onTap;
  final int index;

  const SongTile({
    Key key,
    @required this.index,
    @required this.onTap,
    @required this.songInfo,
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
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.music_note),
          ),
          title: Text(widget.songInfo.title, overflow: TextOverflow.ellipsis),
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

// class Art extends StatelessWidget {
//   const Art({
//     Key? key,
//     required this.index,
//     required this.type,
//     required this.art,
//     this.radius,
//     this.fit,
//   });

//   final int? index;
//   final ArtworkType type;
//   final String? art;
//   final BoxFit? fit;
//   final BorderRadius? radius;

//   @override
//   Widget build(BuildContext context) {
//     return QueryArtworkWidget(
//       artworkFit: fit,
//       artworkBorder: radius ?? BorderRadius.circular(12),
//       id: index ?? 0,
//       type: type,
//       artwork: art,
//       deviceSDK: 9,
//     );
//   }
// }

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
    Key key,
    @required this.onchange,
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
