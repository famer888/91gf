// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cartoon_section_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartoonSectionVideoModelImpl _$$CartoonSectionVideoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CartoonSectionVideoModelImpl(
      json['title'] as String,
      json['value'] as String,
      (json['items'] as List<dynamic>)
          .map((e) => CartoonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      $type: json['cartoon_type'] as String?,
    );

Map<String, dynamic> _$$CartoonSectionVideoModelImplToJson(
        _$CartoonSectionVideoModelImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'value': instance.value,
      'items': instance.items,
      'cartoon_type': instance.$type,
    };

_$CartoonSectionAdModelImpl _$$CartoonSectionAdModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CartoonSectionAdModelImpl(
      (json['id'] as num?)?.toInt(),
      json['title'] as String,
      json['description'] as String?,
      json['img_url'] as String?,
      json['url_config'] as String?,
      (json['position'] as num?)?.toInt(),
      json['android_down_url'] as String?,
      json['ios_down_url'] as String?,
      (json['type'] as num?)?.toInt(),
      (json['status'] as num?)?.toInt(),
      (json['oauth_type'] as num?)?.toInt(),
      json['mv_m3_u8'] as String?,
      json['channel'] as String?,
      json['created_at'] as String?,
      json['router'] as String?,
      json['start_at'] as String?,
      json['end_at'] as String?,
      (json['clicked'] as num?)?.toInt(),
      (json['sort'] as num?)?.toInt(),
      json['url_str'] as String?,
      json['link_url'] as String?,
      json['url'] as String?,
      json['resource_url'] as String?,
      (json['redirect_type'] as num?)?.toInt(),
      (json['report_id'] as num?)?.toInt(),
      (json['report_type'] as num?)?.toInt(),
      $type: json['cartoon_type'] as String?,
    );

Map<String, dynamic> _$$CartoonSectionAdModelImplToJson(
        _$CartoonSectionAdModelImpl instance) =>
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
      'cartoon_type': instance.$type,
    };
