import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/home_data_model.dart';

class BlackSearchModel {
  final List<BlackListItemModel> list;
  final String lastIx;

  BlackSearchModel({
    required this.list,
    required this.lastIx,
  });

  factory BlackSearchModel.fromJson(Map<String, dynamic> json) {
    return BlackSearchModel(
      list: json['list'] != null ? List<BlackListItemModel>.from(json['list'].map((app) => BlackListItemModel.fromJson(app))) : [],
      lastIx: json['last_ix'] ?? '',
    );
  }
}

class BlackClassModel {
  final List<BlackModel> list;
  final String lastIx;

  BlackClassModel({
    required this.list,
    required this.lastIx,
  });

  factory BlackClassModel.fromJson(Map<String, dynamic> json) {
    return BlackClassModel(
      list: List<BlackModel>.from(json['list']?.map((app) => BlackModel.fromJson(app))),
      lastIx: json['last_ix'],
    );
  }
}

class BlackModel {
  final bool current;
  final int mid;
  final String name;
  final String apiList;
  final ParamsListModel? paramsList;

  BlackModel({
    required this.current,
    required this.mid,
    required this.name,
    required this.apiList,
    required this.paramsList,
  });

  factory BlackModel.fromJson(Map<String, dynamic> json) {
    return BlackModel(
      current: json['current'],
      mid: json['mid'],
      name: json['name'],
      apiList: json['api_list'],
      paramsList: json['params_list'] == null ? null : ParamsListModel.fromJson(json['params_list']),
    );
  }
}

class ParamsListModel {
  final int mid;

  ParamsListModel({
    required this.mid,
  });

  factory ParamsListModel.fromJson(dynamic json) {
    return ParamsListModel(mid: json['mid']);
  }
}

class BlackListContentModel {
  final List<BannerModel> banners;
  final List<BlackListItemModel> list;

  BlackListContentModel({
    required this.banners,
    required this.list,
  });

  factory BlackListContentModel.fromJson(Map<String, dynamic> json) {
    return BlackListContentModel(
      banners: List<BannerModel>.from(json['banners']?.map((app) => BannerModel.fromJson(app))),
      list: List<BlackListItemModel>.from(json['list']?.map((app) => BlackListItemModel.fromJson(app))),
    );
  }
}

class BlackLabelListModel {
  final List<BlackListItemModel> list;

  BlackLabelListModel({
    required this.list,
  });

  factory BlackLabelListModel.fromJson(Map<String, dynamic> json) {
    return BlackLabelListModel(
      list: List<BlackListItemModel>.from(json['list']?.map((app) => BlackListItemModel.fromJson(app))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'list': list.map((app) => app.toJson()).toList(),
    };
  }
}

class AdBannerModel {
  int id = 0;
  String title = '';
  String description = '';
  String mvM3u8 = '';
  String imgUrl = '';
  String url = '';
  String imgUrlFull = '';
  int type = 0;
  int value = 0;

  AdBannerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.mvM3u8,
    required this.imgUrl,
    required this.url,
    required this.imgUrlFull,
    required this.type,
    required this.value,
  });

  factory AdBannerModel.fromJson(Map<String, dynamic> json) {
    return AdBannerModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      mvM3u8: json['mv_m3u8'],
      imgUrl: json['img_url'],
      url: json['url'],
      imgUrlFull: json['img_url_full'],
      type: json['type'],
      value: json['value'],
    );
  }
}

class BlackListItemModel {
  final int id;
  final int? aff;
  final String title;
  final String thumb;
  final String createdAt;
  final int type;
  final int coins;
  final int commentNum;
  final int isHome;
  final int homeTop;
  final int likeNum;
  final int favoriteNum;
  final int viewNum;
  final bool isLike;
  final bool isFavorite;
  final bool isPay;
  final bool isNew;
  final bool isHot;
  final bool needVip;
  final AuthorModel author;
  final List<BCategoryModel> category;

