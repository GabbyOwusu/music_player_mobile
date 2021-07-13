import 'package:flutter/material.dart';
import 'package:music_streaming/constants/common.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: CustomField(
                onchange: (v) {},
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  ...List.generate(20, (index) {
                    return SongTile(
                      songTitle: 'Bebo',
                      artist: 'Burna boy, Lexus , Joey B ',
                      timestamp: '4:30',
                      onTap: () {},
                    );
                  })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
