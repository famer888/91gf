import 'package:jygf/domain/model/banner_model.dart';

class BlackListModel {
  List<BannerModel> banners;
  List<BlackPostModel> list;

  BlackListModel({
    this.banners = const [],
    this.list = const [],
  });

  factory BlackListModel.fromJson(Map<String, dynamic> json) {
    return BlackListModel(
      banners: json['banners'] != null ? List<BannerModel>.from(json['banners'].map((e) => BannerModel.fromJson(e))) : [],
      list: json['list'] != null ? List<BlackPostModel>.from(json['banners'].map((e) => BlackPostModel.fromJson(e))) : [],
    );
  }
}

class BlackPostModel {
  int id;
  int aff;
  String title;
  String thumb;
  String createdAt;
  int type;
  int coins;
  int commentNum;
  int isHome;
  int homeTop;
  int likeNum;
  int favoriteNum;
  int viewNum;
  int isLike;
  int isFavorite;
  int isPay;
  int isNew;
  int isHot;
  int needVip;
  BlackAuthorModel? author;
  List<BlackPostCategoryModel> category;

  BlackPostModel({
    this.id = 0,
    this.aff = 0,
    this.title = '',
    this.thumb = '',
    this.createdAt = '',
    this.type = 0,
    this.coins = 0,
    this.commentNum = 0,
    this.isHome = 0,
    this.homeTop = 0,
    this.likeNum = 0,
    this.favoriteNum = 0,
    this.viewNum = 0,
    this.isLike = 0,
    this.isFavorite = 0,
    this.isPay = 0,
    this.isNew = 0,
    this.isHot = 0,
    this.needVip = 0,
    this.author,
    this.category = const [],
  });

  factory BlackPostModel.fromJson(Map<String, dynamic> json) {
    return BlackPostModel(
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
      isLike: json['is_like'] ?? 0,
      isFavorite: json['is_favorite'] ?? 0,
      isPay: json['is_pay'] ?? 0,
      isNew: json['is_new'] ?? 0,
      isHot: json['is_hot'] ?? 0,
      needVip: json['need_vip'] ?? 0,
      author: json['author'] != null ? BlackAuthorModel.fromJson(json['author']) : null,
      category:
          json['category'] != null ? List<BlackPostCategoryModel>.from(json['category'].map((e) => BlackPostCategoryModel.fromJson(e))) : [],
    );
  }
}

class BlackAuthorModel {
  int aff;
  int uid;
  String nickname;
  String thumb;
  String expiredAt;
  int vipLevel;
  String uuid;
  int authStatus;
  int isSetPassword;
  bool newUser;
  int isFollow;
  List<String> tagList;
  String vipStr;

  BlackAuthorModel({
    this.aff = 0,
    this.uid = 0,
    this.nickname = '',
    this.thumb = '',
    this.expiredAt = '',
    this.vipLevel = 0,
    this.uuid = '',
    this.authStatus = 0,
    this.isSetPassword = 0,
    this.newUser = false,
    this.isFollow = 0,
    this.tagList = const [],
    this.vipStr = '',
  });

  factory BlackAuthorModel.fromJson(Map<String, dynamic> json) {
    return BlackAuthorModel(
      aff: json['aff'] ?? 0,
      uid: json['uid'] ?? 0,
      nickname: json['nickname'] ?? '',
      thumb: json['thumb'] ?? '',
      expiredAt: json['expired_at'] ?? '',
      vipLevel: json['vip_level'] ?? 0,
      uuid: json['uuid'] ?? '',
      authStatus: json['auth_status'] ?? 0,
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
      'uid': uid,
      'nickname': nickname,
      'thumb': thumb,
      'expired_at': expiredAt,
      'vip_level': vipLevel,
      'uuid': uuid,
      'auth_status': authStatus,
      'is_set_password': isSetPassword,
      'new_user': newUser,
      'is_follow': isFollow,
    };
  }
}

class BlackPostCategoryModel {
  int mid;
  String name;

  BlackPostCategoryModel({this.mid = 0, this.name = ''});

  factory BlackPostCategoryModel.fromJson(Map<String, dynamic> json) {
    return BlackPostCategoryModel(
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
