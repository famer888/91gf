class CreatorInfo {
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
  final int? followedCount; // 粉丝
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
  final int? sex;
  final int? usedMoneyFreeNum;
  final int? agentFee;
  final int? agent;
  final int? level;
  final int? buildId;
  final int? authStatus;
  final int? exp;
  final String? isVirtual;
  final String? chatUid;
  final dynamic phone;
  final dynamic phonePrefix;
  final int? freeViewCnt;
  final String? lastactivity;
  final int? incomeTotal;
  final int? incomeMoney;
  final int? postCount;
  final int? topicCount;
  final int? followCount; // 关注
  final String? tags;
  final String? fetish; //性癖
  final String? freeViewDate;
  final int? exemptTrial;
  final dynamic exemptTrialAt;
  final int? freeExp;
  final dynamic freeExpAt;
  final dynamic backup;
  final int? freeLotteryNum;
  final int? isFollow;
  final List<dynamic>? episodes;
  final List<String>? officialTags;
  final int? isSetPassword;
  final bool? newUser;
  final List<dynamic>? tagList;
  final String? vipStr;
  String? contact;
  int? hasContact;
  final String? intro;
  final String? likeFct;
  final String? payTip;
  final String? vipIcon;
  final String? vipImg;

  CreatorInfo({
    this.likeFct,
    this.intro,
    this.contact,
    this.hasContact,
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
    this.fetish,
    this.freeViewDate,
    this.exemptTrial,
    this.exemptTrialAt,
    this.freeExp,
    this.freeExpAt,
    this.backup,
    this.freeLotteryNum,
    this.isFollow,
    this.episodes,
    this.officialTags,
    this.isSetPassword,
    this.newUser,
    this.tagList,
    this.vipStr,
    this.sex,
    this.payTip,
    this.vipIcon,
    this.vipImg,
  });

  CreatorInfo.fromJson(Map<String, dynamic> json)
      : hasContact = json['has_contact'] as int?,
        contact = json['contact'] as String?,
        payTip = json['pay_tip'] as String?,
        likeFct = json['like_fct'].toString() as String?,
        intro = json['intro'] as String?,
        uid = json['uid'] as int?,
        uuid = json['uuid'] as String?,
        username = json['username'] as String?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        roleId = json['role_id'] as int?,
        gender = json['gender'] as int?,
        regip = json['regip'] as String?,
        regdate = json['regdate'] as String?,
        lastip = json['lastip'] as String?,
        expiredAt = json['expired_at'] as String?,
        lastpost = json['lastpost'] as int?,
        oltime = json['oltime'] as int?,
        pageviews = json['pageviews'] as int?,
        score = json['score'] as int?,
        aff = json['aff'] as int?,
        channel = json['channel'] as String?,
        invitedBy = json['invited_by'] as int?,
        invitedNum = json['invited_num'] as int?,
        banPost = json['ban_post'] as int?,
        postNum = json['post_num'] as int?,
        loginCount = json['login_count'] as int?,
        appVersion = json['app_version'] as String?,
        validate = json['validate'] as int?,
        share = json['share'] as int?,
        isLogin = json['is_login'] as int?,
        nickname = json['nickname'] as String?,
        thumb = json['thumb'] as String?,
        coins = json['coins'] as int?,
        money = json['money'] as int?,
        proxyMoney = json['proxy_money'] as String?,
        tempVip = json['temp_vip'] as int?,
        followedCount = json['followed_count'] as int?,
        videosCount = json['videos_count'] as int?,
        fabulousCount = json['fabulous_count'] as int?,
        likesCount = json['likes_count'] as int?,
        commentCount = json['comment_count'] as int?,
        vipLevel = json['vip_level'] as int?,
        personSignnatrue = json['person_signnatrue'] as String?,
        oldVip = json['old_vip'] as int?,
        stature = json['stature'] as int?,
        interest = json['interest'] as String?,
        city = json['city'] as String?,
        sex = json['sex'] as int?,
        usedMoneyFreeNum = json['used_money_free_num'] as int?,
        agentFee = json['agent_fee'] as int?,
        agent = json['agent'] as int?,
        level = json['level'] as int?,
        buildId = json['build_id'] as int?,
        authStatus = json['auth_status'] as int?,
        exp = json['exp'] as int?,
        isVirtual = json['is_virtual'] as String?,
        chatUid = json['chat_uid'] as String?,
        phone = json['phone'],
        phonePrefix = json['phone_prefix'],
        freeViewCnt = json['free_view_cnt'] as int?,
        lastactivity = json['lastactivity'] as String?,
        incomeTotal = json['income_total'] as int?,
        incomeMoney = json['income_money'] as int?,
        postCount = json['post_count'] as int?,
        topicCount = json['topic_count'] as int?,
        followCount = json['follow_count'] as int?,
        tags = json['tags'] as String?,
        fetish = json['fetish'] as String?,
        freeViewDate = json['free_view_date'] as String?,
        exemptTrial = json['exempt_trial'] as int?,
        exemptTrialAt = json['exempt_trial_at'],
        freeExp = json['free_exp'] as int?,
        freeExpAt = json['free_exp_at'],
        backup = json['backup'],
        freeLotteryNum = json['free_lottery_num'] as int?,
        isFollow = json['is_follow'] as int?,
        episodes = json['episodes'] as List?,
        officialTags = (json['official_tags'] as List?)
            ?.map((dynamic e) => e as String)
            .toList(),
        isSetPassword = json['is_set_password'] as int?,
        newUser = json['new_user'] as bool?,
        tagList = json['tag_list'] as List?,
        vipStr = json['vip_str'] as String?,
        vipIcon = json['vip_icon'] as String?,
        vipImg = json['vip_img'] as String?;

  Map<String, dynamic> toJson() => {
        'intro': intro,
        'pay_tip': payTip,
        'like_fct': likeFct,
        'has_contact': hasContact,
        'contact': contact,
        'uid': uid,
        'uuid': uuid,
        'username': username,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'role_id': roleId,
        'gender': gender,
        'regip': regip,
        'regdate': regdate,
        'lastip': lastip,
        'expired_at': expiredAt,
        'lastpost': lastpost,
        'oltime': oltime,
        'pageviews': pageviews,
        'score': score,
        'aff': aff,
        'channel': channel,
        'invited_by': invitedBy,
        'invited_num': invitedNum,
        'ban_post': banPost,
        'post_num': postNum,
        'login_count': loginCount,
        'app_version': appVersion,
        'validate': validate,
        'share': share,
        'is_login': isLogin,
        'nickname': nickname,
        'thumb': thumb,
        'coins': coins,
        'money': money,
        'proxy_money': proxyMoney,
        'temp_vip': tempVip,
        'followed_count': followedCount,
        'videos_count': videosCount,
        'fabulous_count': fabulousCount,
        'likes_count': likesCount,
        'comment_count': commentCount,
        'vip_level': vipLevel,
        'person_signnatrue': personSignnatrue,
        'old_vip': oldVip,
        'stature': stature,
        'interest': interest,
        'city': city,
        'sex': sex,
        'used_money_free_num': usedMoneyFreeNum,
        'agent_fee': agentFee,
        'agent': agent,
        'level': level,
        'build_id': buildId,
        'auth_status': authStatus,
        'exp': exp,
        'is_virtual': isVirtual,
        'chat_uid': chatUid,
        'phone': phone,
        'phone_prefix': phonePrefix,
        'free_view_cnt': freeViewCnt,
        'lastactivity': lastactivity,
        'income_total': incomeTotal,
        'income_money': incomeMoney,
        'post_count': postCount,
        'topic_count': topicCount,
        'follow_count': followCount,
        'tags': tags,
        'fetish': fetish,
        'free_view_date': freeViewDate,
        'exempt_trial': exemptTrial,
        'exempt_trial_at': exemptTrialAt,
        'free_exp': freeExp,
        'free_exp_at': freeExpAt,
        'backup': backup,
        'free_lottery_num': freeLotteryNum,
        'is_follow': isFollow,
        'episodes': episodes,
        'official_tags': officialTags,
        'is_set_password': isSetPassword,
        'new_user': newUser,
        'tag_list': tagList,
        'vip_str': vipStr,
        'vip_icon': vipIcon,
        'vip_img': vipImg,
      };
}