  BlackListItemModel({
    required this.id,
    this.aff,
    required this.title,
    required this.thumb,
    required this.createdAt,
    required this.type,
    required this.coins,
    required this.commentNum,
    required this.isHome,
    required this.homeTop,
    required this.likeNum,
    required this.favoriteNum,
    required this.viewNum,
    required this.isLike,
    required this.isFavorite,
    required this.isPay,
    required this.isNew,
    required this.isHot,
    required this.needVip,
    required this.author,
    required this.category,
  });

  factory BlackListItemModel.fromJson(Map<dynamic, dynamic> json) {
    return BlackListItemModel(
      id: json['id'],
      aff: json['aff'] ?? 0,
      title: json['title'],
      thumb: json['thumb'],
      createdAt: json['created_at'],
      type: json['type'],
      coins: json['coins'],
      commentNum: json['comment_num'],
      isHome: json['is_home'],
      homeTop: json['home_top'],
      likeNum: json['like_num'],
      favoriteNum: json['favorite_num'],
      viewNum: json['view_num'],
      isLike: (json['is_like'] ?? 0) > 0,
      isFavorite: (json['is_favorite'] ?? 0) > 0,
      isPay: (json['is_pay'] ?? 0) > 0,
      isNew: (json['is_new'] ?? 0) > 0,
      isHot: (json['is_hot'] ?? 0) > 0,
      needVip: (json['need_vip'] ?? 0) > 0,
      author: AuthorModel.fromJson(json['author']),
      category: List<BCategoryModel>.from(json['category']?.map((app) => BCategoryModel.fromJson(app))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aff': aff,
      'title': title,
      'thumb': thumb,
      'created_at': createdAt,
      'type': type,
      'coins': coins,
      'comment_num': commentNum,
      'is_home': isHome,
      'home_top': homeTop,
      'like_num': likeNum,
      'favorite_num': favoriteNum,
      'view_num': viewNum,
      'is_like': isLike ? 1 : 0,
      'is_favorite': isFavorite ? 1 : 0,
      'is_pay': isPay ? 1 : 0,
      'is_new': isNew ? 1 : 0,
      'is_hot': isHot ? 1 : 0,
      'need_vip': needVip ? 1 : 0,
      'author': author.toJson(),
      'category': category.map((app) => app.toJson()).toList(),
    };
  }
}

class AuthorModel {
  final int aff;
  final String nickname;
  final int isSetPassword;
  final bool newUser;
  final int isFollow;
  final List<dynamic> tagList;
  final String vipStr;

  AuthorModel({
    required this.aff,
    required this.nickname,
    required this.isSetPassword,
    required this.newUser,
    required this.isFollow,
    required this.tagList,
    required this.vipStr,
  });

  factory AuthorModel.fromJson(Map<dynamic, dynamic> json) {
    return AuthorModel(
      aff: json['aff'] ?? 0,
      nickname: json['nickname'] ?? '',
      isSetPassword: json['is_set_password'] ?? 0,
      newUser: json['new_user'] ?? false,
      isFollow: json['is_follow'] ?? 0,
      tagList: json['tag_list'] ?? [],
      vipStr: json['vip_str'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'aff': aff,
      'nickname': nickname,
      'is_set_password': isSetPassword,
      'new_user': newUser,
      'is_follow': isFollow,
      'tag_list': tagList,
      'vip_str': vipStr,
    };
  }
}

class BCategoryModel {
  dynamic mid;
  String name = '';

  BCategoryModel({
    required this.mid,
    required this.name,
  });

  factory BCategoryModel.fromJson(Map<dynamic, dynamic> json) {
    return BCategoryModel(
      mid: json['mid'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mid': mid,
      'name': name,
    };
  }
}

class BlackDetailModel {
  final List<dynamic> prev;
  final CurDetailsModel? cur;
  final List<dynamic> next;
  final List<Notice> topBanner;
  final List<Notice> botBanner;
  final List<RecommendModel>? recommend;

  BlackDetailModel({
    this.prev = const [],
    this.cur,
    this.next = const [],
    this.topBanner = const [],
    this.botBanner = const [],
    this.recommend,
  });

