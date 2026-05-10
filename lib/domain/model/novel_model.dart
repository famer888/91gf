import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/part_nav_model.dart';
import 'package:jygf/domain/model/track_report_info.dart';

//除了推荐以外的分类数据model
class NovelWithBannersModel {
  List<NovelItemsModel>? novels;
  List<BannerModel>? banner;
  List<TipModel>? tips;

  NovelWithBannersModel({this.novels, this.banner, this.tips});

  factory NovelWithBannersModel.fromJson(Map<String, dynamic> json) => NovelWithBannersModel(
        novels: List<NovelItemsModel>.from(json['novels'].map((e) => NovelItemsModel.fromJson(e))),
        banner:
            json['banner'] != null ? List<BannerModel>.from(json['banner'].map((e) => BannerModel.fromJson(e))) : [],
        tips: json['tips'] != null ? List<TipModel>.from(json['tips'].map((e) => TipModel.fromJson(e))) : [],
      );

  Map<String, dynamic> toJson() => {'novels': novels, 'banner': banner, 'tips': tips};
}

class NovelItemsModel {
  final int? id;
  final int? themeIds;
  final String? cover;
  final String? title;
  final String? tag;
  final int? isEnd;
  final int? chapterCt; //总章节数
  final int? viewCt;
  final int? viewFct;
  final String? intro;
  final int? fontCt;

  NovelItemsModel({
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
    this.fontCt,
  });

  factory NovelItemsModel.fromJson(Map<String, dynamic> json) => NovelItemsModel(
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
        fontCt: json['font_ct'],
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
        'font_ct': fontCt,
      };
}

//热门推荐model数据
class RecNovelWithBannersModel {
  List<NovelItemsModel>? like;
  List<RecNovelModel>? novels;
  List<BannerModel>? banner;
  List<TipModel>? tips;
  List<PartModel>? nav;

  RecNovelWithBannersModel({this.like, this.novels, this.banner, this.nav, this.tips});

