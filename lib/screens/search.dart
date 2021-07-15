import 'package:flutter/material.dart';
import 'package:music_streaming/constants/common.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  SongProvider get provider {
    return Provider.of<SongProvider>(context);
  }

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
                  ...List.generate(
                    provider.songs.length,
                    (index) {
                      return SongTile(
                        index: index,
                        songInfo: provider.songs[index],
                        onTap: () {},
                      );
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
