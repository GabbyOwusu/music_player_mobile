import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_streaming/providers/base_provider.dart';

class SongProvider extends Baseprovider {
  FlutterAudioQuery audioQuery = FlutterAudioQuery();

  List<SongInfo> _songList = [];
  List<AlbumInfo> _albumList = [];
  List<SongInfo> _albumSongs = [];

  SongInfo _nowPlaying;

  List<SongInfo> get songs => _songList;
  List<AlbumInfo> get albums => _albumList;
  List<SongInfo> get albumSongs => _albumSongs;
  SongInfo get playing => _nowPlaying;

  void addNowplaying(SongInfo song) {
    _nowPlaying = song;
    notifyListeners();
  }

  Future<void> getSongs() async {
    try {
      List<SongInfo> songList = await audioQuery.getSongs();
      _songList = songList;
    } catch (e) {
      print('Error happened becuase $e');
    }
    notifyListeners();
  }

  Future<void> getAlbums() async {
    try {
      List<AlbumInfo> albumList = await audioQuery.getAlbums();
      _albumList = albumList;
      print('Albums on device ${_albumList.length} \n$_albumList');
    } catch (e) {
      print('Error happened becuase $e');
    }
    notifyListeners();
  }

  Future getalbumSongs(String id) async {
    try {
      List<SongInfo> songs = await audioQuery.getSongsFromAlbum(
        albumId: id,
      );
      _albumSongs = songs;
      print(_albumSongs);
    } catch (e) {
      print('Error getting album songs becuase ....$e');
    }
  }
}
