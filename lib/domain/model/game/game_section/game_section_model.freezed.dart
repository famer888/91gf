// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_section_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GameSectionModel _$GameSectionModelFromJson(Map<String, dynamic> json) {
  switch (json['game_type']) {
    case 'game':
      return GameSectionGameModel.fromJson(json);
    case 'ad':
      return GameSectionAdModel.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'game_type', 'GameSectionModel',
          'Invalid union type "${json['game_type']}"!');
  }
}

/// @nodoc
mixin _$GameSectionModel {
  String get title => throw _privateConstructorUsedError;
  set title(String value) => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GameSectionGameModel value) game,
    required TResult Function(GameSectionAdModel value) ad,
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$GameSectionGameModelImpl implements GameSectionGameModel {
  _$GameSectionGameModelImpl(this.title, this.value, this.items,
      {final String? $type})
      : $type = $type ?? 'game';

  factory _$GameSectionGameModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameSectionGameModelImplFromJson(json);

  @override
  String title;
  @override
  String value;
  @override
  List<GameModel> items;

  @JsonKey(name: 'game_type')
  final String $type;

  @override
  String toString() {
    return 'GameSectionModel.game(title: $title, value: $value, items: $items)';
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GameSectionGameModel value) game,
    required TResult Function(GameSectionAdModel value) ad,
  }) {
    return game(this);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$GameSectionGameModelImplToJson(
      this,
    );
  }
}

abstract class GameSectionGameModel implements GameSectionModel {
  factory GameSectionGameModel(
          String title, String value, List<GameModel> items) =
      _$GameSectionGameModelImpl;

  factory GameSectionGameModel.fromJson(Map<String, dynamic> json) =
      _$GameSectionGameModelImpl.fromJson;

  @override
  String get title;
  set title(String value);
  String get value;
  set value(String value);
  List<GameModel> get items;
  set items(List<GameModel> value);
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$GameSectionAdModelImpl implements GameSectionAdModel {
  _$GameSectionAdModelImpl(
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
      {final String? $type})
      : $type = $type ?? 'ad';

  factory _$GameSectionAdModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameSectionAdModelImplFromJson(json);

  @override
  int? id;
  @override
  String title;
  @override
  String? description;
  @override
  String? imgUrl;
  @override
  String? urlConfig;
  @override
  int? position;
  @override
  String? androidDownUrl;
  @override
  String? iosDownUrl;
  @override
  int? type;
  @override
  int? status;
  @override
  int? oauthType;
  @override
  String? mvM3U8;
  @override
  String? channel;
  @override
  String? createdAt;
  @override
  String? router;
  @override
  String? startAt;
  @override
  String? endAt;
  @override
  int? clicked;
  @override
  int? sort;
  @override
  String? urlStr;
  @override
  String? linkUrl;
  @override
  String? url;
  @override
  String? resourceUrl;
  @override
  int? redirectType;
  @override
  int? reportId;
  @override
  int? reportType;

  @JsonKey(name: 'game_type')
  final String $type;

  @override
  String toString() {
    return 'GameSectionModel.ad(id: $id, title: $title, description: $description, imgUrl: $imgUrl, urlConfig: $urlConfig, position: $position, androidDownUrl: $androidDownUrl, iosDownUrl: $iosDownUrl, type: $type, status: $status, oauthType: $oauthType, mvM3U8: $mvM3U8, channel: $channel, createdAt: $createdAt, router: $router, startAt: $startAt, endAt: $endAt, clicked: $clicked, sort: $sort, urlStr: $urlStr, linkUrl: $linkUrl, url: $url, resourceUrl: $resourceUrl, redirectType: $redirectType, reportId: $reportId, reportType: $reportType)';
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GameSectionGameModel value) game,
    required TResult Function(GameSectionAdModel value) ad,
  }) {
    return ad(this);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$GameSectionAdModelImplToJson(
      this,
    );
  }
}

abstract class GameSectionAdModel implements GameSectionModel {
  factory GameSectionAdModel(
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
      int? reportType) = _$GameSectionAdModelImpl;

  factory GameSectionAdModel.fromJson(Map<String, dynamic> json) =
      _$GameSectionAdModelImpl.fromJson;

  int? get id;
  set id(int? value);
  @override
  String get title;
  set title(String value);
  String? get description;
  set description(String? value);
  String? get imgUrl;
  set imgUrl(String? value);
  String? get urlConfig;
  set urlConfig(String? value);
  int? get position;
  set position(int? value);
  String? get androidDownUrl;
  set androidDownUrl(String? value);
  String? get iosDownUrl;
  set iosDownUrl(String? value);
  int? get type;
  set type(int? value);
  int? get status;
  set status(int? value);
  int? get oauthType;
  set oauthType(int? value);
  String? get mvM3U8;
  set mvM3U8(String? value);
  String? get channel;
  set channel(String? value);
  String? get createdAt;
  set createdAt(String? value);
  String? get router;
  set router(String? value);
  String? get startAt;
  set startAt(String? value);
  String? get endAt;
  set endAt(String? value);
  int? get clicked;
  set clicked(int? value);
  int? get sort;
  set sort(int? value);
  String? get urlStr;
  set urlStr(String? value);
  String? get linkUrl;
  set linkUrl(String? value);
  String? get url;
  set url(String? value);
  String? get resourceUrl;
  set resourceUrl(String? value);
  int? get redirectType;
  set redirectType(int? value);
  int? get reportId;
  set reportId(int? value);
  int? get reportType;
  set reportType(int? value);
}
