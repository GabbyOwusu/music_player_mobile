import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/screens/tabs/Songs/song_tile.dart';
import 'package:music_streaming/widgets/artwork_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AlbumDetails extends StatefulWidget {
  final AlbumModel album;
  const AlbumDetails({Key? key, required this.album}) : super(key: key);

  @override
  _AlbumDetailsState createState() => _AlbumDetailsState();
}

class _AlbumDetailsState extends State<AlbumDetails> {
  late Future<Uint8List?> f;

  @override
  void initState() {
    context.read<SongProvider>().getalbumSongs(
          type: AudiosFromType.ALBUM_ID,
          id: widget.album.id.toString(),
        );
    f = OnAudioQuery().queryArtwork(
      widget.album.id,
      ArtworkType.ALBUM,
      format: ArtworkFormat.PNG,
      size: 500,
      quality: 100,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SongProvider>();
    final albumSongs = provider.albumSongs;
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
                    id: widget.album.id,
                    type: ArtworkType.ALBUM,
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
                              SizedBox(height: 10),
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
                              onPressed: () {},
                              icon: Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                              )),
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
                          song: albumSongs[index],
                          leading: Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.music_note),
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