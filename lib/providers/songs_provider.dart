import 'dart:typed_data';

import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_streaming/providers/base_provider.dart';

class SongProvider extends Baseprovider {
  FlutterAudioQuery audioQuery = FlutterAudioQuery();

  List<SongInfo> _songList = [];
  List<AlbumInfo> _albumList = [];
  List<SongInfo> _albumSongs = [];
  List<ArtistInfo> _artistList = [];
  List<PlaylistInfo> _playList = [];
  List covers = [];
  SongInfo _nowPlaying;

  List<SongInfo> get songs => _songList;
  List<AlbumInfo> get albums => _albumList;
  List<SongInfo> get albumSongs => _albumSongs;
  List<PlaylistInfo> get playlist => _playList;
  List<ArtistInfo> get artists => _artistList;
  SongInfo get playing => _nowPlaying;

  void addNowplaying(SongInfo song) {
    _nowPlaying = song;
    notifyListeners();
  }

  Future<void> initQuery() async {
    getSongs();
    getAlbums();
    getArtists();
    getPlayLists();
  }

  Future<void> getSongs() async {
    try {
      List<SongInfo> songList = await audioQuery.getSongs();
      _songList = songList;
      print(_songList);
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

  Future<Uint8List> getArtWork(ResourceType type, String id) async {
    Uint8List artwork = await audioQuery.getArtwork(type: type, id: id);
    print('Here is the artwork......$artwork');
    return artwork;
  }

  Future getArtists() async {
    try {
      List<ArtistInfo> artists = await audioQuery.getArtists();
      _artistList = artists;
      print(_artistList);
    } catch (e) {
      print('Failed to get Artists >>>>>>>>>>> $e');
    }
  }

  Future getPlayLists() async {
    try {
      List<PlaylistInfo> playlists = await audioQuery.getPlaylists();
      _playList = playlists;
      print('Playlists $_playList');
    } catch (e) {}
  }
}
