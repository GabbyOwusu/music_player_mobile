import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:music_streaming/constants/common.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/screens/lyrics_screen.dart';
import 'package:provider/provider.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({Key? key}) : super(key: key);

  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  double value = 30;
  SongProvider get provider {
    return Provider.of<SongProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBAr(
        context,
        'Now Playing',
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
        ),
        SizedBox(),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Container(
                height: 280,
                padding: EdgeInsets.only(bottom: 20, left: 20),
                alignment: Alignment.bottomLeft,
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GestureDetector(
                  onTap: () {
                    showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) => Lyrics(),
                    );
                  },
                  child: Text('Lyrics'),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Forest Hills Drive - Jcole',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Love Yours',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('images/skip_previous.png', width: 20),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 50,
                    ),
                  ),
                  Image.asset('images/skip_next.png', width: 20),
                ],
              ),
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.shuffle_rounded),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) => AlbumSongs(p: provider),
                    );
                  },
                  icon: Icon(Icons.menu),
                ),
              ],
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 1,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 8,
              ),
            ),
            child: Expanded(
              child: Slider(
                activeColor: Colors.black,
                inactiveColor: Colors.grey[300],
                value: value,
                min: 0.0,
                max: 100,
                onChanged: (v) {
                  setState(() => value = v);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Text('00:05'),
                Spacer(),
                Text('04:05'),
              ],
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class AlbumSongs extends StatelessWidget {
  const AlbumSongs({Key? key, required this.p}) : super(key: key);

  final SongProvider p;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 30,
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          controller: ModalScrollController.of(context),
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Forest Hills Drive - 13 songs',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Love Yours',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: Icon(
                        CupertinoIcons.heart_fill,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              ...List.generate(20, (index) {
                return SongTile(
                  index: index,
                  songInfo: p.songs[index],
                  onTap: () {},
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
