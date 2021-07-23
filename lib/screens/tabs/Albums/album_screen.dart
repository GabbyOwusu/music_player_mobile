import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_streaming/constants/common.dart';
import 'package:music_streaming/providers/songs_provider.dart';
import 'package:provider/provider.dart';

class AlbumScreen extends StatefulWidget {
  final ImageProvider<Object> coverArt;
  final AlbumInfo info;
  final SongProvider provider;

  final int index;
  const AlbumScreen({
    Key key,
    @required this.index,
    @required this.provider,
    @required this.coverArt,
    @required this.info,
  }) : super(key: key);

  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  SongProvider get provider {
    return Provider.of<SongProvider>(context);
  }

  @override
  void didChangeDependencies() {
    context
        .read<SongProvider>()
        .getalbumSongs(provider.albums[widget.index].id)
        .then((value) {
      setState(() {});
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                elevation: 0,
                floating: true,
                backgroundColor: Colors.transparent,
                expandedHeight: 280,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                        image: widget.coverArt,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 30,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.info.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${widget.info.artist} - ${widget.info.numberOfSongs}  songs',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                          Spacer(),
                          Container(
                            height: 40,
                            width: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    ...List.generate(
                      widget.provider.albumSongs.length,
                      (index) => Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.only(bottom: 10, left: 10, right: 10),
                        child: ListTile(
                          leading: Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.music_note),
                          ),
                          title: Text(
                            widget.provider.albumSongs[index].title,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            widget.provider.albumSongs[index].artist,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            '${parseToMinutesSeconds(
                              int.parse(
                                  widget.provider.albumSongs[index].duration),
                            )}',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
