import 'dart:io';
import 'package:music_streaming/providers/base_provider.dart';
import 'package:music_streaming/services/hice_service.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class SongProvider extends Baseprovider {
  HiveService _hiveService = HiveService();
  OnAudioQuery audioQuery = OnAudioQuery();
  AudioPlayer audioPlayer = AudioPlayer();

  List<SongModel>? _songList = [];
  SongModel? _recent;
  Duration? _duration;
  int _currentDuration = 0;
  List<SongModel>? _playListSongs = [];
  List<AlbumModel>? _albumList = [];
  List<SongModel>? _albumSongs = [];
  List<ArtistModel>? _artistList = [];
  List<PlaylistModel>? _playList = [];
  bool isPlaying = false;
  String? _timePlayed;
  int? _version;
  SongModel? _nowPlaying;

  List<SongModel>? get songs => _songList;
  List<AlbumModel>? get albums => _albumList;
  List<SongModel>? get albumSongs => _albumSongs;
  List<PlaylistModel>? get playlist => _playList;
  List<ArtistModel>? get artists => _artistList;
  List<SongModel>? get playlistSongs => _playListSongs;
  SongModel? get playing => _nowPlaying;
  int? get androidversion => _version;
  String? get timePlayed => _timePlayed;
  int get currentDuration => _currentDuration;
  Duration? get duration => _duration;
  SongModel? get recent => _recent;

  Future<void> initQuery() async {
    await requestPermission();
    await getSongs();
    await getRecent();
    getAlbums();
    getArtists();
    getPlayLists();
  }

  Future<List<SongModel>?> getSongs() async {
    try {
      List<SongModel> songList = await audioQuery.querySongs();
      _songList = songList;
      notifyListeners();
      return songList;
    } catch (e) {
      return null;
    }
  }

  Future<List<AlbumModel>?> getAlbums() async {
    try {
      List<AlbumModel> albumList = await audioQuery.queryAlbums();
      _albumList = albumList;
      notifyListeners();
      return _albumList;
    } catch (e) {
      return null;
    }
  }

  Future<void> requestPermission() async {
    try {
      final status = await audioQuery.permissionsStatus();
      if (!status) {
        await audioQuery.permissionsRequest();
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<SongModel>?> getPlaylistSongs(String id) async {
    try {
      List<SongModel> songs = await audioQuery.queryAudiosFrom(
        AudiosFromType.PLAYLIST,
        id,
      );
      _playListSongs = songs;
      notifyListeners();
      return _playListSongs;
    } catch (e) {
      return null;
    }
  }

  Future<List<SongModel>?> getalbumSongs({
    required AudiosFromType type,
    required String id,
  }) async {
    try {
      List<SongModel> songs = await audioQuery.queryAudiosFrom(type, id);
      _albumSongs = songs;
      notifyListeners();
      return _albumSongs;
    } catch (e) {
      return null;
    }
  }

  Future<List<ArtistModel>?> getArtists() async {
    try {
      List<ArtistModel> artists = await audioQuery.queryArtists();
      _artistList = artists;
      notifyListeners();
      return artists;
    } catch (e) {
      return null;
    }
  }

  Future<List<PlaylistModel>?> getPlayLists() async {
    try {
      List<PlaylistModel> playlists = await audioQuery.queryPlaylists();
      _playList = playlists;
      return playlists;
    } catch (e) {
      return null;
    }
  }

  Future<void> setRecent(SongModel song) async {
    try {
      await _hiveService.setRecent(song.id.toString());
    } catch (e) {}
  }

  Future<SongModel?> getRecent() async {
    try {
      final res = await _hiveService.getRecent();
      _recent = _songList?.where((s) => res == s.id.toString()).toList().first;
      notifyListeners();
      return _recent;
    } catch (e) {
      return null;
    }
  }

  Future<void> playSong(SongModel song) async {
    await setRecent(song);
    await loopMode();
    if (song.title == _nowPlaying?.title && song.artist == _nowPlaying?.artist)
      return;
    isPlaying = true;
    _nowPlaying = song;
    _duration = await audioPlayer.setFilePath(File(song.data).path);
    getPosition();
    audioPlayer.play();
    notifyListeners();
  }

  Future<void> seek(double position) async {
    await audioPlayer.seek(
      Duration(seconds: currentDuration + position.toInt()),
    );
  }

  Future<void> loopMode() async {
    await audioPlayer.setLoopMode(LoopMode.one);
  }

  Future<void>? pauseSong() async {
    isPlaying = false;
    notifyListeners();
    return await audioPlayer.pause();
  }

  Future<void>? resume() async {
    isPlaying = true;
    notifyListeners();
    return await audioPlayer.play();
  }

  Future<void> stopPlaying() async {
    isPlaying = false;
    notifyListeners();
    return await audioPlayer.stop();
  }

  void getPosition() async {
    audioPlayer.positionStream.listen(
      (event) async {
        _currentDuration = event.inSeconds;
        _timePlayed = '${event.inMinutes}:${event.inSeconds % 60}';
        notifyListeners();
      },
    )..onError((error) => print('Error: $error'));
    // ..onDone(() {
    //   isPlaying = false;
    //   _currentDuration = 0;
    //   _timePlayed = '00:00';
    //   notifyListeners();
    // });
  }
}
