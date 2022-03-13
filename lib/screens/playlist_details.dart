import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/widgets/artwork_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import 'tabs/Songs/song_tile.dart';

class PlayListDetails extends StatefulWidget {
  final PlaylistModel playlist;
  const PlayListDetails({Key? key, required this.playlist}) : super(key: key);

  @override
  _PlayListDetailsState createState() => _PlayListDetailsState();
}

class _PlayListDetailsState extends State<PlayListDetails> {
  late Future<Uint8List?> f;

  @override
  void initState() {
    context.read<SongProvider>().getPlaylistSongs(
          widget.playlist.id.toString(),
        );
    f = OnAudioQuery().queryArtwork(
      widget.playlist.id,
      ArtworkType.PLAYLIST,
      format: ArtworkFormat.PNG,
      size: 500,
      quality: 100,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SongProvider>();
    // provider.getPlaylistSongs(widget.playlist.id.toString());
    final albumSongs = provider.playlistSongs;
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
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              elevation: 0,
              floating: true,
              backgroundColor: Colors.transparent,
              expandedHeight: 350,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey),
                  child: ArtworkWidget(
                    future: f,
                    format: ArtworkFormat.PNG,
                    size: 1080,
                    quality: 100,
                    artworkQuality: FilterQuality.high,
                    artworkBorder: BorderRadius.circular(0),
                    nullArtworkWidget: Icon(Icons.music_note),
                    artworkWidth: double.infinity,
                    artworkHeight: double.infinity,
                    id: widget.playlist.id,
                    type: ArtworkType.PLAYLIST,
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
                              SizedBox(height: 10),
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
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: SongTile(song: albumSongs[index]),
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
