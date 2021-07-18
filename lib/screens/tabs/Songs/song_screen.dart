import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<SongProvider>().songs;
    return p.songs.length != null
        ? Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, right: 30),
            child: Column(
              children: [
                Container(
                  height: 700,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: p.songs.length,
                    itemBuilder: (context, index) {
                      return
                          //p.songs[index].albumArtwork == null
                          //     ? FutureBuilder(
                          //         future: p.getArtWork(
                          //           ResourceType.SONG,
                          //           p.songs[index].id,
                          //         ),
                          //         builder: (context, data) {
                          //           return SongTile(
                          //             coverArt: data.data == null
                          //                 ? MemoryImage(data.data)
                          //                 : AssetImage('images/music_note.png'),
                          //             index: index,
                          //             provider: p,
                          //             songInfo: p.songs[index],
                          //             onTap: () {
                          //               setState(() {
                          //                 p.addNowplaying(p.songs[index]);
                          //                 print(p.playing);
                          //               });
                          //             },
                          //           );
                          //         })
                          //     :
                          SongTile(
                        coverArt: FileImage(
                          File(p.songs[index].albumArtwork),
                        ),
                        index: index,
                        provider: p,
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
