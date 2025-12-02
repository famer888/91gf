import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/app_global.dart';
import 'package:jygf/domain/model/live_model.dart';

class SoulGroupWithBannersModel {
  List<GroupsModel>? groups;
  List<BannerModel>? banner;
  List<TipModel>? notice;

  SoulGroupWithBannersModel({this.groups, this.banner, this.notice});

  factory SoulGroupWithBannersModel.fromJson(Map<String, dynamic> json) =>
      SoulGroupWithBannersModel(
        groups: json['groups'] == null
            ? null
            : List<GroupsModel>.from(
                json['groups'].map((e) => GroupsModel.fromJson(e))),
        banner: json['banner'] == null
            ? null
            : List<BannerModel>.from(
                json['banner'].map((e) => BannerModel.fromJson(e))),
        notice: json['notice'] == null
            ? null
            : List<TipModel>.from(
                json['notice'].map((e) => TipModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {
        'groups': groups?.map((e) => e.toJson()).toList(),
        'banner': banner?.map((e) => e.toJson()).toList(),
        'notice': notice?.map((e) => e.toJson()).toList(),
      };
}

class GroupsModel {
  final int? id;
  final String? title;
  final String? thumb;
  final String? desc;
  int? affFCt; //加入的用户数
  int? isJoin; //是否已经加入了
  int? unreadCt; // 未读消息数
  int? isAccess; // 1: 能直接加入群聊， 0: 需要提示通过金币/vip开通
  final String? payTip;

  GroupsModel(
      {this.id,
      this.title,
      this.thumb,
      this.desc,
      this.affFCt,
      this.isJoin,
      this.unreadCt,
      this.isAccess,
      this.payTip});

  factory GroupsModel.fromJson(Map<String, dynamic> json) => GroupsModel(
        id: json['id'],
        title: json['title'],
        thumb: json['thumb'],
        desc: json['desc'],
        affFCt: json['aff_fct'] ?? 0,
        isJoin: json['is_join'] ?? 0,
        unreadCt: json['unread_ct'] ?? 0,
        isAccess: json['is_access'] ?? 0,
        payTip: json['pay_tip'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'thumb': thumb,
        'desc': desc,
        'aff_fct': affFCt,
        'is_join': isJoin,
        'unread_ct': unreadCt,
        'is_access': isAccess,
        'pay_tip': payTip,
      };
}

class SoulGroupChatMsgModel {
  final String? ms;
  final String? next;
  final List<GroupsMessageModel>? msgs;
  final GroupsMessageModel? top;

  SoulGroupChatMsgModel({this.ms, this.next, this.msgs, this.top});

  factory SoulGroupChatMsgModel.fromJson(Map<String, dynamic> json) =>
      SoulGroupChatMsgModel(
          ms: json['ms'] ?? '',
          next: json['next'] ?? '',
          msgs: json['msgs'] == null
              ? null
              : List<GroupsMessageModel>.from(
                  json['msgs'].map((e) => GroupsMessageModel.fromJson(e))),
          top: json['top'] == null
              ? null
              : GroupsMessageModel.fromJson(json['top']));

  Map<String, dynamic> toJson() => {
        'ms': ms,
        'next': next,
        'msgs': msgs?.map((e) => e.toJson()).toList(),
        'top': top?.toJson(),
      };
}

class GroupsMessageModel {
  final int? id;
  final int? groupId;
  final int? aff;
  int? type;
  final String? microsecond;
  String? msg;
  final String? createdAt;
  final String? nickname;
  final String? thumb;
  final String? uuid;
  bool? isUser; //人为控制是否是当前用户

  GroupsMessageModel({
    this.id,
    this.groupId,
    this.aff,
    this.type,
    this.microsecond,
    this.msg,
    this.createdAt,
    this.nickname,
    this.thumb,
    this.uuid,
    this.isUser = false,
  });

  factory GroupsMessageModel.fromJson(Map<String, dynamic> json) =>
      GroupsMessageModel(
        id: json['id'],
        groupId: json['group_id'],
        aff: json['aff'],
        type: json['type'],
        microsecond: json['microsecond'].toString() ?? '',
        msg: json['msg'] ?? 0,
        createdAt: json['created_at'] ?? 0,
        nickname: json['nickname'] ?? 0,
        thumb: json['thumb'] ?? 0,
        uuid: json['uuid'] ?? 0,
        isUser: AppGlobal.aff == json['aff'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'group_id': groupId,
        'aff': aff,
        'type': type,
        'microsecond': microsecond,
        'msg': msg,
        'created_at': createdAt,
        'nickname': nickname,
        'thumb': thumb,
        'uuid': uuid,
        'isUser': isUser,
      };
}

class CreativeMasterModel {
  final int? id;
  final int? aff;
  final int? workCt;
  final String? uuid;
  final String? nickname;
  final String? thumb;
  final int? isFollow;
  final int? payFct;
  final int? likeFct;
  final int? dayFct;

  CreativeMasterModel(
      {this.id,
      this.aff,
      this.workCt,
      this.uuid,
      this.nickname,
      this.thumb,
      this.isFollow,
      this.payFct,
      this.likeFct,
      this.dayFct});

  factory CreativeMasterModel.fromJson(Map<String, dynamic> json) =>
      CreativeMasterModel(
        id: json['id'],
        aff: json['aff'],
        workCt: json['work_ct'],
        uuid: json['uuid'],
        nickname: json['nickname'],
        thumb: json['thumb'],
        isFollow: json['is_follow'] ?? 0,
        payFct: json['pay_fct'] ?? 0,
        likeFct: json['like_fct'] ?? 0,
        dayFct: json['day_fct'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'aff': aff,
        'work_ct': workCt,
        'uuid': uuid,
        'nickname': nickname,
        'thumb': thumb,
        'is_follow': isFollow,
        'pay_fct': payFct,
        'like_fct': likeFct,
        'day_fct': dayFct,
      };
}
