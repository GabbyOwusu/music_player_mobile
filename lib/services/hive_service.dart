import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveKeys {
  static const BOX = "music_player";
  static const RECENT = "recent_played";
  static const SONGSART = "SONGS_ART";
  static const ALBUMSART = "ALBUMS_ART";
}

class HiveService {
  Box? _box;

  Future<void> assertBox() async {
    if (_box != null && (_box?.isOpen ?? false)) return;
    return await init();
  }

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive..init(dir.path);
    await Hive.openBox(HiveKeys.BOX).then((b) => _box = b);
  }

  Future<void> setRecent(String data) async {
    await assertBox();
    return await _box?.put(HiveKeys.RECENT, data);
  }

  Future<String?> getRecent() async {
    await assertBox();
    final res = await _box?.get(HiveKeys.RECENT);
    return res;
  }
}
