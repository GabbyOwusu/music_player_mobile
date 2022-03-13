import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:music_streaming/constants/common.dart';
import 'package:music_streaming/constants/ui_colors.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/screens/playlist_details.dart';
import 'package:music_streaming/screens/playlists.dart';
import 'package:music_streaming/screens/tabs/Songs/song_tile.dart';
import 'package:music_streaming/widgets/artwork_widget.dart';
import 'package:music_streaming/widgets/helpers.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

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
    final playlists = provider.playlist;
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
          Container(
            height: 180,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.grey[300],
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
              height: 180,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // gradient:  LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   colors: [
                //     Colors.black.withOpacity(0.1),
                //     Colors.black.withOpacity(0.1),
                //     Colors.black.withOpacity(0.2),
                //     Colors.black.withOpacity(0.4),
                //   ],
                // ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Text('45mins'),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Song artist',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Song title',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                      playArrow,
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 50),
          if (playlists.isEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Recently added',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ),
            SizedBox(
              height: 500,
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 10),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  return SongTile(song: songs[index]);
                },
              ),
            ),
            SizedBox(height: 50)
          ],
          if (playlists.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Text(
                    'Playlists',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Playlist();
                          },
                        ),
                      );
                    },
                    child: Image.asset(
                      'images/arrow.png',
                      width: 20,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(width: 30),
                padding: EdgeInsets.symmetric(horizontal: 30),
                shrinkWrap: true,
                itemCount: playlists.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        rootNavigator(context).push(
                          MaterialPageRoute(builder: ((context) {
                            return PlayListDetails(playlist: playlists[index]);
                          })),
                        );
                      },
                      child: PlayListCard(playlist: playlists[index]));
                },
              ),
            )
          ]
        ],
      ),
    );
  }
}

class PlayListCard extends StatefulWidget {
  const PlayListCard({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  final PlaylistModel playlist;

  @override
  State<PlayListCard> createState() => _PlayListCardState();
}

class _PlayListCardState extends State<PlayListCard> {
  late Future<Uint8List?> f;

  @override
  void initState() {
    f = OnAudioQuery().queryArtwork(
      widget.playlist.id,
      ArtworkType.PLAYLIST,
      format: ArtworkFormat.JPEG,
      size: 200,
      quality: 100,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: UiColors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Center(
            child: ArtworkWidget(
              future: f,
              size: 500,
              artworkBorder: BorderRadius.circular(20),
              nullArtworkWidget: Icon(Icons.music_note),
              artworkWidth: double.infinity,
              artworkHeight: double.infinity,
              id: widget.playlist.id,
              type: ArtworkType.PLAYLIST,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                bottom: 10,
              ),
              child: playArrow,
            ),
          ),
        ],
      ),
    );
  }
}
