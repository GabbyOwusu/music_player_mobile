import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_session/audio_session.dart';
import 'package:music_streaming/providers/base_provider.dart';
import 'package:music_streaming/services/hive_service.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';

enum Loop { repeat, all }

class SongProvider extends Baseprovider {
  HiveService _hiveService = HiveService();
  OnAudioQuery audioQuery = OnAudioQuery();
  AudioPlayer? audioPlayer;

  List<SongModel> _songList = [];
  bool? _shuffleMode;
  int _currentIndex = 0;
  Uint8List? _nowPlayingArt;
  SongModel? _recent;
  Duration? _duration;
  int _currentDuration = 0;
  List<SongModel> _nowPlayingList = [];
  List<SongModel> _playListSongs = [];
  List<AlbumModel> _albumList = [];
  List<SongModel> _albumSongs = [];
  List<ArtistModel> _artistList = [];
  List<PlaylistModel> _playList = [];
  bool isPlaying = false;
  SongModel? _nowPlaying;
  Loop _currentLoop = Loop.all;

  List<SongModel> get songs => _songList;
  List<AlbumModel> get albums => _albumList;
  List<SongModel> get albumSongs => _albumSongs;
  List<PlaylistModel> get playlist => _playList;
  List<ArtistModel> get artists => _artistList;
  List<SongModel> get playlistSongs => _playListSongs;
  SongModel? get playing => _nowPlaying;
  int get currentDuration => _currentDuration;
  Duration? get duration => _duration;
  SongModel? get recent => _recent;
  Uint8List? get nowPlayingArt => _nowPlayingArt;
  bool? get isRepeat => _currentLoop == Loop.repeat;
  bool? get shuffle => _shuffleMode;
  Loop get loop => _currentLoop;

  Future<void> initQuery() async {
    await requestPermission();
    await getSongs();
    await getAlbums();
    await getArtists();
    await getPlayLists();
    await getRecent();
    await recentArt();
  }

  Future<void> recentArt() async {
    final a = await audioQuery.queryArtwork(
      _recent?.id ?? 0,
      ArtworkType.AUDIO,
      size: 800,
    );
    _nowPlayingArt = a;
    notifyListeners();
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
      final songs = await audioQuery.queryAudiosFrom(
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

  Future<Uint8List?> artWork({
    required int id,
    required ArtworkType type,
  }) async {
    final res = await audioQuery.queryArtwork(
      id,
      ArtworkType.AUDIO,
      format: ArtworkFormat.JPEG,
      size: 600,
      quality: 100,
    );
    return res;
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

  Future<SongModel?> getRecent() async {
    try {
      final res = await _hiveService.getRecent();
      _recent = _songList.where((s) => res == s.id.toString()).toList().first;
      notifyListeners();
      return _recent;
    } catch (e) {
      return null;
    }
  }

  void setLoopMode(Loop loop) {
    _currentLoop = loop;
    notifyListeners();
  }

  Future<void> playSong(SongModel song) async {
    if (audioPlayer?.playing == true) await disposePlayer();
    try {
      audioPlayer = AudioPlayer();
      await _hiveService.setRecent(song.id.toString());
      isPlaying = true;
      _nowPlaying = song;
      _duration = await audioPlayer?.setFilePath(File(song.data).path);
      final a = await audioQuery.queryArtwork(
        song.id,
        ArtworkType.AUDIO,
        size: 800,
      );
      _nowPlayingArt = a;
      audioPlayer?.play();
      getPosition();
      handleInterruptions();
      notifyListeners();
    } catch (e) {}
  }

  Future<void> seek(double position) async {
    await audioPlayer?.seek(
      Duration(seconds: currentDuration + position.toInt()),
    );
  }

  Future<void>? pauseSong() async {
    isPlaying = false;
    notifyListeners();
    return await audioPlayer?.pause();
  }

  Future<void>? resume() async {
    isPlaying = true;
    notifyListeners();
    return await audioPlayer?.play();
  }

  Future<void> stopPlaying() async {
    isPlaying = false;
    notifyListeners();
    return await audioPlayer?.stop();
  }

  void setPlayingList(List<SongModel> list, {bool clear = true}) async {
    if (clear) _nowPlayingList.clear();
    list.forEach((song) => _nowPlayingList.add(song));
    notifyListeners();
  }

  void setShuffle(bool state) async {
    _shuffleMode = state;
    notifyListeners();
  }

  Future<void> disposePlayer() async {
    isPlaying = false;
    try {
      await audioPlayer?.dispose();
    } catch (e) {}
    notifyListeners();
  }

  Future<void> skip({bool next = false, bool prev = false}) async {
    List<SongModel> shuffled = [..._nowPlayingList];
    try {
      _currentIndex = _nowPlayingList.indexWhere(
        (s) => s.id == _nowPlaying?.id,
      );
      await disposePlayer();
      if (isRepeat == true) {
        _nowPlaying = _nowPlaying;
      } else if (_nowPlaying == shuffled.last) {
        _nowPlaying = shuffled.first;
      } else if (_shuffleMode == true) {
        shuffled.shuffle();
        _currentIndex =
            shuffled.indexWhere((song) => song.id == _nowPlaying?.id);
        _nowPlaying =
            next ? shuffled[_currentIndex += 1] : shuffled[_currentIndex -= 1];
      } else {
        _nowPlaying =
            next ? shuffled[_currentIndex += 1] : shuffled[_currentIndex -= 1];
      }
    } on RangeError catch (e) {
      _nowPlaying = _nowPlaying;
      print(e);
    } catch (e) {
      print("Error $e");
    } finally {
      await playSong(_nowPlaying!);
      notifyListeners();
    }
  }

  void getPosition() async {
    audioPlayer?.positionStream.listen(
      (event) async {
        if (event.inSeconds >= (_duration?.inSeconds ?? 0)) {
          await skip(next: true);
          // showNotification();
        }
        // notifyListeners();
      },
    ).onError((error) => print('Error: $error'));
  }

  void handleInterruptions() {
    AudioSession.instance.then((session) async {
      audioPlayer?.playbackEventStream.listen((event) {
        if (audioPlayer?.playing == true) {
          session.setActive(true);
        }
      }).onError((e) => print(e));
      session.interruptionEventStream.listen((event) {
        if (event.begin) {
          switch (event.type) {
            case AudioInterruptionType.duck:
            case AudioInterruptionType.pause:
            case AudioInterruptionType.unknown:
              pauseSong();
              // showNotification();
              break;
            default:
          }
        } else {
          switch (event.type) {
            default:
          }
        }
      });
      session.becomingNoisyEventStream.listen((_) {
        pauseSong();
      });
    });
  }
}
