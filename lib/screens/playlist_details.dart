import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/theme/ui_colors.dart';
import 'package:music_streaming/widgets/coverArt.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlayListDetails extends StatefulWidget {
  final Uint8List? art;
  final PlaylistModel playlist;
  const PlayListDetails({Key? key, required this.playlist, required this.art})
      : super(key: key);

  @override
  _PlayListDetailsState createState() => _PlayListDetailsState();
}

class _PlayListDetailsState extends State<PlayListDetails> {
  @override
  void initState() {
    final p = context.read<SongProvider>();
    p.getPlaylistSongs(widget.playlist.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SongProvider>();
    final p = provider.playlistSongs;
    final albumSongs = provider.songs
        .where((e) => p.any((element) {
              return element.title.contains(e.title);
            }))
        .toList();
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.black),
              ),
              elevation: 0,
              floating: true,
              backgroundColor: Colors.transparent,
              expandedHeight: 350,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey),
                  child: CoverArt(
                    radius: BorderRadius.circular(0),
                    art: widget.art,
                    size: 50,
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
                                widget.playlist.playlist,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.playlist.numOfSongs} songs',
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
                            onPressed: () {},
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
                      final song = albumSongs[index];
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            decoration: BoxDecoration(
                              color: UiColors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            height: 50,
                            width: 50,
                            child: QueryArtworkWidget(
                              keepOldArtwork: true,
                              artworkBorder: BorderRadius.circular(16),
                              nullArtworkWidget: CoverArt(art: null),
                              artworkWidth: double.infinity,
                              artworkHeight: double.infinity,
                              id: song.id,
                              type: ArtworkType.AUDIO,
                            ),
                          ),
                          title: Text(
                            song.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            song.artist ?? "Unknown",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                          // trailing: selected
                          //     ? Radio(
                          //         value: 1,
                          //         groupValue: 1,
                          //         onChanged: (v) {
                          //           setState(() {
                          //             _selectedSongs.remove(song);
                          //           });
                          //         },
                          //       )
                          //     : Radio(
                          //         value: 1,
                          //         groupValue: 0,
                          //         onChanged: (v) {
                          //           setState(() {
                          //             _selectedSongs.add(song);
                          //           });
                          //         },
                          //       ),
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