  factory BlackDetailModel.fromJson(Map<String, dynamic> json) {
    return BlackDetailModel(
      prev: json['prev'] ?? [],
      cur: CurDetailsModel.fromJson(json['cur']),
      next: json['next'] ?? [],
      topBanner: json['top_banner'] != null ? List<Notice>.from(json['top_banner'].map((app) => Notice.fromJson(app))) : [],
      botBanner: json['bot_banner'] != null ? List<Notice>.from(json['bot_banner'].map((app) => Notice.fromJson(app))) : [],
      recommend: List<RecommendModel>.from(json['recommend']?.map((app) => RecommendModel.fromJson(app))),
    );
  }
}

class CurDetailsModel {
  final int id;
  final int aff;
  final String title;
  final String thumb;
  final String createdAt;
  final int type;
  final int coins;
  final int commentNum;
  final int isHome;
  final int homeTop;
  int likeNum;
  int favoriteNum;
  final int viewNum;
  final String tags;
  final String content;
  bool isLike;
  bool isFavorite;
  bool isPay;
  final bool isNew;
  final bool isHot;
  final bool needVip;
  final AuthorModel author;
  final List<BCategoryModel> category;

  CurDetailsModel({
    required this.id,
    required this.aff,
    required this.title,
    required this.thumb,
    required this.createdAt,
    required this.type,
    required this.coins,
    required this.commentNum,
    required this.isHome,
    required this.homeTop,
    required this.likeNum,
    required this.favoriteNum,
    required this.viewNum,
    required this.tags,
    required this.content,
    required this.isLike,
    required this.isFavorite,
    required this.isPay,
    required this.isNew,
    required this.isHot,
    required this.needVip,
    required this.author,
    required this.category,
  });

  factory CurDetailsModel.fromJson(Map<String, dynamic> json) {
    return CurDetailsModel(
      id: json['id'],
      aff: json['aff'],
      title: json['title'],
      thumb: json['thumb'],
      createdAt: json['created_at'],
      type: json['type'],
      coins: json['coins'],
      commentNum: json['comment_num'],
      isHome: json['is_home'],
      homeTop: json['home_top'],
      likeNum: json['like_num'],
      favoriteNum: json['favorite_num'],
      viewNum: json['view_num'],
      tags: json['tags'],
      content: json['content'],
      isLike: (json['is_like'] ?? 0) > 0,
      isFavorite: (json['is_favorite'] ?? 0) > 0,
      isPay: (json['is_pay'] ?? 0) > 0,
      isNew: (json['is_new'] ?? 0) > 0,
      isHot: (json['is_hot'] ?? 0) > 0,
      needVip: (json['need_vip'] ?? 0) > 0,
      author: AuthorModel.fromJson(json['author']),
      category: List<BCategoryModel>.from(json['category']?.map((app) => BCategoryModel.fromJson(app))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aff': aff,
      'title': title,
      'thumb': thumb,
      'created_at': createdAt,
      'type': type,
      'coins': coins,
      'comment_num': commentNum,
      'is_home': isHome,
      'home_top': homeTop,
      'like_num': likeNum,
      'favorite_num': favoriteNum,
      'view_num': viewNum,
      'tags': tags,
      'content': content,
      'is_like': isLike,
      'is_favorite': isFavorite,
      'is_pay': isPay,
      'is_new': isNew,
      'is_hot': isHot,
      'need_vip': needVip,
      'author': author.toJson(),
      'category': category.map((app) => app.toJson()).toList(),
    };
  }
}

class RecommendModel {

  final int id;
  final int aff;
  final String title;
  final String thumb;
  final String createdAt;
  final int type;
  final int coins;
  final int commentNum;
  final int isHome;
  final int homeTop;
  final int likeNum;
  final int favoriteNum;
  final int viewNum;
  final bool isLike;
  final bool isFavorite;
  final bool isPay;
  final bool isNew;
  final bool isHot;
  final bool needVip;
  final AuthorModel author;

  RecommendModel({
    required this.id,
    required this.aff,
    required this.title,
    required this.thumb,
    required this.createdAt,
    required this.type,
    required this.coins,
    required this.commentNum,
    required this.isHome,
    required this.homeTop,
    required this.likeNum,
    required this.favoriteNum,
    required this.viewNum,
    required this.isLike,
    required this.isFavorite,
    required this.isPay,
    required this.isNew,
    required this.isHot,
    required this.needVip,
    required this.author,
  });

