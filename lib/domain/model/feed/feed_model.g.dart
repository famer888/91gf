// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeedVideoModelImpl _$$FeedVideoModelImplFromJson(Map<String, dynamic> json) =>
    _$FeedVideoModelImpl(
      (json['id'] as num).toInt(),
      (json['aff'] as num?)?.toInt(),
      json['title'] as String,
      json['tags'] as String,
      (json['isfree'] as num).toInt(),
      (json['count_play'] as num).toInt(),
      (json['count_play_fake'] as num).toInt(),
      (json['duration'] as num).toInt(),
      json['created_at'] as String,
      (json['count_comment'] as num).toInt(),
      (json['coins'] as num).toInt(),
      (json['play_ct'] as num).toInt(),
      json['refresh_at'] as String,
      json['cover_horizontal'] as String,
      json['source_origin_str'] as String?,
      (json['tag_list'] as List<dynamic>).map((e) => e as String).toList(),
      (json['is_pay'] as num).toInt(),
      (json['discount'] as num).toInt(),
      (json['discount_coins'] as num).toInt(),
      json['is_package'] as bool,
      $type: json['feed_type'] as String?,
    );

Map<String, dynamic> _$$FeedVideoModelImplToJson(
        _$FeedVideoModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'aff': instance.aff,
      'title': instance.title,
      'tags': instance.tags,
      'isfree': instance.isfree,
      'count_play': instance.countPlay,
      'count_play_fake': instance.countPlayFake,
      'duration': instance.duration,
      'created_at': instance.createdAt,
      'count_comment': instance.countComment,
      'coins': instance.coins,
      'play_ct': instance.playCt,
      'refresh_at': instance.refreshAt,
      'cover_horizontal': instance.coverHorizontal,
      'source_origin_str': instance.sourceOriginStr,
      'tag_list': instance.tagList,
      'is_pay': instance.isPay,
      'discount': instance.discount,
      'discount_coins': instance.discountCoins,
      'is_package': instance.isPackage,
      'feed_type': instance.$type,
    };

_$FeedAdModelImpl _$$FeedAdModelImplFromJson(Map<String, dynamic> json) =>
    _$FeedAdModelImpl(
      (json['id'] as num).toInt(),
      json['title'] as String,
      json['description'] as String?,
      json['img_url'] as String?,
      json['url_config'] as String,
      (json['position'] as num?)?.toInt(),
      json['android_down_url'] as String?,
      json['ios_down_url'] as String?,
      (json['type'] as num?)?.toInt(),
      (json['status'] as num?)?.toInt(),
      (json['oauth_type'] as num?)?.toInt(),
      json['mv_m3_u8'] as String?,
      json['channel'] as String?,
      json['created_at'] as String?,
      json['router'] as String,
      json['start_at'] as String?,
      json['end_at'] as String?,
      (json['clicked'] as num).toInt(),
      (json['sort'] as num).toInt(),
      json['url_str'] as String,
      json['link_url'] as String,
      json['url'] as String?,
      json['resource_url'] as String,
      (json['redirect_type'] as num).toInt(),
      (json['report_id'] as num).toInt(),
      (json['report_type'] as num).toInt(),
      json['sub_title'] as String?,
      $type: json['feed_type'] as String?,
    );

Map<String, dynamic> _$$FeedAdModelImplToJson(_$FeedAdModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'img_url': instance.imgUrl,
      'url_config': instance.urlConfig,
      'position': instance.position,
      'android_down_url': instance.androidDownUrl,
      'ios_down_url': instance.iosDownUrl,
      'type': instance.type,
      'status': instance.status,
      'oauth_type': instance.oauthType,
      'mv_m3_u8': instance.mvM3U8,
      'channel': instance.channel,
      'created_at': instance.createdAt,
      'router': instance.router,
      'start_at': instance.startAt,
      'end_at': instance.endAt,
      'clicked': instance.clicked,
      'sort': instance.sort,
      'url_str': instance.urlStr,
      'link_url': instance.linkUrl,
      'url': instance.url,
      'resource_url': instance.resourceUrl,
      'redirect_type': instance.redirectType,
      'report_id': instance.reportId,
      'report_type': instance.reportType,
      'sub_title': instance.subTitle,
      'feed_type': instance.$type,
    };
