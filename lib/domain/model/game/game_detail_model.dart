import 'package:jygf/domain/model/game/game_model.dart';
import 'package:jygf/domain/model/media_model.dart';

import '../banner_model.dart';

class GameDetailModel {
  GameDetailModel(
      {required this.detail,
      this.banner,
      this.recommend,
      this.prev,
      this.next});
  final GameDetailInfoModel detail;
  final List<BannerModel>? banner;
  final List<GameModel>? recommend;

  GameModel? prev;
  GameModel? next;
  factory GameDetailModel.fromJson(Map<String, dynamic> json) {
    return GameDetailModel(
      detail: GameDetailInfoModel.fromJson(json['detail']),
      banner: json['banner'] == null
          ? null
          : List<BannerModel>.from(
              json['banner'].map((e) => BannerModel.fromJson(e))),
      recommend: json['recommend'] == null
          ? null
          : List<GameModel>.from(
              json['recommend'].map((e) => GameModel.fromJson(e))),
      prev: json['prev'] != null ? GameModel.fromJson(json['prev']) : null,
      next: json['next'] != null ? GameModel.fromJson(json['next']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'detail': detail.toJson(),
        'banner': banner,
        'recommend': recommend,
        'prev': prev?.toJson(),
        'next': next?.toJson(),
      };
}

class GameDetailInfoModel {
  final int? id;
  final String? themeIds;
  final String? cover;
  final String? title;
  final String? tags;
  final String? password;
  final List<GameDetailUrlModel>? downloadUrls;
  final String? intro;
  final String? playIntro;
  final String? desc;
  final int? type;
  final int? coins;
  final int? viewFct;
  int? likeFct = 0;
  int? favoriteFct;
  final int? commentCt;
  final String? createdAt;
  int? isFavorite;
  int? isLike;
  String? payTip;
  final int? payFct;
  final List<MediaModel>? images;
  final List<MediaModel>? videos;

  GameDetailInfoModel({
    this.id,
    this.themeIds,
    this.cover,
    this.title,
    this.tags,
    this.password,
    this.downloadUrls,
    this.intro,
    this.playIntro,
    this.desc,
    this.type,
    this.coins,
    this.viewFct = 0,
    this.likeFct = 0,
    this.favoriteFct,
    this.commentCt,
    this.createdAt,
    this.isFavorite,
    this.isLike,
    this.payTip,
    this.payFct,
    this.images,
    this.videos,
  });

  factory GameDetailInfoModel.fromJson(Map<String, dynamic> json) {
    return GameDetailInfoModel(
      id: json['id'],
      themeIds: json['theme_ids'],
      cover: json['cover'],
      title: json['title'],
      tags: json['tags'],
      password: json['password'],
      downloadUrls: json['download_urls'] == null
          ? null
          : List<GameDetailUrlModel>.from(
              json['download_urls'].map((e) => GameDetailUrlModel.fromJson(e))),
      intro: json['intro'],
      playIntro: json['play_intro'],
      desc: json['desc'],
      type: json['type'],
      coins: json['coins'],
      viewFct: json['view_fct'],
      likeFct: json['like_fct'],
      favoriteFct: json['favorite_fct'],
      commentCt: json['comment_ct'],
      createdAt: json['created_at'],
      isFavorite: json['is_favorite'],
      isLike: json['is_like'],
      payTip: json['pay_tip'],
      payFct: json['pay_fct'],
      images: json['images'] != null
          ? List.from(json['images'].map((e) => MediaModel.fromJson(e)))
          : null,
      videos: json['videos'] != null
          ? List.from(json['videos'].map((e) => MediaModel.fromJson(e)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'theme_ids': themeIds,
      'cover': cover,
      'title': title,
      'tags': tags,
      'password': password,
      'download_urls': downloadUrls,
      'intro': intro,
      'play_intro': playIntro,
      'desc': desc,
      'type': type,
      'coins': coins,
      'view_fct': viewFct,
      'like_fct': likeFct,
      'favorite_fct': favoriteFct,
      'comment_ct': commentCt,
      'created_at': createdAt,
      'is_favorite': isFavorite,
      'is_like': isLike,
      'pay_tip': payTip,
      'pay_fct': payFct,
      'images': images,
      'videos': videos,
    };
  }
}

class GameDetailUrlModel {
  final String? label;
  final String? browserUrl;
  final String? archiveUrl;

  GameDetailUrlModel({this.label, this.browserUrl, this.archiveUrl});

  factory GameDetailUrlModel.fromJson(Map<String, dynamic> json) {
    return GameDetailUrlModel(
      label: json['label'],
      browserUrl: json['browser_url'],
      archiveUrl: json['archive_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'browser_url': browserUrl,
      'archive_url': archiveUrl,
    };
  }
}
