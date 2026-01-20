class UserModel {
  final int? uid;
  final String? uuid;
  final String? username;
  final String? createdAt;
  final String? updatedAt;
  final int? roleId;
  final int? gender;
  final String? regip;
  final String? regdate;
  final String? lastip;
  final String? expiredAt;
  final int? lastpost;
  final int? oltime;
  final int? pageviews;
  final int? score;
  final int? aff;
  final String? channel;
  final int? invitedBy;
  final int? invitedNum;
  final int? banPost;
  final int? postNum;
  final int? loginCount;
  final String? appVersion;
  final int? validate;
  final int? share;
  final int? isLogin;
  final String? nickname;
  final String? thumb;
  final int? coins;
  final int? money;
  final String? proxyMoney;
  final int? tempVip;
  final int? followedCount;
  final int? videosCount;
  final int? fabulousCount;
  final int? likesCount;
  final int? commentCount;
  final int? vipLevel;
  final String? personSignnatrue;
  final int? oldVip;
  final int? stature;
  final String? interest;
  final String? city;
  final int? usedMoneyFreeNum;
  final int? agentFee;
  final int? agent;
  final int? level;
  final int? buildId;
  final int? authStatus;
  final int? exp;
  final String? isVirtual;
  final String? chatUid;
  final String? phone;
  final String? phonePrefix;
  final int? freeViewCnt;
  final String? lastactivity;
  final int? incomeTotal;
  final int? incomeMoney;
  final int? postCount;
  final int? topicCount;
  final int? followCount;
  final String? tags;
  final DateTime? freeViewDate;
  final int? exemptTrial;
  final String? exemptTrialAt;
  final int? freeExp;
  final String? freeExpAt;
  final dynamic backup;
  final int? freeLotteryNum;
  int? isFollow;
  final int? isSetPassword;
  final bool? newUser;
  final List<dynamic>? tagList;
  final String? vipStr;
  final String? vipIcon;
  final String? vipImg;
  final int? workCt;
  final int? fansCt;
  final int? chatPrivilege;

  UserModel({
    this.workCt,
    this.fansCt,
    this.uid,
    this.uuid,
    this.username,
    this.createdAt,
    this.updatedAt,
    this.roleId,
    this.gender,
    this.regip,
    this.regdate,
    this.lastip,
    this.expiredAt,
    this.lastpost,
    this.oltime,
    this.pageviews,
    this.score,
    this.aff,
    this.channel,
    this.invitedBy,
    this.invitedNum,
    this.banPost,
    this.postNum,
    this.loginCount,
    this.appVersion,
    this.validate,
    this.share,
    this.isLogin,
    this.nickname,
    this.thumb,
    this.coins,
    this.money,
    this.proxyMoney,
    this.tempVip,
    this.followedCount,
    this.videosCount,
    this.fabulousCount,
    this.likesCount,
    this.commentCount,
    this.vipLevel,
    this.personSignnatrue,
    this.oldVip,
    this.stature,
    this.interest,
    this.city,
    this.usedMoneyFreeNum,
    this.agentFee,
    this.agent,
    this.level,
    this.buildId,
    this.authStatus,
    this.exp,
    this.isVirtual,
    this.chatUid,
    this.phone,
    this.phonePrefix,
    this.freeViewCnt,
    this.lastactivity,
    this.incomeTotal,
    this.incomeMoney,
    this.postCount,
    this.topicCount,
    this.followCount,
    this.tags,
    this.freeViewDate,
    this.exemptTrial,
    this.exemptTrialAt,
    this.freeExp,
    this.freeExpAt,
    this.backup,
    this.freeLotteryNum,
    this.isFollow,
    this.isSetPassword,
    this.newUser,
    this.tagList,
    this.vipStr,
    this.vipIcon,
    this.vipImg,
    this.chatPrivilege,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        fansCt: json['fans_ct'],
        workCt: json['work_ct'],
        uid: json['uid'],
        uuid: json['uuid'],
        username: json['username'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        roleId: json['role_id'],
        gender: json['gender'],
        regip: json['regip'],
        regdate: json['regdate'],
        lastip: json['lastip'],
        expiredAt: json['expired_at'],
        lastpost: json['lastpost'],
        oltime: json['oltime'],
        pageviews: json['pageviews'],
        score: json['score'],
        aff: json['aff'],
        channel: json['channel'],
        invitedBy: json['invited_by'],
        invitedNum: json['invited_num'],
        banPost: json['ban_post'],
        postNum: json['post_num'],
        loginCount: json['login_count'],
        appVersion: json['app_version'],
        validate: json['validate'],
        share: json['share'],
        isLogin: json['is_login'],
        nickname: json['nickname'],
        thumb: json['thumb'],
        coins: json['coins'],
        money: json['money'],
        proxyMoney: json['proxy_money'],
        tempVip: json['temp_vip'],
        followedCount: json['followed_count'],
        videosCount: json['videos_count'],
        fabulousCount: json['fabulous_count'],
        likesCount: json['likes_count'],
        commentCount: json['comment_count'],
        vipLevel: json['vip_level'],
        personSignnatrue: json['person_signnatrue'],
        oldVip: json['old_vip'],
        stature: json['stature'],
        interest: json['interest'],
        city: json['city'],
        usedMoneyFreeNum: json['used_money_free_num'],
        agentFee: json['agent_fee'],
        agent: json['agent'],
        level: json['level'],
        buildId: json['build_id'],
        authStatus: json['auth_status'],
        exp: json['exp'],
        isVirtual: json['is_virtual'],
        chatUid: json['chat_uid'],
        phone: json['phone'],
        phonePrefix: json['phone_prefix'],
        freeViewCnt: json['free_view_cnt'],
        lastactivity: json['lastactivity'],
        incomeTotal: json['income_total'],
        incomeMoney: json['income_money'],
        postCount: json['post_count'],
        topicCount: json['topic_count'],
        followCount: json['follow_count'],
        tags: json['tags'],
        freeViewDate: json['free_view_date'] == null
            ? null
            : DateTime.tryParse(json['free_view_date']),
        exemptTrial: json['exempt_trial'],
        exemptTrialAt: json['exempt_trial_at'],
        freeExp: json['free_exp'],
        freeExpAt: json['free_exp_at'],
        backup: json['backup'],
        freeLotteryNum: json['free_lottery_num'],
        isFollow: json['is_follow'],
        isSetPassword: json['is_set_password'],
        newUser: json['new_user'],
        tagList: json['tag_list'] == null
            ? []
            : List<dynamic>.from(json['tag_list']!.map((x) => x)),
        vipStr: json['vip_str'],
        vipIcon: json['vip_icon'] ?? '',
        vipImg: json['vip_img'] ?? '',
        chatPrivilege: json['chat_privilege'],
      );
}
