import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jygf/domain/model/cartoon/cartoon_model.dart';
part 'cartoon_section_model.freezed.dart';
part 'cartoon_section_model.g.dart';

@Freezed(
  unionKey: 'cartoon_type',
  when: FreezedWhenOptions(when: false, whenOrNull: false, maybeWhen: false),
  map: FreezedMapOptions(maybeMap: false, mapOrNull: false, map: true),
  fromJson: true,
  toJson: true,
  copyWith: false,
  equal: false,
  makeCollectionsUnmodifiable: false,
  addImplicitFinal: false,
)
class CartoonSectionModel with _$CartoonSectionModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory CartoonSectionModel.video(
    String title,
    String value,
    List<CartoonModel> items,
  ) = CartoonSectionVideoModel;

  @JsonSerializable(fieldRename: FieldRename.snake)
  factory CartoonSectionModel.ad(
    int? id,
    String title,
    String? description,
    String? imgUrl,
    String? urlConfig,
    int? position,
    String? androidDownUrl,
    String? iosDownUrl,
    int? type,
    int? status,
    int? oauthType,
    String? mvM3U8,
    String? channel,
    String? createdAt,
    String? router,
    String? startAt,
    String? endAt,
    int? clicked,
    int? sort,
    String? urlStr,
    String? linkUrl,
    String? url,
    String? resourceUrl,
    int? redirectType,
    int? reportId,
    int? reportType,
  ) = CartoonSectionAdModel;

  factory CartoonSectionModel.fromJson(Map<String, dynamic> json) {
    if (json['url_str'] != null) {
      json['cartoon_type'] = 'ad';
    } else {
      json['cartoon_type'] = 'video';
    }
    return _$CartoonSectionModelFromJson(json);
  }
}
