// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatListChatModelImpl _$$ChatListChatModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatListChatModelImpl(
      (json['id'] as num?)?.toInt(),
      (json['aff'] as num?)?.toInt(),
      json['name'] as String?,
      (json['age'] as num?)?.toInt(),
      (json['height'] as num?)?.toInt(),
      (json['weight'] as num?)?.toInt(),
      json['cup'] as String?,
      (json['pay_ct'] as num?)?.toInt(),
      (json['pay_fct'] as num?)?.toInt(),
      (json['rid'] as num?)?.toInt(),
      _mediasFromJson(json['medias']),
      $type: json['__type'] as String?,
    );

Map<String, dynamic> _$$ChatListChatModelImplToJson(
        _$ChatListChatModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'aff': instance.aff,
      'name': instance.name,
      'age': instance.age,
      'height': instance.height,
      'weight': instance.weight,
      'cup': instance.cup,
      'pay_ct': instance.payCt,
      'pay_fct': instance.payFct,
      'rid': instance.rid,
      'medias': _mediasToJson(instance.medias),
      '__type': instance.$type,
    };

_$ChatListAdModelImpl _$$ChatListAdModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatListAdModelImpl(
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
      $type: json['__type'] as String?,
    );

Map<String, dynamic> _$$ChatListAdModelImplToJson(
        _$ChatListAdModelImpl instance) =>
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
      '__type': instance.$type,
    };
