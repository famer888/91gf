import '../user_model.dart';

class CartoonCommentListModel {
  int? id;
  int? aff;
  String? text;
  String? createdAt;
  int? likeCt;
  int? likeFct;
  int? isLike;
  UserModel? member;

  CartoonCommentListModel({
    this.id,
    this.aff,
    this.text,
    this.createdAt,
    this.likeCt,
    this.likeFct,
    this.isLike,
    this.member,
  });

  factory CartoonCommentListModel.fromJson(Map<String, dynamic> json) =>
      CartoonCommentListModel(
        id: json['id']?.toInt(),
        aff: json['aff']?.toInt(),
        text: json['text']?.toString(),
        likeCt: json['like_ct']?.toInt() ?? 0,
        likeFct: json['like_fct']?.toInt() ?? 0,
        createdAt: json['created_at']?.toString(),
        isLike: json['is_like']?.toInt(),
        member: (json['member'] != null)
            ? UserModel.fromJson(json['member'])
            : null,
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['aff'] = aff;
    data['text'] = text;
    data['like_ct'] = likeCt;
    data['like_fct'] = likeFct;
    data['created_at'] = createdAt;
    data['is_like'] = isLike;
    return data;
  }
}
