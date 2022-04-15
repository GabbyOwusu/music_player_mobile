import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:music_streaming/theme/ui_colors.dart';

import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/screens/now_playing.dart';
import 'package:music_streaming/screens/search.dart';
import 'package:music_streaming/screens/tabs/Albums/albums.dart';
import 'package:music_streaming/screens/tabs/Artists/artists.dart';
import 'package:music_streaming/screens/tabs/Home/home.dart';
import 'package:music_streaming/screens/tabs/Songs/song_screen.dart';

import 'package:music_streaming/widgets/coverArt.dart';

import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

class Index extends StatelessWidget {
  Index({Key? key}) : super(key: key);

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
            padding: EdgeInsets.only(top: 15, left: 10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("images/dj.jpg"),
                ),
                SizedBox(width: 10),
                Text(
                  'Hello Gabby!',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 30, top: 20),
              alignment: Alignment.center,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],
              ),
              child: IconButton(
                color: Colors.black,
                icon: Icon(Iconsax.search_favorite),
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
              padding: EdgeInsets.only(bottom: 10),
              isScrollable: true,
              labelPadding: EdgeInsets.symmetric(horizontal: 30),
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: tabMenu.map(
                (e) {
                  return Tab(
                    height: 22,
                    iconMargin: EdgeInsets.zero,
                    child: Text(
                      e,
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
        body: TabBarView(children: tabs),
        bottomNavigationBar: p.playing == null ? null : PlayingCard(),
      ),
    );
  }
}

class PlayingCard extends StatefulWidget {
  const PlayingCard({Key? key}) : super(key: key);

  @override
  State<PlayingCard> createState() => _PlayingCardState();
}

class _PlayingCardState extends State<PlayingCard> {
  @override
  Widget build(BuildContext context) {
    final p = context.watch<SongProvider>();
    final playing = p.playing;
    return GestureDetector(
      onTap: () {
        showCupertinoModalBottomSheet(
          context: context,
          builder: (context) {
            return NowPlaying();
          },
        );
      },
      child: Container(
        height: 70,
        width: double.infinity,
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 10,
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
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 14),
          leading: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: UiColors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: CoverArt(
              radius: BorderRadius.circular(10),
              art: p.nowPlayingArt,
            ),
          ),
          title: Text(
            playing?.artist ?? 'No media',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          subtitle: TextScroll(
            playing?.title ?? 'No media',
            velocity: Velocity(
              pixelsPerSecond: Offset(40, 0),
            ),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => p.skip(prev: true),
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.skip_previous_rounded,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () => p.isPlaying == true ? p.pauseSong() : p.resume(),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: UiColors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    p.isPlaying == true
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    size: 20,
                    color: UiColors.blue,
                  ),
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () => p.skip(next: true),
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.skip_next_rounded,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
