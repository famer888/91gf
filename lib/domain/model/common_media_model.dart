import 'package:json_annotation/json_annotation.dart';

part 'common_media_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CommonMediaModel {
  final int? id;
  final int? aff;
  final String? mediaCover;
  final String? mediaUrl;
  final int? thumbWidth;
  final int? thumbHeight;
  final int? relatedType;
  final int? relatedId;
  final int? mediaType;
  final int? status;
  final int? duration;
  final String? createdAt;
  final String? updatedAt;

  CommonMediaModel(
      {this.id,
      this.aff,
      this.mediaCover,
      this.mediaUrl,
      this.thumbWidth,
      this.thumbHeight,
      this.relatedType,
      this.relatedId,
      this.mediaType,
      this.status,
      this.duration,
      this.createdAt,
      this.updatedAt});

  factory CommonMediaModel.fromJson(Map<String, dynamic> json) =>
      _$CommonMediaModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommonMediaModelToJson(this);
}
