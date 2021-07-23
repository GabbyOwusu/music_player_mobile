import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_streaming/constants/common.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/screens/tabs/Albums/album_screen.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  SongProvider get provider {
    return Provider.of<SongProvider>(context, listen: false);
  }

  List<SongInfo> songResults = [];
  List<AlbumInfo> albumResults = [];
  String query;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              'Search',
              style: TextStyle(color: Colors.black),
            ),
            leading: Padding(
              padding: EdgeInsets.only(left: 20),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomField(
                      onchange: (data) {
                        if (data.isNotEmpty)
                          setState(() {
                            songResults = provider.songs.where((song) {
                              return song.title.toLowerCase().contains(data) ||
                                  song.artist.toLowerCase().contains(data);
                            }).toList();

                            albumResults = provider.albums.where((album) {
                              return album.title.toLowerCase().contains(data) ||
                                  album.artist.toLowerCase().contains(data);
                            }).toList();

                            query = songResults.isEmpty || albumResults.isEmpty
                                ? null
                                : data;
                          });
                        else
                          setState(() {
                            songResults = [];
                            albumResults = [];
                            query = null;
                          });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    alignment: Alignment.center,
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                    child: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onPressed: () {},
                      icon: Icon(Icons.mic),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: query == null
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    songResults.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Search',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Type a song title or artist name',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            height: 1000,
                            child: ListView.builder(
                              itemCount: songResults.length,
                              itemBuilder: (context, index) {
                                return SongResults(
                                  index: index,
                                  songResults: songResults,
                                  provider: provider,
                                );
                              },
                            ),
                          ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}

class SongResults extends StatelessWidget {
  const SongResults({
    Key key,
    @required this.songResults,
    @required this.provider,
    @required this.index,
  }) : super(key: key);

  final List<SongInfo> songResults;
  final SongProvider provider;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SongTile(
      index: index,
      songInfo: songResults[index],
      onTap: () {},
      coverArt: FileImage(
        File(songResults[index].albumArtwork),
      ),
      provider: provider,
    );
  }
}

class AlbumResults extends StatelessWidget {
  const AlbumResults({
    Key key,
    @required this.provider,
    @required this.index,
    @required this.coverArt,
    @required this.info,
  }) : super(key: key);

  final SongProvider provider;
  final AlbumInfo info;
  final int index;
  final ImageProvider<Object> coverArt;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return AlbumScreen(
              index: index,
              provider: provider,
              coverArt: coverArt,
              info: info,
            );
          }),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 180,
            height: 180,
            margin: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: coverArt ?? AssetImage('images/music_note.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(
                16,
              ),
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
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
