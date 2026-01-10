class FollowUser {
  int id;
  String title;
  int topicId;
  String aff;
  int viewNum;
  int commentNum;
  int likeNum;
  User? user;
  Topic? topic;
  List<Media>? medias;

  FollowUser({
    this.id = 0,
    this.title = '',
    this.topicId = 0,
    this.aff = '',
    this.viewNum = 0,
    this.commentNum = 0,
    this.likeNum = 0,
    this.user,
    this.topic,
    this.medias,
  });

  factory FollowUser.fromJson(Map<String, dynamic> json) => FollowUser(
    id: json['id'] ?? 0,
    title: json['title'] ?? '',
    topicId: json['topic_id'] ?? 0,
    aff: json['aff'] ?? '',
    viewNum: json['view_num'] ?? 0,
    commentNum: json['comment_num'] ?? 0,
    likeNum: json['like_num'] ?? 0,
    user: json['user'] != null ? User.fromJson(json['user']) : null,
    topic: json['topic'] != null ? Topic.fromJson(json['topic']) : null,
    medias: json['medias'] != null ? List<Media>.from(json['medias']?.map((app) => Media.fromJson(app))) : [],
  );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'topic_id': topicId,
        'aff': aff,
        'view_num': viewNum,
        'comment_num': commentNum,
        'like_num': likeNum,
        'user': user?.toJson(),
        'topic': topic?.toJson(),
        'medias': medias?.map((app) => app.toJson()).toList(),
      };
}

class User {
  int aff;
  String nickname;
  String thumb;
  int vipLevel;
  int isSetPassword;
  bool newUser;
  int isFollow;
  List<String> tagList;
  String vipStr;

  User({
    this.aff = 0,
    this.nickname = '',
    this.thumb = '',
    this.vipLevel = 0,
    this.isSetPassword = 0,
    this.newUser = false,
    this.isFollow = 0,
    this.tagList = const [],
    this.vipStr = '',
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        aff: json['aff'] ?? 0,
        nickname: json['nickname'] ?? '',
        thumb: json['thumb'] ?? '',
        vipLevel: json['vip_level'] ?? 0,
        isSetPassword: json['is_set_password'] ?? 0,
        newUser: json['new_user'] ?? false,
        isFollow: json['is_follow'] ?? 0,
        tagList: json['tag_list'] != null ? List<String>.from(json['tag_list']) : [],
        vipStr: json['vip_str'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'aff': aff,
        'nickname': nickname,
        'thumb': thumb,
        'vip_level': vipLevel,
        'is_set_password': isSetPassword,
        'new_user': newUser,
        'is_follow': isFollow,
        'tag_list': tagList,
        'vip_str': vipStr,
      };
}

class Topic {
  int id;
  String name;
  int isFollow;

  Topic({
    this.id = 0,
    this.name = '',
    this.isFollow = 0,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        isFollow: json['is_follow'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'is_follow': isFollow,
      };
}

class Media {
  String cover;
  int thumbWidth;
  int thumbHeight;
  int pid;
  int type;
  String mediaUrl;

  Media({
    this.cover = '',
    this.thumbWidth = 0,
    this.thumbHeight = 0,
    this.pid = 0,
    this.type = 0,
    this.mediaUrl = '',
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        cover: json['cover'] ?? '',
        thumbWidth: json['thumb_width'] ?? 0,
        thumbHeight: json['thumb_height'] ?? 0,
        pid: json['pid'] ?? 0,
        type: json['type'] ?? 0,
        mediaUrl: json['media_url'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'cover': cover,
        'thumb_width': thumbWidth,
        'thumb_height': thumbHeight,
        'pid': pid,
        'type': type,
        'media_url': mediaUrl,
      };
}
