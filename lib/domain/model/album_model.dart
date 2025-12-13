import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/part_nav_model.dart';

//除了推荐以外的分类数据model
class AlbumWithBannersModel {
  List<AlbumItemsModel>? albums;
  List<BannerModel>? banner;
  List<TipModel>? tips;

  AlbumWithBannersModel({this.albums, this.banner, this.tips});

  factory AlbumWithBannersModel.fromJson(Map<String, dynamic> json) =>
      AlbumWithBannersModel(
        albums: List<AlbumItemsModel>.from(
            json['albums'].map((e) => AlbumItemsModel.fromJson(e))),
        banner: json['banner'] != null
            ? List<BannerModel>.from(
            json['banner'].map((e) => BannerModel.fromJson(e)))
            : [],
        tips: json['tips'] != null
            ? List<TipModel>.from(json['tips'].map((e) => TipModel.fromJson(e)))
            : [],
      );

  Map<String, dynamic> toJson() =>
      {'albums': albums, 'banner': banner, 'tips': tips};
}

class AlbumItemsModel {
  final int? id;
  final String? themeIds;
  final String? cover;
  final String? title;
  final String? tag;
  final int? coins;
  final int? type; //
  final int? viewCt;
  final int? viewFct;
  final int? photoCt;

  AlbumItemsModel({
    this.id,
    this.themeIds,
    this.title,
    this.cover,
    this.tag,
    this.type,
    this.photoCt,
    this.viewCt,
    this.viewFct,
    this.coins,
  });

  factory AlbumItemsModel.fromJson(Map<String, dynamic> json) =>
      AlbumItemsModel(
        id: json['id'],
        themeIds: json['theme_ids'],
        title: json['title'],
        cover: json['cover'],
        tag: json['tag'],
        type: json['type'],
        photoCt: json['photo_ct'],
        viewFct: json['view_fct'],
        viewCt: json['view_ct'],
        coins: json['coins'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'theme_ids': themeIds,
    'title': title,
    'cover': cover,
    'tag': tag,
    'type': type,
    'photo_ct': photoCt,
    'view_fct': viewFct,
    'view_ct': viewCt,
    'coins': coins,
  };
}

//推荐model数据
class RecAlbumWithBannersModel {
  List<RecAlbumModel>? albums;
  List<BannerModel>? banner;
  List<TipModel>? tips;
  List<PartModel>? nav;

  RecAlbumWithBannersModel(
      {this.albums, this.banner, this.nav, this.tips});

