import 'package:flutter/material.dart';

class Artists extends StatefulWidget {
  const Artists({Key key}) : super(key: key);

  @override
  _ArtistsState createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 20, right: 30, bottom: 150),
      child: Container(
        height: 500,
        child: GridView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: 200,
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
                    'Artists',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Number of songs',
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
