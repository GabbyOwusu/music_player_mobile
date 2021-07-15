import 'package:flutter/material.dart';
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
    return provider.albumSongs.length > 0
        ? Padding(
            padding: const EdgeInsets.only(
              left: 30,
              top: 30,
              right: 30,
              bottom: 10,
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
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AlbumScreen(
                              index: index,
                              provider: provider,
                              info: provider.albums[index],
                              coverArt: Icon(Icons.music_note),
                            );
                          },
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.music_note),
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
