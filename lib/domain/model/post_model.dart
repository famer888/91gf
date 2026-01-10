import 'media_model.dart';
import 'topic_model.dart';
import 'user_model.dart';

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
  int? index; //自定义字段，榜单第几个数据

  String? aff;
  int topicId;

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
    required this.topic,
    this.medias,
    this.isBest,
    this.user,
    this.createdAt,
    this.status,
    this.refuseReason,
    this.aff,
    this.topicId = 0,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        fakeViewCt: json['fake_view_ct'] ?? 0,
        viewCt: json['view_fct'] ?? 0,
        commentCt: json['comment_ct'] ?? 0,
        setTop: json['set_top'] ?? 0,
        photoCt: json['photo_ct'] ?? 0,
        videoCt: json['video_ct'] ?? 0,
        fakeLikeCt: json['fake_like_ct'] ?? 0,
        likeCt: json['like_ct'] ?? 0,
        favoriteCt: json['favorite_fct'] ?? 0,
        likeNum: json['like_num'] ?? 0,
        commentNum: json['comment_num'] ?? 0,
        viewNum: json['view_num'] ?? 0,
        topic: TopicModel.fromJson(json['topic']),
        medias: json['medias'] != null ? List.from(json['medias'].map((e) => MediaModel.fromJson(e))) : null,
        isBest: json['is_best'] ?? 0,
        user: json['user'] != null ? UserModel.fromJson(json['user'] as Map<String, dynamic>) : null,
        createdAt: json['created_at'],
        status: json['status'],
        refuseReason: json['refuse_reason'],
        aff: json['aff'] ?? '',
        topicId: json['topic_id'] ?? 0,
      );
}