  factory RecommendModel.fromJson(Map<String, dynamic> json) {
    return RecommendModel(
      id: json['id'] ?? 0,
      aff: json['aff'] ?? 0,
      title: json['title'] ?? '',
      thumb: json['thumb'] ?? '',
      createdAt: json['created_at'] ?? '',
      type: json['type'] ?? 0,
      coins: json['coins'] ?? 0,
      commentNum: json['comment_num'] ?? 0,
      isHome: json['is_home'] ?? 0,
      homeTop: json['home_top'] ?? 0,
      likeNum: json['like_num'] ?? 0,
      favoriteNum: json['favorite_num'] ?? 0,
      viewNum: json['view_num'] ?? 0,
      isLike: (json['is_like'] ?? 0) > 0,
      isFavorite: (json['is_favorite'] ?? 0) > 0,
      isPay: (json['is_pay'] ?? 0) > 0,
      isNew: (json['is_new'] ?? 0) > 0,
      isHot: (json['is_hot'] ?? 0) > 0,
      needVip: (json['need_vip'] ?? 0) > 0,
      author: AuthorModel.fromJson(json['author'] ?? {}),
    );
  }
}

class CommentListModel {
  final List<CommentModel> list;
  final String lastIx;

  CommentListModel({
    required this.list,
    required this.lastIx,
  });

  factory CommentListModel.fromJson(Map<String, dynamic> json) {
    return CommentListModel(
      list: List<CommentModel>.from(json['list']?.map((app) => CommentModel.fromJson(app))),
      lastIx: json['last_ix'],
    );
  }
}

class CommentModel {
  final int id;
  final int cid;
  final int pid;
  final int aff;
  final String comment;
  final int status;
  final int likeNum;
  final int videoNum;
  final int photoNum;
  final String createdAt;
  final String updatedAt;
  final int isTop;
  final List<CommentModel> comments;
  final CommentUser user;

  CommentModel({
    required this.id,
    required this.cid,
    required this.pid,
    required this.aff,
    required this.comment,
    required this.status,
    required this.likeNum,
    required this.videoNum,
    required this.photoNum,
    required this.createdAt,
    required this.updatedAt,
    required this.isTop,
    required this.comments,
    required this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      cid: json['cid'],
      pid: json['pid'],
      aff: json['aff'],
      comment: json['comment'],
      status: json['status'],
      likeNum: json['like_num'],
      videoNum: json['video_num'],
      photoNum: json['photo_num'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isTop: json['is_top'],
      comments: List<CommentModel>.from(json['comments']?.map((app) => CommentModel.fromJson(app))),
      user: CommentUser.fromJson(json['user']),
    );
  }
}

class CommentUser {
  final int aff;
  final int uid;
  final String nickname;
  final String thumb;
  final String expiredAt;
  final int vipLevel;
  final String uuid;
  final int authStatus;
  final int isSetPassword;
  final bool newUser;
  final bool isFollow;
  final List<dynamic> tagList;
  final String vipStr;

  CommentUser({
    required this.aff,
    required this.uid,
    required this.nickname,
    required this.thumb,
    required this.expiredAt,
    required this.vipLevel,
    required this.uuid,
    required this.authStatus,
    required this.isSetPassword,
    required this.newUser,
    required this.isFollow,
    required this.tagList,
    required this.vipStr,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      aff: json['aff'],
      uid: json['uid'],
      nickname: json['nickname'],
      thumb: json['thumb'],
      expiredAt: json['expired_at'],
      vipLevel: json['vip_level'],
      uuid: json['uuid'],
      authStatus: json['auth_status'],
      isSetPassword: json['is_set_password'],
      newUser: json['new_user'],
      isFollow: (json['is_follow'] ?? 0) > 0,
      tagList: json['tag_list'],
      vipStr: json['vip_str'],
    );
  }
}

class BlackPostLikeModel {
  final int isLike;
  final String msg;

  BlackPostLikeModel({
    required this.isLike,
    required this.msg,
  });

  factory BlackPostLikeModel.fromJson(Map<String, dynamic> json) {
    return BlackPostLikeModel(
      isLike: json['is_like'],
      msg: json['msg'],
    );
  }
}

