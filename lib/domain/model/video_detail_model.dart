import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/user_model.dart';

import 'home_data_model.dart';

class VideoDetailData {
  VideoDetailData({required this.detail, this.banner, this.adPops});

  final VideoData detail;
  final List<BannerModel>? banner;
  final Notice? adPops;

  factory VideoDetailData.fromJson(Map<String, dynamic> json) => VideoDetailData(
        detail: VideoData.fromJson(json['detail']),
        banner:
            json['banner'] == null ? null : List<BannerModel>.from(json['banner'].map((e) => BannerModel.fromJson(e))),
        adPops: json['ad_pops'] == null ? null : Notice.fromJson(json['ad_pops']),
      );

  Map<String, dynamic> toJson() => {
        'detail': detail.toJson(),
        'banner': banner,
        'ad_pops': adPops?.toJson(),
      };
}

class VideoData {
  VideoData(
      {this.id,
      this.memberUuid,
      this.title,
      this.mvType,
      this.isActivity,
      this.isRecommend,
      this.source240,
      this.source480,
      this.source720,
      this.source1080,
      this.vExt,
      this.duration,
      this.thumbCover,
      this.thumbWidth,
      this.thumbHeight,
      this.directors,
      this.publisher,
      this.actors,
      // this.category,
      this.tags,
      this.selfTag,
      this.tagsId,
      this.via,
      this.onshelfTm,
      this.rating,
      this.countPlay,
      this.countFavorites,
      this.countLike,
      this.countComment,
      this.countReward,
      this.countPay,
      this.incomeCoins,
      this.createdAt,
      this.refreshAt,
      this.updatedAt,
      this.callbackAt,
      this.isfree,
      this.status,
      this.thumbStartTime,
      this.thumbDuration,
      this.isHide,
      this.coins,
      this.musicId,
      this.enableBackground,
      this.enableSoundtrack,
      this.isDelete,
      this.rejectReason,
      this.rejectAt,
      this.isTop,
      this.clubId,
      this.isTester,
      this.desc,
      this.isPopular,
      this.isTiptop,
      this.userFavorites = 0,
      this.userLike,
      this.coverThumbHorizontal,
      this.coverThumbVerticle,
      this.discountCoins,
      this.discount,
      this.favorites = 0,
      this.previewUrl,
      this.member,
      this.topic,
      this.userAction,
      this.seriesId,
      this.secondTitle,
      this.videoTypeId,
      this.videoTypeName,
      this.videoContentType,
      this.recommendTraceId,
      this.videoTagKey,
      this.videoTagName,
      this.mediaId = ""});

  int? id;
  final dynamic topic;
  final dynamic userAction;
  final UserModel? member;
  final String? memberUuid;
  final String? previewUrl;
  final String? title;
  final String? secondTitle;
  final int? mvType;
  final int? isActivity;
  final int? isRecommend;
  String? source240;
  final dynamic source480;
  final dynamic source720;
  final dynamic source1080;
  final int? vExt;
  final int? duration;
  final String? thumbCover;
  final int? thumbWidth;
  final int? thumbHeight;
  final String? directors;
  final String? publisher;
  final String? actors;

  // final String? category;
  final String? tags;
  final String? selfTag;
  final String? tagsId;
  final String? via;
  final String? onshelfTm;
  final int? rating;
  final int? countPlay;
  dynamic countFavorites;
  final int? countLike;
  final int? countComment;
  final int? countReward;
  final int? countPay;
  final int? incomeCoins;
  final String? createdAt;
  final String? refreshAt;
  final String? updatedAt;
  final String? callbackAt;
  final int? isfree;
  final int? status;
  final int? thumbStartTime;
  final int? thumbDuration;
  final int? isHide;
  final int? coins;
  final int? musicId;
  final int? enableBackground;
  final int? enableSoundtrack;
  final int? isDelete;
  dynamic rejectReason;
  final int? rejectAt;
  final int? isTop;
  final int? clubId;
  final int? isTester;
  final String? desc;
  final int? isPopular;
  final int? isTiptop;
  int userFavorites;
  final int? userLike;
  final String? coverThumbHorizontal;
  final String? coverThumbVerticle;
  final int? discountCoins;
  final double? discount;
  int favorites;
  final int? seriesId;

  int? isSpeed;

  final String? videoTypeId;
  final String? videoTypeName;
  final String? videoContentType;
  final String? recommendTraceId;
  final String? videoTagKey;
  final String? videoTagName;
  final String mediaId;

