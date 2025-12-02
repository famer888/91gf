import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/live_model.dart';

class VoiceWithBannersModel {
  List<VoiceModel>? voices;
  List<BannerModel>? banners;
  List<TipModel>? tips;

  VoiceWithBannersModel({this.voices, this.banners, this.tips});

  factory VoiceWithBannersModel.fromJson(Map<String, dynamic> json) =>
      VoiceWithBannersModel(
        voices: List<VoiceModel>.from(
            json['voices'].map((e) => VoiceModel.fromJson(e))),
        banners: List<BannerModel>.from(
            json['banners'].map((e) => BannerModel.fromJson(e))),
        tips:
        List<TipModel>.from(json['tips'].map((e) => TipModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() =>
      {'voices': voices, 'banners': banners, 'tips': tips};
}

class VoiceModel {
  final int? id;
  final String? title;
  final String? smallCover;
  final String? bigCover;
  final int? viewFct;
  int? favoriteFct;
  int? isFavorite;
  int? playFct;
  int? type;
  int? coins;
  int? duration;
  String? voice;
  final String? payTip;
  final String? createdAt;

  VoiceModel({
    this.id,
    this.title,
    this.smallCover,
    this.bigCover,
    this.viewFct,
    this.favoriteFct,
    this.isFavorite,
    this.playFct,
    this.type,
    this.coins,
    this.duration,
    this.voice,
    this.payTip,
    this.createdAt,
  });

  factory VoiceModel.fromJson(Map<String, dynamic> json) => VoiceModel(
    id: json['id'],
    title: json['title'],
    smallCover: json['small_cover'],
    bigCover: json['big_cover'],
    viewFct: json['view_fct'],
    favoriteFct: json['favorite_fct'],
    isFavorite: json['is_favorite'],
    playFct: json['play_fct'],
    type: json['type'],
    coins: json['coins'],
    duration: json['duration'],
    voice: json['voice'],
    payTip: json['pay_tip'],
    createdAt: json['created_at'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'small_cover': smallCover,
    'big_cover': bigCover,
    'view_fct': viewFct,
    'favorite_fct': favoriteFct,
    'is_favorite': isFavorite,
    'play_fct': playFct,
    'type': type,
    'coins': coins,
    'duration': duration,
    'voice': voice,
    'pay_tip': payTip,
    'created_at': createdAt,
  };
}