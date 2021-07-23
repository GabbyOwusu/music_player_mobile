import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_streaming/constants/ui_colors.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/screens/tabs/Albums/album_screen.dart';
import 'package:provider/provider.dart';

class Albums extends StatefulWidget {
  const Albums({Key key}) : super(key: key);

  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  SongProvider get provider {
    return Provider.of<SongProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return provider.albumSongs.length != null
        ? Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 20,
              right: 30,
              bottom: 20,
            ),
            child: Container(
              height: 500,
              child: GridView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: provider.albums.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 250,
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      if (provider.androidversion > 28)
                        FutureBuilder(
                            future: provider.audioQuery.getArtwork(
                              type: ResourceType.ALBUM,
                              id: provider.albums[index].id,
                            ),
                            builder: (context, snapshot) {
                              return snapshot.connectionState ==
                                      ConnectionState.done
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return AlbumScreen(
                                                index: index,
                                                provider: provider,
                                                info: provider.albums[index],
                                                coverArt: snapshot.data.isEmpty
                                                    ? AssetImage(
                                                        'images/music_note.png',
                                                      )
                                                    : MemoryImage(
                                                        snapshot.data,
                                                      ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: AlbumCard(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return AlbumScreen(
                                                    index: index,
                                                    provider: provider,
                                                    info:
                                                        provider.albums[index],
                                                    coverArt: snapshot
                                                            .data.isEmpty
                                                        ? AssetImage(
                                                            'images/music_note.png')
                                                        : MemoryImage(
                                                            snapshot.data),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          provider: provider,
                                          index: index,
                                          albumCover: snapshot.data.isEmpty
                                              ? AssetImage(
                                                  'images/music_note.png')
                                              : MemoryImage(snapshot.data)))
                                  : SizedBox();
                            })
                      else
                        AlbumCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return AlbumScreen(
                                    index: index,
                                    provider: provider,
                                    info: provider.albums[index],
                                    coverArt: provider.albums[index].albumArt ==
                                            null
                                        ? AssetImage('images/music_note.png')
                                        : FileImage(
                                            File(provider
                                                .albums[index].albumArt),
                                          ),
                                  );
                                },
                              ),
                            );
                          },
                          provider: provider,
                          index: index,
                          albumCover: provider.albums[index].albumArt == null
                              ? AssetImage('images/music_note.png')
                              : FileImage(
                                  File(provider.albums[index].albumArt),
                                ),
                        ),
                    ],
                  );
                },
              ),
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.music_note_rounded),
                SizedBox(height: 5),
                Text('There are no albums on your device'),
              ],
            ),
          );
  }
}

class AlbumCard extends StatelessWidget {
  const AlbumCard({
    Key key,
    @required this.provider,
    @required this.index,
    @required this.albumCover,
    @required this.onTap,
  }) : super(key: key);

  final SongProvider provider;
  final int index;
  final ImageProvider<Object> albumCover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: UiColors.grey,
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: albumCover ?? AssetImage('images/music_note.png'),
                fit: BoxFit.cover,
              ),
            ),
            // child: Image.file(
            //   File(provider.albums[index].albumArt),
            //   fit: BoxFit.fitHeight,
            // ),
          ),
          SizedBox(height: 5),
          Text(
            provider.albums[index].title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 5),
          Text(
            provider.albums[index].artist,
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
