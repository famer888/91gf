import 'package:jygf/domain/model/common_media_model.dart';

class ChatDetailModel {
  final String? tip;
  ChatInfoModel? chat;

  ChatDetailModel({
    this.tip,
    this.chat,
  });

  factory ChatDetailModel.fromJson(Map<String, dynamic> json) {
    return ChatDetailModel(
      tip: json['tip'],
      chat: ChatInfoModel.fromJson(json['chat']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tip': tip,
      'chat': chat?.toJson(),
    };
  }
}

class ChatInfoModel {
  final int? id;
  final int? aff;
  final String? name;
  final int? age;
  final int? height;
  final int? weight;
  final String? option;
  final String? time;
  final String? price;
  final String? cup;
  String? contact;
  final String? intro;
  final int? photoCt;
  final int? videoCt;
  final int? type;
  final int? coins;
  final int? payCt;
  final int? payFct;
  final int? viewFct;
  int? favoriteFct;
  final int? likeCt;
  final int? likeFct;
  int? isFavorite;
  final int? isLike;
  final List<CommonMediaModel>? medias;

  ChatInfoModel({
    this.id,
    this.aff,
    this.name,
    this.age,
    this.height,
    this.weight,
    this.option,
    this.time,
    this.price,
    this.cup,
    this.contact,
    this.intro,
    this.photoCt,
    this.videoCt,
    this.type,
    this.coins,
    this.payCt,
    this.payFct,
    this.viewFct,
    this.favoriteFct,
    this.likeCt,
    this.likeFct,
    this.isFavorite,
    this.isLike,
    this.medias,
  });

  factory ChatInfoModel.fromJson(Map<String, dynamic> json) {
    return ChatInfoModel(
      id: json['id'],
      aff: json['aff'],
      name: json['name'],
      age: json['age'],
      height: json['height'],
      weight: json['weight'],
      option: json['option'],
      time: json['time'],
      price: json['price'],
      cup: json['cup'],
      contact: json['contact'],
      intro: json['intro'],
      photoCt: json['photo_ct'],
      videoCt: json['video_ct'],
      type: json['type'],
      coins: json['coins'],
      payCt: json['pay_ct'],
      payFct: json['pay_fct'],
      viewFct: json['view_fct'],
      favoriteFct: json['favorite_fct'],
      likeCt: json['like_ct'],
      likeFct: json['like_fct'],
      isFavorite: json['is_favorite'],
      isLike: json['is_like'],
      medias: List.from(
          json['medias'].map((x) => CommonMediaModel.fromJson(x)) ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aff': aff,
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'option': option,
      'time': time,
      'price': price,
      'cup': cup,
      'contact': contact,
      'intro': intro,
      'photo_ct': photoCt,
      'video_ct': videoCt,
      'type': type,
      'coins': coins,
      'pay_ct': payCt,
      'pay_fct': payFct,
      'view_fct': viewFct,
      'favorite_fct': favoriteFct,
      'like_ct': likeCt,
      'like_fct': likeFct,
      'is_favorite': isFavorite,
      'is_like': isLike,
      'medias': (medias ?? []).map((x) => x.toJson()),
    };
  }
}
