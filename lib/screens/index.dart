import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/screens/now_playing.dart';
import 'package:music_streaming/screens/search.dart';
import 'package:music_streaming/screens/tabs/Albums/albums.dart';
import 'package:music_streaming/screens/tabs/Artists/artists.dart';
import 'package:music_streaming/screens/tabs/Home/home.dart';
import 'package:music_streaming/screens/tabs/Songs/song_screen.dart';

import 'package:on_audio_query/on_audio_query.dart';

import 'package:provider/provider.dart';

class Index extends StatelessWidget {
  Index({
    Key? key,
  }) : super(key: key);

  final tabMenu = [
    'Home',
    'Songs',
    'Albums',
    'Artists',
  ];

  final tabs = [
    Home(),
    Songs(),
    Albums(),
    Artists(),
  ];

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SongProvider>();
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: false,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Hello Gabby!',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 20),
              alignment: Alignment.center,
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],
              ),
              child: IconButton(
                icon: Image.asset('images/search.png', width: 20),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Search(),
                    ),
                  );
                },
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: TabBar(
              isScrollable: true,
              labelPadding: EdgeInsets.symmetric(horizontal: 30),
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: tabMenu.map((e) => Tab(child: Text(e))).toList(),
            ),
          ),
        ),
        body: TabBarView(children: tabs),
        bottomNavigationBar: p.playing == null
            ? null
            : PlayingCard(
                playing: p.playing,
                onTap: () {
                  showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return NowPlaying();
                    },
                  );
                },
              ),
      ),
    );
  }
}

class PlayingCard extends StatefulWidget {
  const PlayingCard({
    Key? key,
    this.onTap,
    required this.playing,
  }) : super(key: key);

  final VoidCallback? onTap;
  final SongModel? playing;

  @override
  State<PlayingCard> createState() => _PlayingCardState();
}

class _PlayingCardState extends State<PlayingCard> {
  @override
  Widget build(BuildContext context) {
    final p = context.watch<SongProvider>();
    final playing = p.playing;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 70,
        width: double.infinity,
        margin: EdgeInsets.only(
          left: 30,
          right: 30,
          bottom: 20,
          top: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              offset: Offset(0, 10),
              blurRadius: 50,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: QueryArtworkWidget(
                keepOldArtwork: true,
                artworkBorder: BorderRadius.circular(10),
                nullArtworkWidget: Icon(Icons.music_note),
                artworkWidth: double.infinity,
                artworkHeight: double.infinity,
                id: playing?.id ?? 0,
                type: ArtworkType.AUDIO,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    playing?.artist ?? 'No media',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    playing?.title ?? 'No media',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Image.asset(
              'images/play.png',
              color: Colors.black,
              width: 30,
            ),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
