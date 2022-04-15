import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:music_streaming/theme/theme.dart';
import 'package:music_streaming/theme/ui_colors.dart';
import 'package:music_streaming/widgets/coverArt.dart';
import 'package:music_streaming/widgets/forem_input.dart';
import 'package:music_streaming/widgets/large_button.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class CreatePlaylist extends StatefulWidget {
  final int? playlistId;
  const CreatePlaylist({Key? key, this.playlistId}) : super(key: key);

  @override
  State<CreatePlaylist> createState() => _CreatePlaylistState();
}

class _CreatePlaylistState extends State<CreatePlaylist> {
  List<SongModel> songs = [];
  List<SongModel> _selectedSongs = [];
  final controller = TextEditingController();

  bool get editing => widget.playlistId == null;

  Future<void> _createPlaylist() async {
    if (_selectedSongs.isEmpty) return;
    final p = context.read<SongProvider>();
    await p.createPlaylist(controller.text);
  }

  void _addSongs() async {
    if (_selectedSongs.isEmpty) return;
    final p = context.read<SongProvider>();
    p.addToPlaylist(songs, widget.playlistId!);
  }

  void submit() async {
    if (controller.text.isEmpty) return;
    if (editing) {
      await _createPlaylist();
    } else {
      _addSongs();
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    final p = context.read<SongProvider>();
    songs = p.songs;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SongProvider>();

    final _views = [
      SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create a playlist',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'What would you call this playlist',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 80),
            FormInput(
              title: Text("Playlist name"),
              boldTitle: false,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(hintText: "eg.My worship"),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create a playlist',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Add songs to ${controller.text}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.search_favorite),
                hintText: "Search",
              ),
              onChanged: (v) {
                setState(() {
                  if (v.isNotEmpty)
                    songs = songs
                        .where((s) =>
                            s.title.toLowerCase().contains(v) ||
                            (s.artist ?? "").toLowerCase().contains(v))
                        .toList();
                  if (v.isEmpty) songs = provider.songs;
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 2),
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  bool selected = _selectedSongs.contains(song);
                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        if (selected) _selectedSongs.remove(song);
                        if (!selected) _selectedSongs.add(song);
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          decoration: BoxDecoration(
                            color: UiColors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          height: 50,
                          width: 50,
                          child: QueryArtworkWidget(
                            keepOldArtwork: true,
                            artworkBorder: BorderRadius.circular(16),
                            nullArtworkWidget: CoverArt(art: null),
                            artworkWidth: double.infinity,
                            artworkHeight: double.infinity,
                            id: song.id,
                            type: ArtworkType.AUDIO,
                          ),
                        ),
                        title: Text(
                          song.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          song.artist ?? "Unknown",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: selected
                            ? Radio(
                                value: 1,
                                groupValue: 1,
                                onChanged: (v) {
                                  setState(() {
                                    _selectedSongs.remove(song);
                                  });
                                },
                              )
                            : Radio(
                                value: 1,
                                groupValue: 0,
                                onChanged: (v) {
                                  setState(() {
                                    _selectedSongs.add(song);
                                  });
                                },
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(color: Colors.black),
        elevation: 0,
      ),
      body: editing ? _views[0] : _views[1],
      bottomNavigationBar: LargeButton(
        margin: ContentPadding,
        label: editing ? "Create playlist" : "Save",
        onPressed: () => submit(),
      ),
    );
  }
}
