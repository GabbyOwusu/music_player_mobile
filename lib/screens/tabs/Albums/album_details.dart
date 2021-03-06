import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:music_streaming/constants/constants.dart';
import 'package:music_streaming/theme/ui_colors.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/screens/tabs/Songs/song_tile.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AlbumDetails extends StatefulWidget {
  final AlbumModel album;
  final Uint8List? art;
  const AlbumDetails({
    Key? key,
    required this.album,
    required this.art,
  }) : super(key: key);

  @override
  _AlbumDetailsState createState() => _AlbumDetailsState();
}

class _AlbumDetailsState extends State<AlbumDetails> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SongProvider>();
    final p = provider.songs.where((s) {
      return s.album == widget.album.album;
    }).toList();

    final albumSongs = p..sort(((a, b) => a.track!.compareTo(b.track!)));

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              leading: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10, left: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  iconSize: 18,
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
              elevation: 0,
              floating: true,
              backgroundColor: Colors.transparent,
              expandedHeight: 350,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: UiColors.blue.withOpacity(0.1),
                  ),
                  child: widget.art != null
                      ? Image.memory(
                          widget.art!,
                          width: double.infinity,
                          height: double.infinity,
                          scale: 1.0,
                          fit: BoxFit.cover,
                        )
                      : IconButton(
                          onPressed: null,
                          icon: Image.asset(
                            Constants.IMG_DISK,
                            color: UiColors.blue,
                            height: 50,
                          ),
                        ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.album.album,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.album.artist} - ${widget.album.numOfSongs} songs',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: IconButton(
                            onPressed: () {
                              // provider.playSong(albumSongs.first);
                              // provider.setPlayingList(albumSongs);
                            },
                            icon: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ...List.generate(
                    albumSongs.length,
                    (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: SongTile(
                          onTap: () {
                            provider.setPlayingList(albumSongs);
                          },
                          song: albumSongs[index],
                          leading: Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              color: UiColors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: null,
                              icon: Image.asset(
                                Constants.IMG_DISK,
                                color: UiColors.blue,
                                height: 15,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 50),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
