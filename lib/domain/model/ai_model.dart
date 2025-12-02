import 'package:jygf/domain/model/banner_model.dart';

class AIWithBannersModel {
  List<BannerModel>? banners;
  List<AIModel>? materials;
  AIWithBannersModel({this.materials, this.banners});

  factory AIWithBannersModel.fromJson(Map<String, dynamic> json) =>
      AIWithBannersModel(
        materials: List<AIModel>.from(
            json['materials'].map((e) => AIModel.fromJson(e))),
        banners: List<BannerModel>.from(
            json['banners'].map((e) => BannerModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {'materials': materials, 'banners': banners};
}

class AIModel {
  final int? id;
  final String? thumb;
  final int? aff;
  final String? title;
  final int? thumbW;
  final int? thumbH;
  final String? stripThumb;
  final int? stripThumbW;
  final int? stripThumbH;
  final String? faceThumb;
  final int? faceThumbW;
  final int? faceThumbH;
  final int? status;
  final String? reason;
  final String? createdAt;
  final String? faceM3u8;

  AIModel({
    this.id,
    this.thumb,
    this.aff,
    this.title,
    this.thumbW,
    this.thumbH,
    this.stripThumb,
    this.stripThumbW,
    this.stripThumbH,
    this.faceThumb,
    this.faceThumbW,
    this.faceThumbH,
    this.status,
    this.reason,
    this.createdAt,
    this.faceM3u8,
  });

  factory AIModel.fromJson(Map<String, dynamic> json) => AIModel(
        id: json['id'],
        thumb: json['thumb'],
        aff: json['aff'],
        title: json['title'],
        thumbW: json['thumb_w'],
        thumbH: json['thumb_h'],
        stripThumb: json['strip_thumb'],
        stripThumbW: json['strip_thumb_w'],
        stripThumbH: json['strip_thumb_h'],
        faceThumb: json['face_thumb'],
        faceThumbW: json['face_thumb_w'],
        faceThumbH: json['face_thumb_h'],
        status: json['status'],
        reason: json['reason'],
        createdAt: json['created_at'],
        faceM3u8: json['face_m3u8'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'thumb': thumb,
        'aff': aff,
        'title': title,
        'thumb_w': thumbW,
        'thumb_h': thumbH,
        'strip_thumb': stripThumb,
        'strip_thumb_w': stripThumbW,
        'strip_thumb_h': stripThumbH,
        'face_thumb': faceThumb,
        'face_thumb_w': faceThumbW,
        'face_thumb_h': faceThumbH,
        'status': status,
        'reason': reason,
        'created_at': createdAt,
      };
}