  factory RecAlbumWithBannersModel.fromJson(Map<String, dynamic> json) =>
      RecAlbumWithBannersModel(
        albums: json['albums'] == null
            ? null
            : List<RecAlbumModel>.from(
            json['albums'].map((e) => RecAlbumModel.fromJson(e))),
        banner: json['banner'] == null
            ? null
            : List<BannerModel>.from(
            json['banner'].map((e) => BannerModel.fromJson(e))),
        nav:
        List<PartModel>.from(json['nav'].map((e) => PartModel.fromJson(e))),
        tips: json['tips'] == null
            ? null
            : List<TipModel>.from(json['tips'].map((e) => TipModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {
    'albums': albums?.map((e) => e.toJson()).toList(),
    'banner': banner?.map((e) => e.toJson()).toList(),
    'nav': nav?.map((e) => e.toJson()).toList(),
    'tips': tips?.map((e) => e.toJson()).toList(),
  };
}

class RecAlbumModel {
  final int? id;
  final String? title;
  final String? value;
  List<AlbumItemsModel>? albums;

  //广告数据
  final String? description;
  final String? imgUrl;
  final String? urlConfig;
  final int? type;
  final String? router;
  final String? urlStr;
  final String? linkUrl;
  final String? url;
  final String? resourceUrl;
  final int? redirectType;
  final int? reportId;
  final int? reportType;

  RecAlbumModel({
    this.id,
    this.title,
    this.value,
    this.albums,
    this.description,
    this.imgUrl,
    this.urlConfig,
    this.type,
    this.router,
    this.urlStr,
    this.linkUrl,
    this.resourceUrl,
    this.url,
    this.redirectType,
    this.reportId,
    this.reportType,
  });

  factory RecAlbumModel.fromJson(Map<String, dynamic> json) => RecAlbumModel(
    id: json['id'],
    title: json['title'],
    value: json['value'],
    albums: json['albums'] == null
        ? null
        : List<AlbumItemsModel>.from(
        (json['albums'] ?? []).map((e) => AlbumItemsModel.fromJson(e))),
    description: json['description'],
    imgUrl: json['img_url'],
    urlConfig: json['url_config'],
    type: json['type'],
    router: json['router'],
    urlStr: json['url_str'],
    linkUrl: json['link_url'],
    url: json['url'],
    resourceUrl: json['resource_url'],
    redirectType: json['redirect_type'],
    reportId: json['report_id'],
    reportType: json['report_type'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'value': value,
    'albums': albums?.map((e) => e.toJson()).toList(),
    'description': description,
    'img_url': imgUrl,
    'url_config': urlConfig,
    'type': type,
    'router': router,
    'url_str': urlStr,
    'link_url': linkUrl,
    'url': url,
    'resource_url': resourceUrl,
    'redirect_type': redirectType,
    'report_id': reportId,
    'report_type': reportType,
  };
}

class AlbumDetailFartherModel {
  AlbumDetailModel? detail;

  AlbumDetailFartherModel({
    this.detail,
  });

  factory AlbumDetailFartherModel.fromJson(Map<String, dynamic> json) => AlbumDetailFartherModel(
    detail: AlbumDetailModel.fromJson(json['detail'])
  );

  Map<String, dynamic> toJson() => {
    'detail': detail?.toJson(),
  };
}

class AlbumDetailModel {
  final int? id;
  final int? type;
  final int? coins;
  final int? photoCt;
  final String? createdAt;
  final int? viewFct;
  final int? viewCt;
  int? favoriteFct;
  final int? commentCt;
  final String? tag;
  final String? title;
        int? isPay;
  int? isFavorite;
  int? isLike;
  int? likeFct;
  final List<AlbumPictureModel>? pics;

  AlbumDetailModel({
    this.id,
    this.title,
    this.type,
    this.coins,
    this.photoCt,
    this.createdAt,
    this.viewFct,
    this.viewCt,
    this.favoriteFct,
    this.commentCt,
    this.tag,
    this.isPay,
    this.isFavorite,
    this.isLike,
    this.likeFct,
    this.pics
  });

  factory AlbumDetailModel.fromJson(Map<String, dynamic> json) =>
      AlbumDetailModel(
        id: json['id'],
        title: json['title'],
        type: json['type'],
        coins: json['coins'],
        photoCt: json['photo_ct'],
        createdAt: json['created_at'],
        viewFct: json['view_fct'],
        viewCt: json['view_ct'],
        favoriteFct: json['favorite_fct'],
        commentCt: json['comment_ct'],
        tag: json['tag'],
        isPay: json['is_pay'],
        isFavorite: json['is_favorite'],
        isLike: json['is_like'],
        likeFct: json['like_fct'],
        pics: json['pics'] == null
            ? null
            : List<AlbumPictureModel>.from(
            json['pics'].map((e) => AlbumPictureModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'type': type,
    'coins': coins,
    'photo_ct': photoCt,
    'created_at': createdAt,
    'view_fct': viewFct,
    'view_ct': viewCt,
    'favorite_fct': favoriteFct,
    'comment_ct': commentCt,
    'tag': tag,
    'is_pay': isPay,
    'is_favorite': isFavorite,
    'is_like': isLike,
    'like_fct': likeFct,
    'pics': pics?.map((e) => e.toJson()),
  };
}

class AlbumPictureModel {
  final int? pId;
  final int? thumbW;
  final int? thumbH;
  final String? thumb;

  AlbumPictureModel({
    this.pId,
    this.thumbW,
    this.thumbH,
    this.thumb,
  });

  factory AlbumPictureModel.fromJson(Map<String, dynamic> json) =>
      AlbumPictureModel(
        pId: json['p_id'],
        thumbW: json['thumb_w'],
        thumbH: json['thumb_h'],
        thumb: json['thumb'],
      );

  Map<String, dynamic> toJson() => {
    'p_id': pId,
    'thumb_w': thumbW,
    'thumb_h': thumbH,
    'thumb': thumb,
  };
}