import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:music_streaming/theme/ui_colors.dart';

import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/screens/now_playing.dart';
import 'package:music_streaming/screens/playlists.dart';
import 'package:music_streaming/screens/tabs/Songs/song_tile.dart';

import 'package:music_streaming/widgets/coverArt.dart';
import 'package:music_streaming/widgets/helpers.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../../constants/common.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = context.watch<SongProvider>();
    final songs = provider.songs;
    final recents = songs.length > 3 ? songs.getRange(0, 8) : songs;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text(
              'Last played',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
          ),
          SizedBox(height: 15),
          LastPlayedCard(),
          SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Text(
                  'Recently added',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Playlist(),
                      ),
                    );
                  },
                  child: Icon(Icons.arrow_forward_rounded),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          ...divideWidgets<SongModel>(
            divider: SizedBox(height: 5),
            list: recents.toList(),
            builder: (index, data) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: SongTile(
                  onTap: () => provider.setPlayingList(recents.toList()),
                  song: data,
                ),
              );
            },
          ),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}

class LastPlayedCard extends StatefulWidget {
  const LastPlayedCard({
    Key? key,
  }) : super(key: key);

  @override
  State<LastPlayedCard> createState() => _LastPlayedCardState();
}

class _LastPlayedCardState extends State<LastPlayedCard> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SongProvider>();
    final res = provider.playing ?? provider.recent ?? provider.songs.first;
    return GestureDetector(
      onTap: () {
        showCupertinoModalBottomSheet(
          context: context,
          builder: (context) {
            return NowPlaying();
          },
        );
      },
      child: Container(
        height: 200,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: UiColors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: Offset(0, 30),
              blurRadius: 30,
              spreadRadius: -15,
            ),
          ],
        ),
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Center(child: CoverArt(art: provider.nowPlayingArt)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          '${parseDuration(res.duration ?? 0)}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${res.artist}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${res.title}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (provider.playing == null) {
                              provider.playSong(res);
                              return;
                            } else
                              provider.isPlaying == true
                                  ? provider.pauseSong()
                                  : provider.resume();
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              provider.isPlaying == true
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
