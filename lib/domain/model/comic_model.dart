import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/part_nav_model.dart';

import 'banner_model.dart';

//除了推荐以外的分类数据model
class ComicWithBannersModel {
  List<ComicItemsModel>? comics;
  List<BannerModel>? banner;
  List<TipModel>? tips;

  ComicWithBannersModel({this.comics, this.banner, this.tips});

  factory ComicWithBannersModel.fromJson(Map<String, dynamic> json) =>
      ComicWithBannersModel(
        comics: List<ComicItemsModel>.from(
            json['comics'].map((e) => ComicItemsModel.fromJson(e))),
        banner: List<BannerModel>.from(
            json['banner'].map((e) => BannerModel.fromJson(e))),
        tips:
            List<TipModel>.from(json['tips'].map((e) => TipModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() =>
      {'comics': comics, 'banner': banner, 'tips': tips};
}

class ComicItemsModel {
  final int? id;
  final String? themeIds;
  final String? cover;
  final String? title;
  final String? tag;
  final int? isEnd;
  final int? chapterCt; //总章节数
  final int? viewCt;
  final int? viewFct;
  final String? intro;

  ComicItemsModel({
    this.id,
    this.themeIds,
    this.title,
    this.cover,
    this.tag,
    this.isEnd,
    this.chapterCt,
    this.viewCt,
    this.viewFct,
    this.intro,
  });

  factory ComicItemsModel.fromJson(Map<String, dynamic> json) =>
      ComicItemsModel(
        id: json['id'],
        themeIds: json['theme_ids'],
        title: json['title'],
        cover: json['cover'],
        tag: json['tag'],
        isEnd: json['is_end'],
        chapterCt: json['chapter_ct'],
        viewFct: json['view_fct'],
        viewCt: json['view_ct'],
        intro: json['intro'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'theme_ids': themeIds,
        'title': title,
        'cover': cover,
        'tag': tag,
        'is_end': isEnd,
        'chapter_ct': chapterCt,
        'view_fct': viewFct,
        'view_ct': viewCt,
        'intro': intro,
      };
}

//热门推荐model数据
class RecComicWithBannersModel {
  List<RecComicModel>? comics;
  List<BannerModel>? banner;
  List<TipModel>? tips;
  List<PartModel>? nav;

  RecComicWithBannersModel({this.comics, this.banner, this.tips, this.nav});

  factory RecComicWithBannersModel.fromJson(Map<String, dynamic> json) =>
      RecComicWithBannersModel(
        comics: List<RecComicModel>.from(
            json['comics'].map((e) => RecComicModel.fromJson(e))),
        banner: List<BannerModel>.from(
            json['banner'].map((e) => BannerModel.fromJson(e))),
        nav:
            List<PartModel>.from(json['nav'].map((e) => PartModel.fromJson(e))),
        tips:
            List<TipModel>.from(json['tips'].map((e) => TipModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {
        'comics': comics?.map((e) => e.toJson()).toList(),
        'banner': banner?.map((e) => e.toJson()).toList(),
        'tips': tips?.map((e) => e.toJson()).toList(),
        'nav': nav?.map((e) => e.toJson()).toList()
      };
}

class RecComicModel {
  final String? title;
  final String? value;
        List<ComicItemsModel>? items;

  //广告数据
  final int? id;
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

  RecComicModel({
    this.id,
    this.title,
    this.value,
    this.items,
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

  factory RecComicModel.fromJson(Map<String, dynamic> json) => RecComicModel(
        id: json['id'],
        value: json['value'],
        title: json['title'],
        items: List<ComicItemsModel>.from(
            (json['items'] ?? []).map((e) => ComicItemsModel.fromJson(e))),
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
        'value': value,
        'title': title,
        'items': items?.map((e) => e.toJson()).toList(),
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

class ComicDetailWithBannersModel {
  List<ComicItemsModel>? recommend;
  List<BannerModel>? banner;
  ComicDetailModel? detail;

  ComicDetailWithBannersModel({this.recommend, this.banner, this.detail});

  factory ComicDetailWithBannersModel.fromJson(Map<String, dynamic> json) =>
      ComicDetailWithBannersModel(
        recommend: List<ComicItemsModel>.from(
            json['recommend'].map((e) => ComicItemsModel.fromJson(e))),
        banner: List<BannerModel>.from(
            json['banner'].map((e) => BannerModel.fromJson(e))),
        detail: json['detail'] == null ? null : ComicDetailModel.fromJson(json['detail']),
      );

  Map<String, dynamic> toJson() =>
      {'recommend': recommend, 'banner': banner, 'detail': detail};
}

class ComicDetailModel {
  final int? id;
  final String? title;
  final String? cover;
  final int? chapterCt; //总章节数
  final String? themeIds;
  final String? createdAt;
  final int? viewFct;
  final int? viewCt;
        int? favoriteFct;
  final String? renewedAt;
  final int? commentCt;
  final String? tag;
  final int? isEnd;
  final String? intro;
        int? isFavorite;
        int? isLike;
        int? likeFct;
  final List<ChaptersModel>? chapters;

  ComicDetailModel({
    this.id,
    this.title,
    this.cover,
    this.chapterCt,
    this.themeIds,
    this.createdAt,
    this.viewFct,
    this.viewCt,
    this.favoriteFct,
    this.renewedAt,
    this.commentCt,
    this.tag,
    this.isEnd,
    this.intro,
    this.isFavorite,
    this.isLike,
    this.likeFct,
    this.chapters,
  });

  factory ComicDetailModel.fromJson(Map<String, dynamic> json) =>
      ComicDetailModel(
        id: json['id'],
        title: json['title'],
        cover: json['cover'],
        chapterCt: json['chapter_ct'],
        themeIds: json['theme_ids'],
        createdAt: json['created_at'],
        viewFct: json['view_fct'],
        viewCt: json['view_ct'],
        favoriteFct: json['favorite_fct'],
        renewedAt: json['renewed_at'],
        commentCt: json['comment_ct'],
        tag: json['tag'],
        isEnd: json['is_end'],
        intro: json['intro'],
        isFavorite: json['is_favorite'],
        isLike: json['is_like'],
        likeFct: json['like_fct'],
        chapters: List<ChaptersModel>.from(
            json['chapters'].map((e) => ChaptersModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'cover': cover,
    'chapter_ct': chapterCt,
    'theme_ids': themeIds,
    'created_at': createdAt,
    'view_fct': viewFct,
    'view_ct': viewCt,
    'favorite_fct': favoriteFct,
    'renewed_at': renewedAt,
    'comment_ct': commentCt,
    'tag': tag,
    'is_end': isEnd,
    'intro': intro,
    'is_favorite': isFavorite,
    'is_like': isLike,
    'like_fct': likeFct,
    'chapters': chapters,
  };
}

class ChaptersModel {
  final int? pId;
  final int? id;
  final int? type;
  final int? coins;
  final String? title;
        int? isPay;
  final String? payTip;
  final String? cover; //章节封面

  //章节详情
  final String? thumb;
  final int? thumbW;
  final int? thumbH;


  ChaptersModel({
    this.pId,
    this.id,
    this.type,
    this.coins,
    this.title,
    this.isPay,
    this.payTip,
    this.cover,
    this.thumb,
    this.thumbW,
    this.thumbH,
  });

  factory ChaptersModel.fromJson(Map<String, dynamic> json) =>
      ChaptersModel(
        pId: json['p_id'],
        id: json['id'],
        type: json['type'],
        coins: json['coins'],
        title: json['title'],
        isPay: json['is_pay'],
        payTip: json['pay_tip'],
        cover: json['cover'],
        thumb: json['thumb'],
        thumbW: json['thumb_w'],
        thumbH: json['thumb_h'],
      );

  Map<String, dynamic> toJson() => {
    'p_id': pId,
    'id': id,
    'type': type,
    'coins': coins,
    'title': title,
    'is_pay': isPay,
    'pay_tip': payTip,
    'cover': cover,
    'thumb': thumb,
    'thumb_w': thumbW,
    'thumb_h': thumbH,
  };
}


class ChaptersDetaiModel {
  List<ChaptersModel>? pics;

  ChaptersDetaiModel({
    this.pics,
  });

  factory ChaptersDetaiModel.fromJson(Map<String, dynamic> json) =>
      ChaptersDetaiModel(
        pics: List<ChaptersModel>.from(
            json['pics'].map((e) => ChaptersModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {
    'pics': pics?.map((e) => e.toJson()),
  };
}
