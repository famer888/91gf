import 'package:jygf/domain/model/post_model.dart';

class TopicModel {
  final int id;
  final String thumb;
  final String name;
  final int followNum;
  final int viewNum;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final int? sort;
  final int? isHot;
  final String bgThumb;
  final int postNum;
  final String intro;
  final int? pid;
  final int? isContact;
  final int? isAi;
  int? isFollow;
  final int isPay;
  final int coins;
  final int tollType;
  final int type;
  final List<String> vipStr;
  final String? title;
  final int? isLive;
  final List<PostModel>? postList;

  TopicModel({
    required this.id,
    required this.thumb,
    required this.name,
    required this.followNum,
    required this.viewNum,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.sort,
    this.isHot,
    required this.bgThumb,
    required this.postNum,
    required this.intro,
    this.pid,
    this.isContact,
    this.isAi,
    this.isFollow,
    this.isLive,
    required this.isPay,
    required this.coins,
    required this.tollType,
    required this.vipStr,
    required this.title,
    required this.type,
    this.postList,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) => TopicModel(
        id: json['id'],
        thumb: json['thumb'] ?? '',
        name: json['name'] ?? '',
        followNum: json['follow_num'] ?? 0,
        viewNum: json['view_num'] ?? 0,
        status: json['status'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        sort: json['sort'],
        isHot: json['is_hot'],
        bgThumb: json['bg_thumb'] ?? '',
        postNum: json['post_num'] ?? 0,
        intro: json['intro'] ?? '',
        pid: json['pid'],
        isContact: json['is_contact'],
        isAi: json['is_ai'],
        isFollow: json['is_follow'],
        isPay: json['is_pay'] ?? 0,
        coins: json['coins'] ?? 0,
        tollType: json['toll_type'] ?? 0,
        vipStr: List<String>.from(json['vip_str'] ?? []),
        title: json['title'] ?? '',
        isLive: json['is_live'],
        type: json['type'] ?? -1,
        postList: json['post_list'] != null ? List<PostModel>.from(json['post_list']?.map((app) => PostModel.fromJson(app))) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'thumb': thumb,
        'name': name,
        'followNum': followNum,
        'viewNum': viewNum,
        'status': status,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'sort': sort,
        'isHot': isHot,
        'bgThumb': bgThumb,
        'postNum': postNum,
        'intro': intro,
        'pid': pid,
        'isContact': isContact,
        'isAi': isAi,
        'isFollow': isFollow,
        'isPay': isPay,
        'coins': coins,
        'tollType': tollType,
        'vipStr': vipStr,
        'title': title,
        'type': type,
        'is_live': isLive,
        'post_list': postList,
      };
}
