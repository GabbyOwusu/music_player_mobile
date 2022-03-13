import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:music_streaming/constants/ui_colors.dart';
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

class _AlbumCardState extends State<AlbumCard> {
  late Future<Uint8List?> f;

  @override
  void initState() {
    f = OnAudioQuery().queryArtwork(
      widget.album?.id ?? 0,
      ArtworkType.ALBUM,
      format: ArtworkFormat.PNG,
      size: 300,
      quality: 100,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: UiColors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ArtworkWidget(
              future: f,
              artworkBorder: BorderRadius.circular(8),
              nullArtworkWidget: Icon(Icons.music_note),
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
