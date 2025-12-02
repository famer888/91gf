import '../enum.dart';

class MediaModel {
  final int? id;
  String mediaUrl;
  final String cover;
  final int thumbWidth;
  final int thumbHeight;
  final int? pid;
  final String? aff;
  final MyMediaType type;
  final String? createdAt;
  final int? status;
  final int? duration;
  final String? updatedAt;
  final int? relateType;
  final int? aiId;
  int? unlockCoins;

  MediaModel(
      {this.id,
      required this.mediaUrl,
      required this.cover,
      required this.thumbWidth,
      required this.thumbHeight,
      this.pid,
      this.aff,
      required this.type,
      this.createdAt,
      this.status,
      this.duration,
      this.updatedAt,
      this.relateType,
      this.aiId,
      this.unlockCoins});

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
        id: json['id'],
        mediaUrl: json['media_url'] ?? '',
        cover: json['cover'] ?? '',
        thumbWidth: json['thumb_width'] ?? 0,
        thumbHeight: json['thumb_height'] ?? 0,
        pid: json['pid'],
        aff: json['aff'].toString(),
        type: switch (json['type']) {
          2 => MyMediaType.video,
          _ => MyMediaType.image
        },
        createdAt: json['created_at'],
        status: json['status'],
        duration: json['duration'],
        updatedAt: json['updated_at'],
        relateType: json['relate_type'],
        aiId: json['ai_id'],
        unlockCoins: json['unlock_coins']);
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'media_url': mediaUrl,
        'cover': cover,
        'thumb_width': thumbWidth,
        'thumb_height': thumbHeight,
        'pid': pid,
        'aff': int.tryParse(aff ?? '0'),
        'type': type,
        'created_at': createdAt,
        'status': status,
        'duration': duration,
        'updated_at': updatedAt,
        'relate_type': relateType,
        'ai_id': aiId,
        'unlock_coins': unlockCoins
      };
}
