import 'package:jygf/domain/model/cartoon/cartoon_model.dart';
import 'package:jygf/domain/model/home_data_model.dart';


class CartoonDetailModel {
  CartoonDetailModel({required this.detail, this.banner, this.recommend});
  final CartoonDetailVideoModel detail;
  final List<Notice>? banner;
  final List<CartoonModel>? recommend;

  factory CartoonDetailModel.fromJson(Map<String, dynamic> json) =>
      CartoonDetailModel(
        detail: CartoonDetailVideoModel.fromJson(json['detail']),
        banner: json['banner'] == null
            ? null
            : List<Notice>.from(json['banner'].map((e) => Notice.fromJson(e))),
        recommend: json['recommend'] == null
            ? null
            : List<CartoonModel>.from(
                json['recommend'].map((e) => CartoonModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {
        'detail': detail.toJson(),
        'banner': banner,
        'recommend': recommend,
      };
}

class CartoonDetailVideoModel {
  final int? id; // 5,
  final String? themeIds; // "",
  final String?
      cover; // "https://new1.sanheyiliao.xyz/upload_01/xiao/20240902/2024090210181644508.jpg",
  final String? title; // "极品粉嫩萝莉  粉红jk萝莉自慰",
  final String?
      source_240; // "https://long.hfsudf.cn/watch9/7b3221538f8f14106cfe072d13ade559/7b3221538f8f14106cfe072d13ade559.m3u8?auth_key=1725267047-0-0-fe63de86ac41ff471789c94ed2b2ae1b&via_m=haijiao",

  final int? duration; // 938,
  final int? type; // 1,
  final int? isfree; //同步type值，进入视频详情时需要
  final int? coins; // 0,
  final int? viewFakeCount; // 254198,

  final int? likeFakeCount; // 0,
  int favoriteFakeCount; // 0,

  final int? commentCount; // 0,
  final String? createdAt; // "2024-09-02 12:22:52"
  int? isFavorite; // 0,
  final int? isLike; // 0,
  final String?
      previewUrl; // "https://10play.hfsudf.cn/watch9/7b3221538f8f14106cfe072d13ade559/7b3221538f8f14106cfe072d13ade559.m3u8?auth_key=1725267047-0-0-fe63de86ac41ff471789c94ed2b2ae1b&via_m=haijiao"，
  final String? payTip; // "38金币或51至尊卡/51主宰卡解锁"

  CartoonDetailVideoModel({
    this.id,
    this.themeIds,
    this.cover,
    this.title,
    this.source_240,
    this.duration,
    this.type,
    this.isfree,
    this.coins,
    this.viewFakeCount,
    this.commentCount,
    this.createdAt,
    this.likeFakeCount,
    this.favoriteFakeCount = 0,
    this.isFavorite,
    this.isLike,
    this.previewUrl,
    this.payTip,
  });

  factory CartoonDetailVideoModel.fromJson(Map<String, dynamic> json) =>
      CartoonDetailVideoModel(
        id: json['id'],
        themeIds: json['theme_ids'],
        cover: json['cover'],
        title: json['title'],
        source_240: json['source_240'],
        duration: json['duration'],
        type: json['type'],
        isfree: json['type'],
        coins: json['coins'],
        viewFakeCount: json['view_fct'],
        commentCount: json['comment_ct'],
        createdAt: json['created_at'],
        likeFakeCount: json['like_fct'],
        favoriteFakeCount: json['favorite_fct'],
        isFavorite: json['is_favorite'],
        isLike: json['is_like'],
        previewUrl: json['preview_url'],
        payTip: json['pay_tip'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'theme_ids': themeIds,
        'cover': cover,
        'title': title,
        'source_240': source_240,
        'duration': duration,
        'type': type,
        'isfree': isfree,
        'coins': coins,
        'view_fct': viewFakeCount,
        'comment_ct': commentCount,
        'created_at': createdAt,
        'like_fct': likeFakeCount,
        'favorite_fct': favoriteFakeCount,
        'is_favorite': isFavorite,
        'is_like': isLike,
        'preview_url': previewUrl,
        'pay_tip': payTip,
      };
}
