import 'package:flutter/material.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/screens/tabs/Albums/album_card.dart';
import 'package:music_streaming/screens/tabs/Albums/album_details.dart';
import 'package:provider/provider.dart';

class Albums extends StatefulWidget {
  const Albums({Key? key}) : super(key: key);

  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = context.watch<SongProvider>();
    final albums = provider.albums ?? [];

    return Container(
      height: 500,
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: albums.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 250,
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          return AlbumCard(
            album: albums[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AlbumDetails(album: albums[index]);
                  },
                ),
              );
            },
          );
        },
      ),
    );
    // : Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Icon(Icons.music_note_rounded),
    //         SizedBox(height: 5),
    //         Text('There are no albums on your device'),
    //       ],
    //     ),
    //   );
  }
}
