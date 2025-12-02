class AIMagicRecordModel {
  final int id;
  final int aff;
  final String thumb;
  final int thumbW;
  final int thumbH;
  final String video;
  final int status;
  final String reason;
  final String createdAt;
  final String cover;
  final int coverWidth;
  final int coverHeight;
  final int duration;

  AIMagicRecordModel({
    required this.id,
    required this.aff,
    required this.thumb,
    required this.thumbW,
    required this.thumbH,
    required this.video,
    required this.status,
    required this.reason,
    required this.createdAt,
    required this.cover,
    required this.coverWidth,
    required this.coverHeight,
    required this.duration,
  });

  factory AIMagicRecordModel.fromJson(Map<String, dynamic> json) {
    return AIMagicRecordModel(
      id: json["id"],
      aff: json["aff"],
      thumb: json["thumb"],
      thumbW: json["thumb_w"],
      thumbH: json["thumb_h"],
      video: json["video"],
      status: json["status"],
      reason: json["reason"],
      createdAt: json["created_at"],
      cover: json["cover"],
      coverWidth: json["cover_width"],
      coverHeight: json["cover_height"],
      duration: json["duration"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "aff": aff,
      "thumb": thumb,
      "thumb_w": thumbW,
      "thumb_h": thumbH,
      "video": video,
      "status": status,
      "reason": reason,
      "created_at": createdAt,
      "cover": cover,
      "cover_width": coverWidth,
      "cover_height": coverHeight,
      "duration": duration,
    };
  }
}
