import 'package:jygf/domain/model/media_model.dart';
import 'package:jygf/domain/model/post/post_media_model.dart';
import 'package:jygf/domain/model/topic_model.dart';
import 'package:jygf/domain/model/user_model.dart';

class PostModel {
  final int id;
  final String title;
  final int? fakeViewCt;
  final int? viewCt;
  final int? commentCt;
  final int setTop;
  final int? photoCt;
  final int? videoCt;
  final int? fakeLikeCt;
  final int? likeCt;
  final int? favoriteCt;
  final int likeNum;
  final int commentNum;
  final int viewNum;
  final TopicModel? topic;
  final int? isBest;
  final List<MediaModel>? medias;
  final UserModel? user;
  final String? createdAt;
  final int? status;
  final String? refuseReason;

  PostModel({
    required this.id,
    required this.title,
    this.fakeViewCt,
    this.viewCt,
    this.commentCt,
    required this.setTop,
    this.photoCt,
    this.videoCt,
    this.fakeLikeCt,
    this.likeCt,
    this.favoriteCt,
    required this.likeNum,
    required this.commentNum,
    required this.viewNum,
    this.topic,
    this.medias,
    this.isBest,
    this.user,
    this.createdAt,
    this.status,
    this.refuseReason,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
      id: json['id'],
      title: json['title'] ?? '',
      fakeViewCt: json['fake_view_ct'],
      viewCt: json['view_ct'],
      commentCt: json['comment_ct'],
      setTop: json['set_top'] ?? 0,
      photoCt: json['photo_ct'],
      videoCt: json['video_ct'],
      fakeLikeCt: json['fake_like_ct'],
      likeCt: json['like_ct'],
      favoriteCt: json['favorite_ct'],
      likeNum: json['like_num'] ?? 0,
      commentNum: json['comment_num'] ?? 0,
      viewNum: json['view_num'] ?? 0,
      topic: json['topic'] != null 
          ? TopicModel.fromJson(json['topic'])
          : null,
      medias: json['medias'] != null
          ? List.from(json['medias'].map((e) => PostMediaModel.fromJson(e)))
          : null,
      isBest: json['is_best'],
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'],
      status: json['status'] ?? 1,
      refuseReason: json['refuse_reason'] ?? '',
  );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'fake_view_ct': fakeViewCt,
        'view_ct': viewCt,
        'comment_ct': commentCt,
        'set_top': setTop,
        'photo_ct': photoCt,
        'video_ct': videoCt,
        'fake_like_ct': fakeLikeCt,
        'like_ct': likeCt,
        'favorite_ct': favoriteCt,
        'like_num': likeNum,
        'comment_num': commentNum,
        'view_num': viewNum,
        'topic': topic?.toJson(),
        'medias': medias?.map((e) => e.toJson()).toList(),
        'is_best': isBest,
        // 'user': user?.toJson(),
        'created_at': createdAt,        
      };
}
