import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jygf/domain/model/common_media_model.dart';
part 'chat_list_model.freezed.dart';
part 'chat_list_model.g.dart';

@Freezed(
  unionKey: '__type',
  when: FreezedWhenOptions(when: false, whenOrNull: false, maybeWhen: false),
  map: FreezedMapOptions(maybeMap: false, mapOrNull: false, map: true),
  fromJson: true,
  toJson: true,
  copyWith: false,
  equal: false,
  makeCollectionsUnmodifiable: true,
)
class ChatListModel with _$ChatListModel {
  
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ChatListModel.chat(
    int? id,
    int? aff,
    String? name,
    int? age,
    int? height,
    int? weight,
    String? cup,
    int? payCt,
    int? payFct,
    int? rid,
    @JsonKey(fromJson: _mediasFromJson, toJson: _mediasToJson)
    List<CommonMediaModel>? medias,
  ) = ChatListChatModel;

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ChatListModel.ad(
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
  ) = ChatListAdModel;

  factory ChatListModel.fromJson(Map<String, dynamic> json) {
    if (json['url'] != null) {
      json['__type'] = 'ad';
    } else {
      json['__type'] = 'chat';
    }
    return _$ChatListModelFromJson(json);
  }
}

List<CommonMediaModel>? _mediasFromJson(Object? json) {
  if (json is List) {
    return json
        .map((e) => CommonMediaModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  return null;
}

Object? _mediasToJson(List<CommonMediaModel>? list) {
  return list?.map((e) => e.toJson()).toList();
}

// class ChatListModel {
//   final int? id;
//   final int? aff;
//   final String? name;
//   final int? age;
//   final int? height;
//   final int? weight;
//   final String? cup;
//   final int? payCt;
//   final int? payFct;
//   final int? rid;
//   final List<CommonMediaModel>? medias;

//   ChatListModel({
//     this.id,
//     this.aff,
//     this.name,
//     this.age,
//     this.height,
//     this.weight,
//     this.cup,
//     this.payCt,
//     this.payFct,
//     this.rid,
//     this.medias,
//   });

//   factory ChatListModel.fromJson(Map<String, dynamic> json) {
//     return ChatListModel(
//       id: json['id'],
//       aff: json['aff'],
//       name: json['name'],
//       age: json['age'],
//       height: json['height'],
//       weight: json['weight'],
//       cup: json['cup'],
//       payCt: json['pay_ct'],
//       payFct: json['pay_fct'],
//       rid: json['rid'],
//       medias: List.from(
//           json['medias'].map((x) => CommonMediaModel.fromJson(x)) ?? []),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'aff': aff,
//       'name': name,
//       'age': age,
//       'height': height,
//       'weight': weight,
//       'cup': cup,
//       'pay_ct': payCt,
//       'pay_fct': payFct,
//       'rid': rid,
//       'medias': (medias ?? []).map((x) => x.toJson()),
//     };
//   }
// }
