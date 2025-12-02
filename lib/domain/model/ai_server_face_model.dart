import 'banner_model.dart';

class AIServerFaceModel {
  List<BannerModel> banners;
  List<FaceMaterials> materials;

  AIServerFaceModel({required this.banners, required this.materials});

  factory AIServerFaceModel.fromJson(Map<String, dynamic> json) =>
      AIServerFaceModel(
        banners: List<BannerModel>.from(
            (json['banners'] ?? []).map((e) => BannerModel.fromJson(e))),
        materials: List<FaceMaterials>.from(
            (json['materials'] ?? []).map((e) => FaceMaterials.fromJson(e))),
      );
}

class FaceMaterials {
  final int id;
  final int aff;
  final String title;
  final String thumb;
  final int thumbW;
  final int thumbH;
  final int usedCt;
  final String? usedFct;
  final int? isHot;

  FaceMaterials(
      {required this.id,
      required this.aff,
      required this.thumb,
      required this.title,
      required this.usedCt,
      this.usedFct,
      this.isHot,
      required this.thumbW,
      required this.thumbH});

  factory FaceMaterials.fromJson(Map<String, dynamic> json) => FaceMaterials(
      id: json['id'],
      aff: json['aff'],
      thumb: json['thumb'],
      title: json['title'],
      usedCt: json['used_ct'],
      usedFct: json['used_fct'].toString(),
      isHot: json['is_hot'] ?? 0,
      thumbW: json['thumb_w'],
      thumbH: json['thumb_h']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'aff': aff,
        'thumb': thumb,
        'title': title,
        'used_ct': usedCt,
        'used_fct': usedFct,
        'is_hot': isHot,
        'thumb_w': thumbW,
        'thumb_h': thumbH,
      };
}

class VideoFaceModel {
  List<BannerModel> banners;
  List<VideoFaceMaterials> materials;

  VideoFaceModel({required this.banners, required this.materials});

  factory VideoFaceModel.fromJson(Map<String, dynamic> json) => VideoFaceModel(
        banners: List<BannerModel>.from(
            (json['banner'] ?? []).map((e) => BannerModel.fromJson(e))),
        materials: List<VideoFaceMaterials>.from((json['material'] ?? [])
            .map((e) => VideoFaceMaterials.fromJson(e))),
      );
}

class VideoFaceMaterials {
  final int id;
  final int aff;
  final String title;
  final int type;
  final String m3u8;
  final String thumb;
  final int thumbW;
  final int thumbH;
  final int duration;
  final int coins;

  VideoFaceMaterials({
    required this.id,
    required this.aff,
    required this.title,
    required this.type,
    required this.m3u8,
    required this.thumb,
    required this.thumbW,
    required this.thumbH,
    required this.duration,
    required this.coins,
  });

  factory VideoFaceMaterials.fromJson(Map<String, dynamic> json) =>
      VideoFaceMaterials(
          id: json['id'],
          aff: json['aff'],
          title: json['title'],
          type: json['type'],
          m3u8: json['m3u8'],
          thumb: json['thumb'],
          thumbW: json['thumb_w'],
          thumbH: json['thumb_h'],
          duration: json['duration'],
          coins: json['coins']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'aff': aff,
        'title': title,
        'type': type,
        'm3u8': m3u8,
        'thumb': thumb,
        'thumb_w': thumbW,
        'thumb_h': thumbH,
        'duration': duration,
        'coins': coins
      };
}
