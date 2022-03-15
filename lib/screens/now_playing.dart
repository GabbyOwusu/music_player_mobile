import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:music_streaming/constants/common.dart';
import 'package:music_streaming/constants/ui_colors.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/screens/lyrics_screen.dart';
import 'package:music_streaming/screens/tabs/Songs/song_tile.dart';
import 'package:music_streaming/widgets/artwork_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({Key? key}) : super(key: key);

  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  late Future<Uint8List?> f;

  @override
  void initState() {
    final provider = context.read<SongProvider>();
    final playing =
        provider.playing ?? provider.recent ?? (provider.songs ?? []).first;
    provider.getalbumSongs(type: AudiosFromType.ALBUM, id: playing.album!);
    f = OnAudioQuery().queryArtwork(
      playing.id,
      ArtworkType.AUDIO,
      format: ArtworkFormat.PNG,
      size: 500,
      quality: 100,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SongProvider>();
    final playing = provider.playing ?? provider.recent;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
        ),
        title: Text(
          'Now Playing',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: UiColors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Center(
                  child: ArtworkWidget(
                    future: f,
                    artworkBorder: BorderRadius.circular(20),
                    nullArtworkWidget: Icon(
                      Icons.music_note,
                      color: UiColors.blue,
                    ),
                    artworkWidth: double.infinity,
                    artworkHeight: double.infinity,
                    id: playing?.id ?? 0,
                    type: ArtworkType.AUDIO,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) => Lyrics(),
                    );
                  },
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Lyrics',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(
            playing?.artist ?? '<Unknown>',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              playing?.title ?? "Unknown",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                iconSize: 30,
                icon: Icon(Icons.skip_previous_rounded),
              ),
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    if (provider.playing == null) {
                      provider.playSong(playing!);
                      return;
                    } else
                      provider.isPlaying == true
                          ? provider.pauseSong()
                          : provider.resume();
                  },
                  icon: Icon(
                    provider.isPlaying == true
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    size: 35,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                iconSize: 30,
                icon: Icon(Icons.skip_next_rounded),
              ),
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.shuffle_rounded),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) => _AlbumSongs(
                        p: provider.albumSongs,
                        song: playing,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 1,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 8,
              ),
            ),
            child: Expanded(
              child: Slider(
                activeColor: Colors.black,
                inactiveColor: Colors.grey[300],
                value: provider.currentDuration.toDouble(),
                min: 0.0,
                max: provider.duration?.inSeconds.toDouble() ?? 100,
                onChanged: (v) async {
                  double position = v - provider.currentDuration;
                  await provider.seek(position);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Text(provider.timePlayed ?? "00:00"),
                Spacer(),
                Text(
                  parseToMinutesSeconds(
                    int.parse(playing?.duration?.toString() ?? "0"),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _AlbumSongs extends StatelessWidget {
  const _AlbumSongs({Key? key, this.p, this.song}) : super(key: key);

  final SongModel? song;
  final List<SongModel>? p;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${song?.album} - ${p?.length} songs',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        song?.title ?? "Unknown",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: Icon(
                    CupertinoIcons.heart_fill,
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ...List.generate(p?.length ?? 0, (index) {
              return SongTile(song: (p ?? [])[index]);
            })
          ],
        ),
      ),
    );
  }
}
