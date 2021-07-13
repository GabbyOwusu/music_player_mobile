class SongData {
  final String title;
  final String artist;
  final String timestamp;
  final String coverArt;

  SongData(
    this.title,
    this.artist,
    this.timestamp,
    this.coverArt,
  );
}

class AlbumData {
  String title;
  List<SongData> songList;

  AlbumData(
    this.title,
    this.songList,
  );
}
