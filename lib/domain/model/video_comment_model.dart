import 'user_model.dart';

class VideoCommentListModel {
  int? id;
  int? aff;
  int? mvId;
  int? mvAff;
  String? content;
  String? text;
  int likeCount;
  int? likeCt;
  int? likeFct;
  int? replayCount;
  int? status;
  String? createdAt;
  int? isLike;
  UserModel? member;

  VideoCommentListModel({
    this.id,
    this.aff,
    this.mvId,
    this.mvAff,
    this.content,
    this.text,
    required this.likeCount,
    this.likeCt,
    this.likeFct,
    this.replayCount,
    this.status,
    this.createdAt,
    this.isLike,
    this.member,
  });

  factory VideoCommentListModel.fromJson(Map<String, dynamic> json) =>
      VideoCommentListModel(
        id: json['id']?.toInt(),
        aff: json['aff']?.toInt(),
        mvId: json['mv_id']?.toInt(),
        mvAff: json['mv_aff']?.toInt(),
        content: json['content']?.toString(),
        text: json['text']?.toString(),
        likeCount: json['like_count']?.toInt() ?? 0,
        likeCt: json['like_ct']?.toInt() ?? 0,
        likeFct: json['like_fct']?.toInt() ?? 0,
        replayCount: json['replay_count']?.toInt(),
        status: json['status']?.toInt(),
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
    data['mv_id'] = mvId;
    data['mv_aff'] = mvAff;
    data['content'] = content;
    data['text'] = text;
    data['like_count'] = likeCount;
    data['like_ct'] = likeCt;
    data['like_fct'] = likeFct;
    data['replay_count'] = replayCount;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['is_like'] = isLike;
    return data;
  }
}

class VideoCommentModel {
  List<VideoCommentListModel>? list;
  String? lastIx;

  VideoCommentModel({
    this.list,
    this.lastIx,
  });
  VideoCommentModel.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      final a = json['list'];
      final arr0 = <VideoCommentListModel>[];
      a.forEach((v) {
        arr0.add(VideoCommentListModel.fromJson(v));
      });
      list = arr0;
    }
    lastIx = json['last_ix']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (list != null) {
      final arr0 = [];
      for (var v in list!) {
        arr0.add(v.toJson());
      }
      data['list'] = arr0;
    }
    data['last_ix'] = lastIx;
    return data;
  }
}
