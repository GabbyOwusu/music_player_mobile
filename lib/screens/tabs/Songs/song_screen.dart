import 'dart:io';
import 'dart:typed_data';

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
  int currentIndex;
  SongProvider get p {
    return Provider.of<SongProvider>(context, listen: false);
  }

  FlutterAudioQuery query = FlutterAudioQuery();

  @override
  Widget build(BuildContext context) {
    context.watch<SongProvider>().songs;
    return p.songs.length != null
        ? Padding(
            padding: const EdgeInsets.only(left: 10, right: 30),
            child: Column(
              children: [
                Container(
                  height: 700,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: p.songs.length,
                    itemBuilder: (context, index) {
                      currentIndex = index;
                      return Stack(
                        children: [
                          if (p.androidversion > 28)
                            BuildSongList(index: index, p: p)
                          else
                            SongTile(
                              coverArt: p.songs[index].albumArtwork == null
                                  ? AssetImage('images/music_note.png')
                                  : FileImage(
                                      File(p.songs[index].albumArtwork),
                                    ),
                              index: index,
                              provider: p,
                              songInfo: p.songs[index],
                              onTap: () async {
                                setState(() {
                                  p.playSong(p.songs[index]);
                                });
                              },
                            ),
                        ],
                      );
                    },
                  ),
                ),
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

class BuildSongList extends StatefulWidget {
  final SongProvider p;
  final int index;
  const BuildSongList({
    Key key,
    @required this.index,
    @required this.p,
  }) : super(key: key);

  @override
  _BuildSongListState createState() => _BuildSongListState();
}

class _BuildSongListState extends State<BuildSongList> {
  Future data;

  @override
  void initState() {
    data = widget.p.audioQuery.getArtwork(
      type: ResourceType.SONG,
      id: widget.p.songs[widget.index].id,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
        future: data,
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? SongTile(
                  coverArt: snapshot.data.isEmpty || snapshot.data == null
                      ? AssetImage('images/song_note.png')
                      : MemoryImage(snapshot?.data),
                  index: widget.index,
                  provider: widget.p,
                  songInfo: widget.p.songs[widget.index],
                  onTap: () async {
                    setState(() {
                      widget.p.playSong(widget.p.songs[widget.index]);
                    });
                  },
                )
              : SizedBox();
        });
    ;
  }
}
