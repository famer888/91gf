// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FeedModel _$FeedModelFromJson(Map<String, dynamic> json) {
  switch (json['feed_type']) {
    case 'video':
      return FeedVideoModel.fromJson(json);
    case 'ad':
      return FeedAdModel.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'feed_type', 'FeedModel',
          'Invalid union type "${json['feed_type']}"!');
  }
}

/// @nodoc
mixin _$FeedModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FeedVideoModel value) video,
    required TResult Function(FeedAdModel value) ad,
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$FeedVideoModelImpl implements FeedVideoModel {
  const _$FeedVideoModelImpl(
      this.id,
      this.aff,
      this.title,
      this.tags,
      this.isfree,
      this.countPlay,
      this.countPlayFake,
      this.duration,
      this.createdAt,
      this.countComment,
      this.coins,
      this.playCt,
      this.refreshAt,
      this.coverHorizontal,
      this.sourceOriginStr,
      final List<String> tagList,
      this.isPay,
      this.discount,
      this.discountCoins,
      this.isPackage,
      {final String? $type})
      : _tagList = tagList,
        $type = $type ?? 'video';

  factory _$FeedVideoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedVideoModelImplFromJson(json);

  @override
  final int id;
  @override
  final int? aff;
  @override
  final String title;
  @override
  final String tags;
  @override
  final int isfree;
  @override
  final int countPlay;
  @override
  final int countPlayFake;
  @override
  final int duration;
  @override
  final String createdAt;
  @override
  final int countComment;
  @override
  final int coins;
  @override
  final int playCt;
  @override
  final String refreshAt;
  @override
  final String coverHorizontal;
  @override
  final String? sourceOriginStr;
  final List<String> _tagList;
  @override
  List<String> get tagList {
    if (_tagList is EqualUnmodifiableListView) return _tagList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tagList);
  }

  @override
  final int isPay;
  @override
  final int discount;
  @override
  final int discountCoins;
  @override
  final bool isPackage;

  @JsonKey(name: 'feed_type')
  final String $type;

  @override
  String toString() {
    return 'FeedModel.video(id: $id, aff: $aff, title: $title, tags: $tags, isfree: $isfree, countPlay: $countPlay, countPlayFake: $countPlayFake, duration: $duration, createdAt: $createdAt, countComment: $countComment, coins: $coins, playCt: $playCt, refreshAt: $refreshAt, coverHorizontal: $coverHorizontal, sourceOriginStr: $sourceOriginStr, tagList: $tagList, isPay: $isPay, discount: $discount, discountCoins: $discountCoins, isPackage: $isPackage)';
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FeedVideoModel value) video,
    required TResult Function(FeedAdModel value) ad,
  }) {
    return video(this);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedVideoModelImplToJson(
      this,
    );
  }
}

abstract class FeedVideoModel implements FeedModel {
  const factory FeedVideoModel(
      final int id,
      final int? aff,
      final String title,
      final String tags,
      final int isfree,
      final int countPlay,
      final int countPlayFake,
      final int duration,
      final String createdAt,
      final int countComment,
      final int coins,
      final int playCt,
      final String refreshAt,
      final String coverHorizontal,
      final String? sourceOriginStr,
      final List<String> tagList,
      final int isPay,
      final int discount,
      final int discountCoins,
      final bool isPackage) = _$FeedVideoModelImpl;

  factory FeedVideoModel.fromJson(Map<String, dynamic> json) =
      _$FeedVideoModelImpl.fromJson;

