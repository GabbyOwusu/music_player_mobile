import 'dart:typed_data';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_streaming/providers/base_provider.dart';
import 'package:music_streaming/services/device_info_service.dart';

class SongProvider extends Baseprovider {
  FlutterAudioQuery audioQuery = FlutterAudioQuery();
  DeviceInfoService infoService = DeviceInfoService();
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();

  List<SongInfo> _songList = [];
  int currentDuration;
  List<SongInfo> _playListSongs = [];
  List<AlbumInfo> _albumList = [];
  List<SongInfo> _albumSongs = [];
  List<ArtistInfo> _artistList = [];
  List<PlaylistInfo> _playList = [];
  List covers = [];
  bool isPlaying = false;
  int _version;
  SongInfo _nowPlaying;

  List<SongInfo> get songs => _songList;
  List<AlbumInfo> get albums => _albumList;
  List<SongInfo> get albumSongs => _albumSongs;
  List<PlaylistInfo> get playlist => _playList;
  List<ArtistInfo> get artists => _artistList;
  List<SongInfo> get playlistSongs => _playListSongs;
  SongInfo get playing => _nowPlaying;
  int get androidversion => _version;

  void playSong(SongInfo song) async {
    isPlaying = true;
    _nowPlaying = song;
    await audioPlayer.play(song.filePath).then((value) {
      print('Song duration hereeeeeee $value');
    });
    notifyListeners();
  }

  void pauseSong() async {
    isPlaying = false;
    await audioPlayer.pause();
    notifyListeners();
  }

  void resume() async {
    isPlaying = true;
    await audioPlayer.resume();
  }

  void stopPlaying() async {
    await audioPlayer.stop();
    notifyListeners();
  }

  Future<void> initQuery() async {
    getSongs();
    getAlbums();
    getArtists();
    getPlayLists();
  }

  Future artWork(ResourceType type, String id) async {
    try {
      audioQuery.getArtwork(type: type, id: id);
    } catch (e) {
      print('Not getting art $e');
    }
  }

  Future<void> getSongs() async {
    try {
      List<SongInfo> songList = await audioQuery.getSongs();
      _songList = songList;
      infoService.getDeviceInfo().then((value) {
        _version = value;
      });
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

  Future<void> getPlaylistSongs(PlaylistInfo playlist) async {
    try {
      List<SongInfo> songs =
          await audioQuery.getSongsFromPlaylist(playlist: playlist);
      _playListSongs = songs;
      print('Playlist songs $_playListSongs');
    } catch (e) {
      print('Couldnt get playlist songs because $e');
    }
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
