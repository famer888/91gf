import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jygf/domain/model/game/game_model.dart';
part 'game_section_model.freezed.dart';
part 'game_section_model.g.dart';

@Freezed(
  unionKey: 'game_type',
  when: FreezedWhenOptions(when: false, whenOrNull: false, maybeWhen: false),
  map: FreezedMapOptions(maybeMap: false, mapOrNull: false, map: true),
  fromJson: true,
  toJson: true,
  copyWith: false,
  equal: false,
  makeCollectionsUnmodifiable: false,
  addImplicitFinal: false,
)
class GameSectionModel with _$GameSectionModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory GameSectionModel.game(
    String title,
    String value,
    List<GameModel> items,
  ) = GameSectionGameModel;

  @JsonSerializable(fieldRename: FieldRename.snake)
  factory GameSectionModel.ad(
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
  ) = GameSectionAdModel;

  factory GameSectionModel.fromJson(Map<String, dynamic> json) {
    if (json['url_str'] != null) {
      json['game_type'] = 'ad';
    } else {
      json['game_type'] = 'game';
    }
    return _$GameSectionModelFromJson(json);
  }
}
