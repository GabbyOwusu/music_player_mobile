import 'package:flutter/material.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:provider/provider.dart';

class Artists extends StatefulWidget {
  const Artists({Key key}) : super(key: key);

  @override
  _ArtistsState createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> {
  SongProvider get provider {
    return Provider.of<SongProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<SongProvider>().artists;
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 20, right: 30, bottom: 150),
      child: Container(
        height: 500,
        child: GridView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: provider.artists.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 200,
            crossAxisCount: 3,
            crossAxisSpacing: 30,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.music_note),
                  ),
                  SizedBox(height: 10),
                  Text(
                    provider.artists[index].name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Number of songs ${provider.artists[index].numberOfTracks}',
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
    );
  }
}