  factory VideoData.fromJson(Map json) => VideoData(
      secondTitle: json['second_title'] ?? '',
      id: json['id'],
      topic: json['topic'],
      userAction: json['userAction'],
      member: json['member'] == null ? null : UserModel.fromJson(json['member']),
      memberUuid: json['member_uuid'],
      title: json['title'],
      mvType: json['mv_type'],
      isActivity: json['is_activity'],
      isRecommend: json['is_recommend'],
      source240: json['source_240'] ?? '',
      previewUrl: json['preview_url'],
      source480: json['source_480'],
      source720: json['source_720'],
      source1080: json['source_1080'],
      vExt: json['v_ext'],
      duration: json['duration'],
      thumbCover: json['thumb_cover'],
      thumbWidth: json['thumb_width'],
      thumbHeight: json['thumb_height'],
      directors: json['directors'],
      publisher: json['publisher'],
      actors: json['actors'],
      // category: json["category"] == null ? null : json["category"],
      tags: json['tags'],
      selfTag: json['self_tag'],
      tagsId: json['tags_id'],
      via: json['via'],
      onshelfTm: json['onshelf_tm'],
      rating: json['rating'],
      countPlay: json['play_ct'],
      countFavorites: json['count_favorites'],
      countLike: json['count_like'],
      countComment: json['count_comment'],
      countReward: json['count_reward'],
      countPay: json['count_pay'],
      incomeCoins: json['income_coins'],
      createdAt: json['created_at'],
      refreshAt: json['refresh_at'],
      updatedAt: json['updated_at'],
      callbackAt: json['callback_at'],
      isfree: json['isfree'],
      status: json['status'],
      thumbStartTime: json['thumb_start_time'],
      thumbDuration: json['thumb_duration'],
      isHide: json['is_hide'],
      coins: json['coins'],
      musicId: json['music_id'],
      enableBackground: json['enable_background'],
      enableSoundtrack: json['enable_soundtrack'],
      isDelete: json['is_delete'],
      rejectReason: json['reject_reason'],
      rejectAt: json['reject_at'],
      isTop: json['is_top'],
      clubId: json['club_id'],
      isTester: json['is_tester'],
      desc: json['desc'],
      isPopular: json['is_popular'],
      isTiptop: json['is_tiptop'],
      userFavorites: json['userFavorites'] ?? 0,
      userLike: json['userLike'],
      coverThumbHorizontal: json['cover_horizontal'],
      coverThumbVerticle: json['cover_vertical'],
      discountCoins: json['discount_coins'] ?? 0,
      discount: json['discount'] == null ? 0 : double.parse(json['discount'].toString()),
      favorites: json['favorites'] ?? 0,
      seriesId: int.parse(json['series_id'] ?? '0'),
      videoTypeId: json['video_type_id'],
      videoTypeName: json['video_type_name'] ?? '',
      videoContentType: json['video_content_type'],
      recommendTraceId: json['recommend_trace_id'],
      videoTagKey: json['video_tag_key'],
      videoTagName: json['video_tag_name'],
      mediaId: json['media_id'] ?? '');

  Map<String, dynamic> toJson() => {
        'second_title': secondTitle ?? '',
        'id': id,
        'pua_course': topic,
        'userAction': userAction,
        'member': member,
        'member_uuid': memberUuid,
        'title': title,
        'mv_type': mvType,
        'is_activity': isActivity,
        'is_recommend': isRecommend,
        'source_240': source240 ?? '',
        'preview_url': previewUrl,
        'source_480': source480,
        'source_720': source720,
        'source_1080': source1080,
        'v_ext': vExt,
        'duration': duration,
        'thumb_cover': thumbCover,
        'thumb_width': thumbWidth,
        'thumb_height': thumbHeight,
        'directors': directors,
        'publisher': publisher,
        'actors': actors,
        // "category": category == null ? null : category,
        'tags': tags,
        'self_tag': selfTag,
        'tags_id': tagsId,
        'via': via,
        'onshelf_tm': onshelfTm,
        'rating': rating,
        'count_play': countPlay,
        'count_favorites': countFavorites,
        'count_like': countLike,
        'count_comment': countComment,
        'count_reward': countReward,
        'count_pay': countPay,
        'income_coins': incomeCoins,
        'created_at': createdAt,
        'refresh_at': refreshAt,
        'updated_at': updatedAt,
        'callback_at': callbackAt,
        'isfree': isfree,
        'status': status,
        'thumb_start_time': thumbStartTime,
        'thumb_duration': thumbDuration,
        'is_hide': isHide,
        'coins': coins,
        'music_id': musicId,
        'enable_background': enableBackground,
        'enable_soundtrack': enableSoundtrack,
        'is_delete': isDelete,
        'reject_reason': rejectReason,
        'reject_at': rejectAt,
        'is_top': isTop,
        'club_id': clubId,
        'is_tester': isTester,
        'desc': desc,
        'is_popular': isPopular,
        'is_tiptop': isTiptop,
        'userFavorites': userFavorites,
        'userLike': userLike,
        'cover_horizontal': coverThumbHorizontal,
        'cover_vertical': coverThumbVerticle,
        'discount_coins': discountCoins ?? 0,
        'discount': discount ?? 0,
        'favorites': favorites,
        'series_id': seriesId ?? 0,
        'video_type_id': videoTypeId ?? 0,
        'video_type_name': videoTypeName ?? '',
        'video_content_type': videoContentType,
        'recommend_trace_id': recommendTraceId,
        'video_tag_key': videoTagKey,
        'video_tag_name': videoTagName,
        'mediaId': mediaId,
      };
}
