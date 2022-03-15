class SongData {
  final String? title;
  final String? artist;
  final int? duration;
  final int? id;

  SongData({
    this.title,
    this.artist,
    this.duration,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "artist": artist,
      "duration": duration,
      "id": id,
    };
  }

  factory SongData.fromJson(Map<String, dynamic> json) {
    return SongData(
      title: json["title"] as String?,
      artist: json["artist"] as String?,
      duration: json["duration"] as int?,
      id: json["_id"] as int?,
    );
  }
}
