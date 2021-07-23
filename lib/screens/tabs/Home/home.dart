import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_streaming/constants/common.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/screens/playlists.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SongProvider get p {
    return Provider.of<SongProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 40),
        Padding(
          padding: EdgeInsets.only(left: 30),
          child: Text(
            'Recently played',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
        ),
        SizedBox(height: 15),
        RecentlyPlayed(
          title: p.playing?.title,
          artist: p.playing?.artist,
          coverArt: p.playing?.albumArtwork == null
              ? AssetImage('images/music_note.png')
              : FileImage(File(p.playing?.albumArtwork)),
        ),
        SizedBox(height: 40),
        Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
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
                        return Playlist(provider: p);
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
        SizedBox(height: 15),
        Container(
          height: 180,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: p.playlist.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                padding: EdgeInsets.only(left: 10, bottom: 10),
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(
                  left: index == 0 ? 30 : 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: playArrow,
              );
            },
          ),
        )
      ],
    );
  }
}

class RecentlyPlayed extends StatelessWidget {
  const RecentlyPlayed({
    @required this.coverArt,
    @required this.artist,
    @required this.title,
    Key key,
  }) : super(key: key);

  final ImageProvider coverArt;
  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: coverArt ?? AssetImage('images/song_note.png'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400],
            offset: Offset(0, 30),
            blurRadius: 20,
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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.2),
              Colors.black.withOpacity(0.4),
            ],
          ),
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
                      artist ?? 'Song artist',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      title ?? 'Song title',
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
    );
  }
}
