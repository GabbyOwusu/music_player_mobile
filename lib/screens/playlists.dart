import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:music_streaming/constants/constants.dart';
import 'package:music_streaming/screens/mix_details.dart';
import 'package:music_streaming/theme/ui_colors.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/screens/CreatePlaylist.dart';
import 'package:music_streaming/screens/playlist_details.dart';
import 'package:music_streaming/widgets/coverArt.dart';
import 'package:music_streaming/widgets/helpers.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Playlist extends StatefulWidget {
  const Playlist({
    Key? key,
  }) : super(key: key);

  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  List<String> images = [
    Constants.IMG_GUITAR,
    Constants.IMG_TAPES,
    Constants.IMG_CROWD,
    Constants.IMG_HEADPHONE,
    Constants.IMG_CROWD,
  ];

  List<String> genres = [
    "Gospel",
    "African music",
    "Hip-Hop/Rap",
    "Pop",
    "R&B",
  ];

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SongProvider>();
    final playlist = p.playlist;
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
          'Mixes & Playlists',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Just for you',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'A curated list of mixes just for you',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(width: 10),
                padding: EdgeInsets.symmetric(horizontal: 30),
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      rootNavigator(context).push(
                        MaterialPageRoute(builder: (context) {
                          return MixDetails(
                            genre: genres[index],
                            art: images[index],
                          );
                        }),
                      );
                    },
                    child: Container(
                      height: 180,
                      width: 320,
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(images[index]),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Burna boy, Joey B',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.5),
                                          blurRadius: 8.0,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '${genres[index]}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.5),
                                          blurRadius: 8.0,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.play_arrow_rounded,
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
                  );
                },
              ),
            ),
            SizedBox(height: 40),
            if (playlist.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Playlist',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'All your playlists in one place',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    // IconButton(
                    //   onPressed: () {
                    //     rootNavigator(context).push(
                    //       MaterialPageRoute(builder: (context) {
                    //         return CreatePlaylist();
                    //       }),
                    //     );
                    //   },
                    //   icon: Icon(Icons.add),
                    // )
                  ],
                ),
              ),
              SizedBox(height: 20),
              GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 30),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: playlist.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 270,
                  crossAxisCount: 2,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  return PlayListCard(playlist: playlist[index]);
                },
              ),
              SizedBox(height: 30),
            ],
            if (playlist.isEmpty) ...[
              SizedBox(height: 50),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No playlist Added",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Add a new playlist",
                      style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        rootNavigator(context).push(
                          MaterialPageRoute(builder: (context) {
                            return CreatePlaylist();
                          }),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: UiColors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "Add playlist",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget createPlayList({VoidCallback? ontap}) {
    return GestureDetector(
      onTap: ontap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: UiColors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: UiColors.blue,
                  ),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Create playlist',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Create a new playlist',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
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
  Uint8List? art;
  Future<Uint8List?>? f;

  void getArt() async {
    final p = await OnAudioQuery().queryArtwork(
      widget.playlist.id,
      ArtworkType.PLAYLIST,
      format: ArtworkFormat.PNG,
      size: 300,
    );
    setState(() => art = p);
  }

  @override
  void initState() {
    getArt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return PlayListDetails(
              playlist: widget.playlist,
              art: art,
            );
          }),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: UiColors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: CoverArt(art: art),
          ),
          SizedBox(height: 10),
          Text(
            widget.playlist.playlist,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Songs ${widget.playlist.numOfSongs}',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
