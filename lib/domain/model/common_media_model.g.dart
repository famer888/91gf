// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonMediaModel _$CommonMediaModelFromJson(Map<String, dynamic> json) =>
    CommonMediaModel(
      id: (json['id'] as num?)?.toInt(),
      aff: (json['aff'] as num?)?.toInt(),
      mediaCover: json['media_cover'] as String?,
      mediaUrl: json['media_url'] as String?,
      thumbWidth: (json['thumb_width'] as num?)?.toInt(),
      thumbHeight: (json['thumb_height'] as num?)?.toInt(),
      relatedType: (json['related_type'] as num?)?.toInt(),
      relatedId: (json['related_id'] as num?)?.toInt(),
      mediaType: (json['media_type'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$CommonMediaModelToJson(CommonMediaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'aff': instance.aff,
      'media_cover': instance.mediaCover,
      'media_url': instance.mediaUrl,
      'thumb_width': instance.thumbWidth,
      'thumb_height': instance.thumbHeight,
      'related_type': instance.relatedType,
      'related_id': instance.relatedId,
      'media_type': instance.mediaType,
      'status': instance.status,
      'duration': instance.duration,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
