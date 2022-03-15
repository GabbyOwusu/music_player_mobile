import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:music_streaming/constants/common.dart';
import 'package:music_streaming/constants/ui_colors.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/screens/playlist_details.dart';
import 'package:music_streaming/widgets/artwork_widget.dart';
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
  @override
  Widget build(BuildContext context) {
    final p = context.watch<SongProvider>();
    final playlist = p.playlist ?? [];
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
          'Playlists',
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
                'Created a list of mixes just for you',
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
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    height: 180,
                    width: 320,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.2),
                      //     offset: Offset(0, 30),
                      //     blurRadius: 30,
                      //     spreadRadius: -15,
                      //   ),
                      // ],
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
                                  'Burna boy,Joey B',
                                  style: TextStyle(fontSize: 13),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Level up',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
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
                  );
                },
              ),
            ),
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Playlist',
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
                'All your playlists in one place',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.grey,
                ),
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
                return index == 0
                    ? createPlayList(ontap: () {})
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return PlayListDetails(playlist: playlist[index]);
                            }),
                          );
                        },
                        child: PlayListCard(playlist: playlist[index]),
                      );
              },
            ),
            SizedBox(height: 30),
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
  late Future<Uint8List?> f;

  @override
  void initState() {
    f = OnAudioQuery().queryArtwork(
      widget.playlist.id,
      ArtworkType.PLAYLIST,
      format: ArtworkFormat.JPEG,
      size: 400,
      quality: 100,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: UiColors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ArtworkWidget(
            future: f,
            artworkBorder: BorderRadius.circular(16),
            nullArtworkWidget: Icon(
              Icons.music_note,
              color: UiColors.blue,
              size: 15,
            ),
            artworkWidth: double.infinity,
            artworkHeight: double.infinity,
            id: widget.playlist.id,
            type: ArtworkType.AUDIO,
          ),
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
    );
  }
}