  @override
  int get id;
  int? get aff;
  @override
  String get title;
  String get tags;
  int get isfree;
  int get countPlay;
  int get countPlayFake;
  int get duration;
  @override
  String get createdAt;
  int get countComment;
  int get coins;
  int get playCt;
  String get refreshAt;
  String get coverHorizontal;
  String? get sourceOriginStr;
  List<String> get tagList;
  int get isPay;
  int get discount;
  int get discountCoins;
  bool get isPackage;
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$FeedAdModelImpl implements FeedAdModel {
  const _$FeedAdModelImpl(
      this.id,
      this.title,
      this.description,
      this.imgUrl,
      this.urlConfig,
      this.position,
      this.androidDownUrl,
      this.iosDownUrl,
      this.type,
      this.status,
      this.oauthType,
      this.mvM3U8,
      this.channel,
      this.createdAt,
      this.router,
      this.startAt,
      this.endAt,
      this.clicked,
      this.sort,
      this.urlStr,
      this.linkUrl,
      this.url,
      this.resourceUrl,
      this.redirectType,
      this.reportId,
      this.reportType,
      this.subTitle,
      this.adType,
      this.adSlotName,
      this.advertiseCode,
      this.advertiseLocationCode,
      {final String? $type})
      : $type = $type ?? 'ad';

  factory _$FeedAdModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedAdModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? imgUrl;
  @override
  final String urlConfig;
  @override
  final int? position;
  @override
  final String? androidDownUrl;
  @override
  final String? iosDownUrl;
  @override
  final int? type;
  @override
  final int? status;
  @override
  final int? oauthType;
  @override
  final String? mvM3U8;
  @override
  final String? channel;
  @override
  final String? createdAt;
  @override
  final String router;
  @override
  final String? startAt;
  @override
  final String? endAt;
  @override
  final int clicked;
  @override
  final int sort;
  @override
  final String urlStr;
  @override
  final String linkUrl;
  @override
  final String? url;
  @override
  final String resourceUrl;
  @override
  final int redirectType;
  @override
  final int reportId;
  @override
  final int reportType;
  @override
  final String? subTitle;
  @override
  final int? adType;
  @override
  final String? adSlotName;
  @override
  final String? advertiseCode;
  @override
  final String? advertiseLocationCode;

  @JsonKey(name: 'feed_type')
  final String $type;

  @override
  String toString() {
    return 'FeedModel.ad(id: $id, title: $title, description: $description, imgUrl: $imgUrl, urlConfig: $urlConfig, position: $position, androidDownUrl: $androidDownUrl, iosDownUrl: $iosDownUrl, type: $type, status: $status, oauthType: $oauthType, mvM3U8: $mvM3U8, channel: $channel, createdAt: $createdAt, router: $router, startAt: $startAt, endAt: $endAt, clicked: $clicked, sort: $sort, urlStr: $urlStr, linkUrl: $linkUrl, url: $url, resourceUrl: $resourceUrl, redirectType: $redirectType, reportId: $reportId, reportType: $reportType, subTitle: $subTitle, adType: $adType, adSlotName: $adSlotName, advertiseCode: $advertiseCode, advertiseLocationCode: $advertiseLocationCode)';
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FeedVideoModel value) video,
    required TResult Function(FeedAdModel value) ad,
  }) {
    return ad(this);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedAdModelImplToJson(
      this,
    );
  }
}

abstract class FeedAdModel implements FeedModel {
  const factory FeedAdModel(
      final int id,
      final String title,
      final String? description,
      final String? imgUrl,
      final String urlConfig,
      final int? position,
      final String? androidDownUrl,
      final String? iosDownUrl,
      final int? type,
      final int? status,
      final int? oauthType,
      final String? mvM3U8,
      final String? channel,
      final String? createdAt,
      final String router,
      final String? startAt,
      final String? endAt,
      final int clicked,
      final int sort,
      final String urlStr,
      final String linkUrl,
      final String? url,
      final String resourceUrl,
      final int redirectType,
      final int reportId,
      final int reportType,
      final String? subTitle,
      final int? adType,
      final String? adSlotName,
      final String? advertiseCode,
      final String? advertiseLocationCode) = _$FeedAdModelImpl;

  factory FeedAdModel.fromJson(Map<String, dynamic> json) =
      _$FeedAdModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  String? get description;
  String? get imgUrl;
  String get urlConfig;
  int? get position;
  String? get androidDownUrl;
  String? get iosDownUrl;
  int? get type;
  int? get status;
  int? get oauthType;
  String? get mvM3U8;
  String? get channel;
  @override
  String? get createdAt;
  String get router;
  String? get startAt;
  String? get endAt;
  int get clicked;
  int get sort;
  String get urlStr;
  String get linkUrl;
  String? get url;
  String get resourceUrl;
  int get redirectType;
  int get reportId;
  int get reportType;
  String? get subTitle;
  int? get adType;
  String? get adSlotName;
  String? get advertiseCode;
  String? get advertiseLocationCode;
}
