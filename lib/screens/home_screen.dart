import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/screens/now_playing.dart';
import 'package:music_streaming/screens/search.dart';
import 'package:music_streaming/screens/tabs/Albums/albums.dart';
import 'package:music_streaming/screens/tabs/Artists/artists.dart';
import 'package:music_streaming/screens/tabs/Home/home_tabs.dart';
import 'package:music_streaming/screens/tabs/Home/home.dart';
import 'package:music_streaming/screens/tabs/Songs/song_screen.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

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

  SongProvider get provider {
    return Provider.of<SongProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
            toolbarHeight: 80,
            pinned: true,
            title: Padding(
              padding: EdgeInsets.only(right: 30),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 20, left: 10),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Hello Gabby!',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 30),
                alignment: Alignment.center,
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[100],
                ),
                child: IconButton(
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
                  icon: Image.asset('images/search.png', width: 20),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...List.generate(
                      4,
                      (index) => HomeTabs(
                        tabs: tabMenu,
                        currentIndex: currentIndex,
                        index: index,
                        ontapped: () {
                          setState(() => currentIndex = index);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: tabs[currentIndex],
          ),
        ],
      ),
      bottomSheet: GestureDetector(
        onTap: () {
          showCupertinoModalBottomSheet(
              context: context,
              builder: (context) {
                return NowPlaying();
              });
        },
        child: Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  'Now playing',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
              ),
              Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.music_note),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              provider.playing?.artist ?? 'No media',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 03),
                            Text(
                              // '${provider.playing.fileParent}/${provider.playing.title}',
                              provider.playing?.title ?? 'No media',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Image.asset(
                      'images/play.png',
                      color: Colors.black,
                      width: 30,
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
