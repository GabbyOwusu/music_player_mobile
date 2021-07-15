import 'package:music_streaming/providers/base_provider.dart';
import 'package:music_streaming/services/file_service.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongProvider extends Baseprovider {
  OnAudioQuery audioQuery = OnAudioQuery();

  List<SongModel> _songList = [];

  List<SongModel> get songs => _songList;

  Future<void> getSongs() async {
    try {
      List<SongModel> songList = await audioQuery.querySongs(
        SongSortType.DATA_ADDED,
        OrderType.ASC_OR_SMALLER,
        UriType.EXTERNAL,
        true,
      );
      _songList = songList;

      print(
        'There are ${_songList.length} number of songs on the device.\nThe list of all songs on device ......$_songList',
      );
    } catch (e) {
      print('Error happened becuase $e');
    }
    notifyListeners();
  }
}
