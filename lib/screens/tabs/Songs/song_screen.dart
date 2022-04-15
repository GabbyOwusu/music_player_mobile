import 'package:flutter/material.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/screens/tabs/Songs/song_tile.dart';
import 'package:provider/provider.dart';

class Songs extends StatefulWidget {
  const Songs({Key? key}) : super(key: key);

  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = context.watch<SongProvider>();
    final songs = provider.songs;
    return SizedBox(
      height: 500,
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 2),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return SongTile(
            onTap: () => provider.setPlayingList(songs),
            song: songs[index],
          );
        },
      ),
    );
    // : Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Icon(Icons.music_note_rounded),
    //         Text('There are no songs on your device'),
    //       ],
    //     ),
    //   );
  }
}
