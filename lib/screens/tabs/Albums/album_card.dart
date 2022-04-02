import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_streaming/constants/ui_colors.dart';
import 'package:music_streaming/screens/tabs/Albums/album_details.dart';
import 'package:music_streaming/widgets/artwork_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumCard extends StatefulWidget {
  const AlbumCard({
    Key? key,
    this.album,
    this.onTap,
  }) : super(key: key);

  final AlbumModel? album;
  final VoidCallback? onTap;

  @override
  State<AlbumCard> createState() => _AlbumCardState();
}

class _AlbumCardState extends State<AlbumCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  Uint8List? art;
  Future<Uint8List?>? f;

  void getArt() async {
    f = OnAudioQuery().queryArtwork(
      widget.album?.id ?? 0,
      ArtworkType.ALBUM,
      format: ArtworkFormat.PNG,
      size: 500,
      quality: 100,
    );
    if (mounted) art = await f;
  }

  @override
  void initState() {
    super.initState();
    getArt();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: ((context) {
              return AlbumDetails(
                art: art,
                album: widget.album!,
              );
            }),
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
              color: UiColors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ArtworkWidget(
              future: f!,
              artworkBorder: BorderRadius.circular(16),
              artworkWidth: double.infinity,
              artworkHeight: double.infinity,
              id: widget.album?.id ?? 0,
              type: ArtworkType.ALBUM,
            ),
          ),
          SizedBox(height: 5),
          Text(
            widget.album?.album ?? "Unknown",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Text(
            widget.album?.artist ?? "Unknown",
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
