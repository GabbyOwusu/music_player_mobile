import 'package:flutter/material.dart';

import 'package:music_streaming/constants/common.dart';
import 'package:music_streaming/constants/ui_colors.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<SongModel>? songResults = [];
  List<AlbumModel>? albumResults = [];
  String? query;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SongProvider>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Search',
          style: TextStyle(color: Colors.black),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CustomField(
                  onchange: (data) {
                    if (data.isNotEmpty)
                      setState(() {
                        songResults = provider.songs?.where((song) {
                          return song.title.toLowerCase().contains(data) ||
                              song.artist!.toLowerCase().contains(data);
                        }).toList();
                        query = (songResults ?? []).isEmpty ? null : data;
                      });
                    else
                      setState(() {
                        songResults = [];
                        albumResults = [];
                        query = null;
                      });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                alignment: Alignment.center,
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onPressed: () {},
                  icon: Icon(Icons.mic),
                ),
              ),
            ],
          ),
        ),
      ),
      body: (songResults ?? []).isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Type a song title or artist name',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              height: 700,
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                shrinkWrap: true,
                itemCount: songResults?.length ?? 0,
                itemBuilder: (context, index) {
                  final song = songResults?[index];
                  final playing = provider.playing?.title == song?.title &&
                      provider.playing?.artist == song?.artist;
                  return GestureDetector(
                    onTap: () async {
                      await provider.playSong(song!);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          decoration: BoxDecoration(color: UiColors.grey),
                          height: 50,
                          width: 50,
                          child: QueryArtworkWidget(
                            keepOldArtwork: true,
                            artworkBorder: BorderRadius.circular(16),
                            nullArtworkWidget: Icon(Icons.music_note),
                            artworkWidth: double.infinity,
                            artworkHeight: double.infinity,
                            id: song?.id ?? 0,
                            type: ArtworkType.AUDIO,
                          ),
                        ),
                        title: Text(
                          song?.title ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                playing ? FontWeight.w600 : FontWeight.normal,
                            color: playing ? Colors.blue : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          song?.artist ?? "Unknown",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                playing ? FontWeight.w600 : FontWeight.normal,
                            color: playing ? Colors.blue : Colors.grey,
                          ),
                        ),
                        trailing: Text(
                          '${parseToMinutesSeconds(int.parse(song?.duration.toString() ?? "0"))}',
                          style: TextStyle(
                            fontSize: 14,
                            color: playing ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
