import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:music_streaming/constants/ui_colors.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/widgets/artwork_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Artists extends StatefulWidget {
  const Artists({Key? key}) : super(key: key);

  @override
  _ArtistsState createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SongProvider>();
    final artists = provider.artists ?? [];
    return Container(
      height: 500,
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: artists.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 200,
          crossAxisCount: 3,
          crossAxisSpacing: 30,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          return ArtistCard(artists: artists[index]);
        },
      ),
    );
  }
}

class ArtistCard extends StatefulWidget {
  const ArtistCard({
    Key? key,
    required this.artists,
  }) : super(key: key);

  final ArtistModel artists;

  @override
  State<ArtistCard> createState() => _ArtistCardState();
}

class _ArtistCardState extends State<ArtistCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Future<Uint8List?> f;

  @override
  void initState() {
    f = OnAudioQuery().queryArtwork(
      widget.artists.id,
      ArtworkType.ARTIST,
      format: ArtworkFormat.PNG,
      size: 300,
      quality: 100,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 120,
            decoration: BoxDecoration(
              color: UiColors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ArtworkWidget(
              future: f,
              artworkBorder: BorderRadius.circular(8),
              nullArtworkWidget: Icon(
                Icons.music_note,
                size: 18,
                color: UiColors.blue,
              ),
              artworkWidth: double.infinity,
              artworkHeight: double.infinity,
              id: widget.artists.id,
              type: ArtworkType.ARTIST,
            ),
          ),
          SizedBox(height: 10),
          Text(
            widget.artists.artist,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '${widget.artists.numberOfAlbums} Albums | ${widget.artists.numberOfTracks} Songs',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
