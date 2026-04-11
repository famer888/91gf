import 'package:freezed_annotation/freezed_annotation.dart';
part 'feed_model.freezed.dart';
part 'feed_model.g.dart';

@Freezed(
  unionKey: 'feed_type',
  when: FreezedWhenOptions(when: false, whenOrNull: false, maybeWhen: false),
  map: FreezedMapOptions(maybeMap: false, mapOrNull: false, map: true),
  fromJson: true,
  toJson: true,
  copyWith: false,
  equal: false,
  makeCollectionsUnmodifiable: true,
)
class FeedModel with _$FeedModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory FeedModel.video(
    int id,
    int? aff,
    String title,
    String tags,
    int isfree,
    int countPlay,
    int countPlayFake,
    int duration,
    String createdAt,
    int countComment,
    int coins,
    int playCt,
    String refreshAt,
    String coverHorizontal,
    String? sourceOriginStr,
    List<String> tagList,
    int isPay,
    int discount,
    int discountCoins,
    bool isPackage,
  ) = FeedVideoModel;

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory FeedModel.ad(
    int id,
    String title,
    String? description,
    String? imgUrl,
    String urlConfig,
    int? position,
    String? androidDownUrl,
    String? iosDownUrl,
    int? type,
    int? status,
    int? oauthType,
    String? mvM3U8,
    String? channel,
    String? createdAt,
    String router,
    String? startAt,
    String? endAt,
    int clicked,
    int sort,
    String urlStr,
    String linkUrl,
    String? url,
    String resourceUrl,
    int redirectType,
    int reportId,
    int reportType,
    String? subTitle,
    String? adType,
    String? adSlotName,
    String? advertiseCode,
    String? advertiseLocationCode,
  ) = FeedAdModel;

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    if (json['url'] != null) {
      json['feed_type'] = 'ad';
    } else {
      json['feed_type'] = 'video';
    }
    return _$FeedModelFromJson(json);
  }
}
