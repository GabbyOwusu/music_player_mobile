import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:music_streaming/constants/common.dart';
import 'package:music_streaming/constants/ui_colors.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../../widgets/artwork_widget.dart';

class SongTile extends StatefulWidget {
  final Widget? leading;
  final SongModel? song;
  final Function()? onTap;

  const SongTile({
    Key? key,
    this.onTap,
    this.song,
    this.leading,
  }) : super(key: key);

  @override
  State<SongTile> createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  late Future<Uint8List?> f;

  @override
  void initState() {
    try {
      f = OnAudioQuery().queryArtwork(
        widget.song?.id ?? 0,
        ArtworkType.AUDIO,
        format: ArtworkFormat.JPEG,
        size: 200,
        quality: 100,
      );
    } catch (e) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SongProvider>();
    final playing = p.playing?.title == widget.song?.title &&
        p.playing?.artist == widget.song?.artist;

    return GestureDetector(
      onTap: () async {
        await p.playSong(widget.song!);
        widget.onTap?.call();
      },
      child: Container(
        alignment: Alignment.center,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: widget.leading ??
              Container(
                decoration: BoxDecoration(
                  color: UiColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                height: 50,
                width: 50,
                child: ArtworkWidget(
                  future: f,
                  artworkBorder: BorderRadius.circular(16),
                  nullArtworkWidget: Icon(
                    Icons.music_note,
                    color: UiColors.blue,
                    size: 15,
                  ),
                  artworkWidth: double.infinity,
                  artworkHeight: double.infinity,
                  id: widget.song?.id ?? 0,
                  type: ArtworkType.AUDIO,
                ),
              ),
          title: Text(
            widget.song?.title ?? "Unknown",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: playing ? FontWeight.w600 : FontWeight.normal,
              color: playing ? Colors.blue : Colors.black,
            ),
          ),
          subtitle: Text(
            widget.song?.artist ?? "Unknown",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: playing ? FontWeight.w600 : FontWeight.normal,
              color: playing ? Colors.blue : Colors.grey,
            ),
          ),
          trailing: Text(
            '${parseToMinutesSeconds(int.parse(widget.song?.duration.toString() ?? "0"))}',
            style: TextStyle(
              fontSize: 14,
              color: playing ? Colors.blue : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
