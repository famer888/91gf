class MineIncomeDetailData {
  final List<MineIncomeDetail>? list;
  final String? lastIx;

  MineIncomeDetailData({this.list, this.lastIx});

  factory MineIncomeDetailData.fromJson(Map<String, dynamic> json) {
    return MineIncomeDetailData(
        list: List.from(json['list'].map((e) => MineIncomeDetail.fromJson(e))),
        lastIx: json['last_ix']);
  }
}

class MineIncomeDetail {
  final int? id;
  final int? aff;
  final int? source;
  final int? type;
  final String? coinCnt;
  final String? desc;
  final int? sourceAff;
  final String? createdAt;
  final String? dataName;
  final int? dataId;
  final String? nickname;
  final String? title;
  final SourceMember? sourceMember;

  MineIncomeDetail(
      {this.id,
      this.aff,
      this.source,
      this.type,
      this.coinCnt,
      this.desc,
      this.sourceAff,
      this.createdAt,
      this.dataName,
      this.dataId,
      this.nickname,
      this.title,
      this.sourceMember});

  factory MineIncomeDetail.fromJson(Map<String, dynamic> json) {
    return MineIncomeDetail(
        id: json['id'],
        aff: json['aff'],
        source: json['source'],
        type: json['type'],
        coinCnt: json['coinCnt'],
        desc: json['desc'],
        sourceAff: json['source_aff'],
        createdAt: json['created_at'],
        dataName: json['data_name'],
        dataId: json['data_id'],
        nickname: json['nickname'],
        title: json['title'],
        sourceMember: json['source_member'] != null
            ? SourceMember.fromJson(json['source_member'])
            : null);
  }
}

class SourceMember {
  final int? uid;
  final int? aff;
  final String? nickname;
  final int? isSetPassword;
  final bool? newUser;
  final int? isFollow;
  final List<dynamic>? tagList;
  final String? vipStr;

  SourceMember(
      {this.uid,
      this.aff,
      this.nickname,
      this.isSetPassword,
      this.newUser,
      this.isFollow,
      this.tagList,
      this.vipStr});

  factory SourceMember.fromJson(Map<String, dynamic> json) {
    return SourceMember(
        uid: json['uid'],
        aff: json['aff'],
        nickname: json['nickname'],
        isSetPassword: json['is_set_password'],
        newUser: json['new_user'],
        isFollow: json['is_follow'],
        tagList: json['tag_list'],
        vipStr: json['vip_str']);
  }
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'aff': aff,
        'nickname': nickname,
        'is_set_password': isSetPassword,
        'new_user': newUser,
        'is_follow': isFollow,
        'tag_list': tagList,
        'vip_str': vipStr,
      };
}