  factory RecNovelWithBannersModel.fromJson(Map<String, dynamic> json) => RecNovelWithBannersModel(
        like: json['like'] == null
            ? null
            : List<NovelItemsModel>.from(json['like'].map((e) => NovelItemsModel.fromJson(e))),
        novels: json['novels'] == null
            ? null
            : List<RecNovelModel>.from(json['novels'].map((e) => RecNovelModel.fromJson(e))),
        banner:
            json['banner'] == null ? null : List<BannerModel>.from(json['banner'].map((e) => BannerModel.fromJson(e))),
        nav: List<PartModel>.from(json['nav'].map((e) => PartModel.fromJson(e))),
        tips: json['tips'] == null ? null : List<TipModel>.from(json['tips'].map((e) => TipModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {
        'like': like?.map((e) => e.toJson()).toList(),
        'novels': novels?.map((e) => e.toJson()).toList(),
        'banner': banner?.map((e) => e.toJson()).toList(),
        'nav': nav?.map((e) => e.toJson()).toList(),
        'tips': tips?.map((e) => e.toJson()).toList(),
      };
}

class RecNovelModel {
  final String? title;
  final String? value;
  List<NovelItemsModel>? items;

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

  RecNovelModel({
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

  factory RecNovelModel.fromJson(Map<String, dynamic> json) => RecNovelModel(
        title: json['title'],
        value: json['value'],
        items: json['items'] == null
            ? null
            : List<NovelItemsModel>.from((json['items'] ?? []).map((e) => NovelItemsModel.fromJson(e))),
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
        'title': title,
        'value': value,
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

class NovelDetailWithBannersModel {
  List<NovelItemsModel>? recommend;
  List<BannerModel>? banner;
  NovelDetailModel? detail;

  NovelDetailWithBannersModel({this.recommend, this.banner, this.detail});

  factory NovelDetailWithBannersModel.fromJson(Map<String, dynamic> json) => NovelDetailWithBannersModel(
        recommend: json['recommend'] == null
            ? null
            : List<NovelItemsModel>.from(json['recommend'].map((e) => NovelItemsModel.fromJson(e))),
        banner:
            json['banner'] == null ? null : List<BannerModel>.from(json['banner'].map((e) => BannerModel.fromJson(e))),
        detail: json['detail'] == null ? null : NovelDetailModel.fromJson(json['detail']),
      );

  Map<String, dynamic> toJson() => {'recommend': recommend, 'banner': banner, 'detail': detail};
}

class NovelDetailModel {
  final int? id;
  final String? title;
  final String? cover;
  final int? chapterCt; //总章节数
  final int? themeIds;
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
  int? likeCt;
  int? fontCt;
  final String? author;
  final List<NovelChaptersModel>? chapters;
  String? lsjId; // 老司机媒体资源ID

  String? novelTagKey;
  String? novelTagName;

  TrackReportInfo? reportInfo;

  NovelDetailModel(
      {this.id,
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
      this.likeCt,
      this.chapters,
      this.fontCt,
      this.author,
      this.lsjId,
      this.novelTagKey,
      this.novelTagName,
      this.reportInfo});

  factory NovelDetailModel.fromJson(Map<String, dynamic> json) => NovelDetailModel(
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
      likeCt: json['like_ct'],
      lsjId: json['lsjId'],
      reportInfo: TrackReportInfo.fromMap(json['reportInfo']),
      chapters: json['chapters'] == null
          ? null
          : List<NovelChaptersModel>.from(json['chapters'].map((e) => NovelChaptersModel.fromJson(e))),
      fontCt: json['font_ct'],
      author: json['author'],
      novelTagName: json['novel_tag_name'],
      novelTagKey: json['novel_tag_key']);

  Map<String, dynamic> toJson() => {
        'novel_tag_name': novelTagName,
        'novel_tag_key': novelTagKey,
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
        'like_ct': likeCt,
        'chapters': chapters?.map((e) => e.toJson()),
        'font_ct': fontCt,
        'author': author,
        'lsjId': lsjId,
        "reportInfo": reportInfo?.toJson()
      };
}

class NovelChaptersModel {
  final int? pId;
  final int? id;
  final int? type;
  final int? coins;
  final String? title;

  // int? isPay;
  final String? payTip;
  String? txt; //获取章节文字url链接
  String? text; //文字内容，通过txt接口请求获取

  NovelChaptersModel({
    this.pId,
    this.id,
    this.type,
    this.coins,
    this.title,
    // this.isPay,
    this.payTip,
    this.txt,
    this.text,
  });

  factory NovelChaptersModel.fromJson(Map<String, dynamic> json) => NovelChaptersModel(
        pId: json['p_id'],
        id: json['id'],
        type: json['type'],
        coins: json['coins'],
        title: json['title'],
        // isPay: json['is_pay'],
        payTip: json['pay_tip'],
        txt: json['txt'],
        text: json['text'],
      );

  Map<String, dynamic> toJson() => {
        'p_id': pId,
        'id': id,
        'type': type,
        'coins': coins,
        'title': title,
        // 'is_pay': isPay,
        'pay_tip': payTip,
        'txt': txt,
        'text': text,
      };
}

//关注的专题的小说model
class NovelSubjectNovelListModel {
  List<NovelItemsModel>? list;

  NovelSubjectNovelListModel({this.list});

  factory NovelSubjectNovelListModel.fromJson(Map<String, dynamic> json) => NovelSubjectNovelListModel(
        list: json['list'] == null
            ? null
            : List<NovelItemsModel>.from(json['list'].map((e) => NovelItemsModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {'list': list};
}

//关注的专题列表model
class NovelSubjectListModel {
  List<NovelSubjectListItemModel>? list;

  NovelSubjectListModel({this.list});

  factory NovelSubjectListModel.fromJson(Map<String, dynamic> json) => NovelSubjectListModel(
        list: json['list'] == null
            ? null
            : List<NovelSubjectListItemModel>.from(json['list'].map((e) => NovelSubjectListItemModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {'list': list};
}

class NovelSubjectListItemModel {
  final int? id;
  final String? name;
  final int? followNum;
  final int? worksNum;
  final String? thumb;
  int? isFollow;
  int? hasSort;
  int? hasFollow;
  final String? moreApi;
  final NovelApiParamsModel? apiParams;

  NovelSubjectListItemModel(
      {this.id,
      this.name,
      this.followNum,
      this.worksNum,
      this.thumb,
      this.isFollow,
      this.hasSort,
      this.hasFollow,
      this.moreApi,
      this.apiParams});

  factory NovelSubjectListItemModel.fromJson(Map<String, dynamic> json) => NovelSubjectListItemModel(
      id: json['id'],
      name: json['name'],
      followNum: json['follow_num'],
      worksNum: json['works_num'],
      thumb: json['thumb'],
      isFollow: json['is_follow'],
      hasSort: json['has_sort'],
      hasFollow: json['has_follow'],
      moreApi: json['more_api'],
      apiParams: NovelApiParamsModel.fromJson(json['api_params']));

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'follow_num': followNum,
        'works_num': worksNum,
        'thumb': thumb,
        'is_follow': isFollow,
        'has_sort': hasSort,
        'has_follow': hasFollow,
        'more_api': moreApi,
        'api_params': apiParams?.toJson(),
      };
}

class NovelApiParamsModel {
  final int? id;
  final String? sort;

  NovelApiParamsModel({
    this.id,
    this.sort,
  });

  factory NovelApiParamsModel.fromJson(Map<String, dynamic> json) => NovelApiParamsModel(
        id: json['id'] ?? 0,
        sort: json['sort'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sort': sort,
      };
}
