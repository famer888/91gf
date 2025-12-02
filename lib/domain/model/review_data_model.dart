import 'media_model.dart';
import 'user_model.dart';

class ReviewData {
  final int? id;
  final int? postId;
  final int? pid;
  final int? aff;
        String comment;
  final int? status;
  final int? isRead;
  final int? likeNum;
  final int? videoNum;
  final int? photoNum;
  final String? ipstr;
  final String? cityname;
  final int? complainNum;
  final String? refuseReason;
  final String? createdAt;
  final String? updatedAt;
  final int? isFinished;
  final int? isTop;
  int? isLike;
  final int? isLandlord;
  final List<ReviewData>? comments;
  final List<MediaModel>? medias;
        UserModel? user;
  final int? likeCt;
  final int? likeFct;
  final String? text;
  final UserModel? member;

  ReviewData({
    this.id,
    this.postId,
    this.pid,
    this.aff,
    required this.comment,
    this.status,
    this.isRead,
    this.likeNum,
    this.videoNum,
    this.photoNum,
    this.ipstr,
    this.cityname,
    this.complainNum,
    this.refuseReason,
    this.createdAt,
    this.updatedAt,
    this.isFinished,
    this.isTop,
    this.isLike,
    this.isLandlord,
    this.comments,
    this.medias,
    this.user,
    this.member,
    this.text,
    this.likeFct,
    this.likeCt,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      id: json['id'],
      postId: json['post_id'],
      pid: json['pid'],
      aff: json['aff'],
      comment: json['comment'] ?? '',
      status: json['status'],
      isRead: json['is_read'],
      likeNum: json['like_num'],
      videoNum: json['video_num'],
      photoNum: json['photo_num'],
      ipstr: json['ipstr'],
      cityname: json['cityname'],
      complainNum: json['complain_num'],
      refuseReason: json['refuse_reason'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isFinished: json['is_finished'],
      isTop: json['is_top'],
      isLike: json['is_like'] ?? 0,
      isLandlord: json['is_landlord'],
      comments: json['comments'] == null
          ? []
          : List.from(json['comments']!.map((e) => ReviewData.fromJson(e))),
      medias: json['medias'] != null
          ? List.from(json['medias'].map((e) => MediaModel.fromJson(e)))
          : null,
      user: json['user'] == null ? null : UserModel.fromJson(json['user']),
      member: json['member'] == null ? null : UserModel.fromJson(json['member']),
      text: json['text'],
      likeCt: json['like_ct'] ?? 0,
      likeFct: json['like_fct'] ?? 0,
    );
  }

  ReviewData copyWith({
    int? id,
    int? postId,
    int? pid,
    int? aff,
    String? comment,
    int? status,
    int? isRead,
    int? likeNum,
    int? videoNum,
    int? photoNum,
    String? ipstr,
    String? cityname,
    int? complainNum,
    String? refuseReason,
    String? createdAt,
    String? updatedAt,
    int? isFinished,
    int? isTop,
    int? isLike,
    int? isLandlord,
    List<ReviewData>? comments,
    List<MediaModel>? medias,
    UserModel? user,
    UserModel? member,
    String? text,
    int? likeCt,
    int? likeFct,
  }) {
    return ReviewData(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      pid: pid ?? this.pid,
      aff: aff ?? this.aff,
      comment: comment ?? this.comment,
      status: status ?? this.status,
      isRead: isRead ?? this.isRead,
      likeNum: likeNum ?? this.likeNum,
      videoNum: videoNum ?? this.videoNum,
      photoNum: photoNum ?? this.photoNum,
      ipstr: ipstr ?? this.ipstr,
      cityname: cityname ?? this.cityname,
      complainNum: complainNum ?? this.complainNum,
      refuseReason: refuseReason ?? this.refuseReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFinished: isFinished ?? this.isFinished,
      isTop: isTop ?? this.isTop,
      isLike: isLike ?? this.isLike,
      isLandlord: isLandlord ?? this.isLandlord,
      comments: comments ?? this.comments,
      medias: medias ?? this.medias,
      user: user ?? this.user,
      member: member ?? this.member,
      text: text ?? this.text,
      likeCt: likeCt ?? this.likeCt,
      likeFct: likeFct ?? this.likeFct,
    );
  }
}
