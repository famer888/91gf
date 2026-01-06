import 'banner_model.dart';

class LiveWithBannersModel {
  List<LiveModel>? lives;
  List<BannerModel>? banners;
  List<TipModel>? tips;

  LiveWithBannersModel({this.lives, this.banners, this.tips});

  factory LiveWithBannersModel.fromJson(Map<String, dynamic> json) =>
      LiveWithBannersModel(
        lives: List<LiveModel>.from(
            json['lives'].map((e) => LiveModel.fromJson(e))),
        banners: List<BannerModel>.from(
            json['banners'].map((e) => BannerModel.fromJson(e))),
        tips:
            List<TipModel>.from(json['tips'].map((e) => TipModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() =>
      {'lives': lives, 'banners': banners, 'tips': tips};
}

class LiveModel {
  final int? id;
  final String? cover;
  final String? username;
  final int? viewFct;
  final int? commentCt;
        int? favoriteFct;
        List<HlsModel>? hls;
        String? show;
        int? type;
  final int? coins;
        int? isFavorite;
  final String? payTip;
  final String? intro;
  final String? thumb;

  LiveModel({
    this.id,
    this.cover,
    this.username,
    this.viewFct,
    this.favoriteFct,
    this.commentCt,
    this.hls,
    this.show,
    this.type,
    this.coins,
    this.isFavorite,
    this.payTip,
    this.intro,
    this.thumb
  });

  factory LiveModel.fromJson(Map<String, dynamic> json) => LiveModel(
        id: json['id'],
        cover: json['cover'],
        username: json['username'],
        viewFct: json['view_fct'],
        favoriteFct: json['favorite_fct'] ?? 0,
        commentCt: json['comment_ct'],
        hls: json['hls'] != null
            ? List.from(json['hls'].map((e) => HlsModel.fromJson(e)))
            : null,
        show: json['show'],
        type: json['type'],
        coins: json['coins'],
        isFavorite: json['is_favorite'] ?? 0,
        payTip: json['pay_tip'],
        intro: json['intro'],
        thumb: json['thumb'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'cover': cover,
        'username': username,
        'view_fct': viewFct,
        'comment_ct': commentCt,
        'favorite_fct': favoriteFct,
        'hls': hls,
        'show': show,
        'type': type,
        'coins': coins,
        'is_favorite': isFavorite,
        'pay_tip': payTip,
        'intro': intro,
        'thumb': thumb,
  };
}

class HlsModel {
  String label;
  String url;

  HlsModel({required this.label, required this.url});

  factory HlsModel.fromJson(Map<String, dynamic> json) {
    return HlsModel(label: json['label'], url: json['url'] ?? '');
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'url': url,
      };
}

class TipModel {
  final int? id;
  final String? title;
  final String? type;
  final String? config;
  final String? router;
  final String? urlStr;
  final int? redirectType;

  TipModel(
      {this.id,
      this.title,
      this.type,
      this.config,
      this.router,
      this.urlStr,
      this.redirectType});

  factory TipModel.fromJson(Map<String, dynamic> json) => TipModel(
        id: json['id'],
        title: json['title'],
        type: json['type'] is int ? json['type'].toString() : json['type'],
        config: json['config'],
        router: json['router'],
        urlStr: json['url_str'],
        redirectType: json['redirect_type'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'config': config,
        'router': router,
        'url_str': urlStr,
        'redirect_type': redirectType,
      };
}

//热门推荐model数据
class RecLiveWithBannersModel {
  List<ThemesModel>? themes;
  List<BannerModel>? banners;
  List<TipModel>? tips;

  RecLiveWithBannersModel({this.themes, this.banners, this.tips});

  factory RecLiveWithBannersModel.fromJson(Map<String, dynamic> json) =>
      RecLiveWithBannersModel(
        themes: List<ThemesModel>.from(
            json['themes'].map((e) => ThemesModel.fromJson(e))),
        banners: List<BannerModel>.from(
            json['banners'].map((e) => BannerModel.fromJson(e))),
        tips:
        List<TipModel>.from(json['tips'].map((e) => TipModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() =>
      {'themes': themes, 'banners': banners, 'tips': tips};
}

class ThemesModel {
  final int? id;
  final String? name;
  List<LiveModel>? lives;

  ThemesModel({
    this.id,
    this.name,
    this.lives});

  factory ThemesModel.fromJson(Map<String, dynamic> json) =>
      ThemesModel(
        id: json['id'],
        name: json['name'],
        lives: List<LiveModel>.from(
            json['lives'].map((e) => LiveModel.fromJson(e))),

      );

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'lives': lives
      };
}