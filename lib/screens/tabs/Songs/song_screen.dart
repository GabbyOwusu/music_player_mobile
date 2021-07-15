import 'package:flutter/material.dart';
import 'package:music_streaming/constants/common.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:provider/provider.dart';

class Songs extends StatefulWidget {
  const Songs({Key key}) : super(key: key);

  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  SongProvider get p {
    return Provider.of<SongProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<SongProvider>().songs;
    return p.songs.length > 0
        ? Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, right: 30),
            child: Column(
              children: [
                // ...List.generate(
                //     p.songs.length,
                //     (index) => SongTile(
                //         index: index,
                //         songInfo: p.songs[index],
                //         onTap: () {
                //           setState(() {
                //             p.addNowplaying(p.songs[index]);
                //             print(p.playing);
                //           });
                //         })),
                Container(
                  height: 700,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: p.songs.length,
                    itemBuilder: (context, index) {
                      return SongTile(
                        index: index,
                        songInfo: p.songs[index],
                        onTap: () {
                          setState(() {
                            p.addNowplaying(p.songs[index]);
                            print(p.playing);
                          });
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 150),
              ],
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.music_note_rounded),
                Text('There are no songs on your device'),
              ],
            ),
          );
  }
}
