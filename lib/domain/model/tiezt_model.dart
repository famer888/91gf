import 'media_model.dart';
import 'topic_model.dart';
import 'user_model.dart';

class TieztModel {
  final int? id;
  final String? aff;
  final String? content;
  final int? isDeleted;
  final int likeNum;
  final int commentNum;
  final int? isBest;
  final int? category;
  final String? refuseReason;
  final int? photoNum;
  final int? videoNum;
  final int? isFinished;
  final String? ipstr;
  final String? cityname;
  final int? topicId;
  final int viewNum;
  final String? refreshAt;
  final String title;
  final int? rewardAmount;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final int? sort;
  final int? favoriteNum;
  final int? rewardNum;
  final int? setTop;
  final int? realViewNum;
  final int? realLikeNum;
  final int? unlockCoins;
  final String? contentNew;
  final int? fakeCt;
  final String? reviewedAt;
  final int? topicSort;
  final String? contact;
  final int? isOpen;
  final int? aiDraw;
  final int? isFavorite;
  final int? isLike;
  final int? relatedId;
  final int? xId;
  final UserModel? user;
  final TopicModel? topic;
  final List<MediaModel>? medias;

  TieztModel({
    this.id,
    this.aff,
    this.content,
    this.isDeleted,
    required this.likeNum,
    required this.commentNum,
    this.isBest,
    this.category,
    this.refuseReason,
    this.photoNum,
    this.videoNum,
    this.isFinished,
    this.ipstr,
    this.cityname,
    this.topicId,
    required this.viewNum,
    this.refreshAt,
    required this.title,
    this.rewardAmount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.sort,
    this.favoriteNum,
    this.rewardNum,
    this.setTop,
    this.realViewNum,
    this.realLikeNum,
    this.unlockCoins,
    this.contentNew,
    this.fakeCt,
    this.reviewedAt,
    this.topicSort,
    this.contact,
    this.isOpen,
    this.aiDraw,
    this.isFavorite,
    this.isLike,
    this.relatedId,
    this.xId,
    this.user,
    this.topic,
    this.medias,
  });

  TieztModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        aff = json['aff'] as String?,
        content = json['content'] as String?,
        isDeleted = json['is_deleted'] as int?,
        likeNum = json['like_num'] ?? 0,
        commentNum = json['comment_num'] ?? 0,
        isBest = json['is_best'] as int?,
        category = json['category'] as int?,
        refuseReason = json['refuse_reason'] as String?,
        photoNum = json['photo_num'] as int?,
        videoNum = json['video_num'] as int?,
        isFinished = json['is_finished'] as int?,
        ipstr = json['ipstr'] as String?,
        cityname = json['cityname'] as String?,
        topicId = json['topic_id'] as int?,
        viewNum = json['view_num'] ?? 0,
        refreshAt = json['refresh_at'] as String?,
        title = json['title'] ?? ' ',
        rewardAmount = json['reward_amount'] as int?,
        status = json['status'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        sort = json['sort'] as int?,
        favoriteNum = json['favorite_num'] as int?,
        rewardNum = json['reward_num'] as int?,
        setTop = json['set_top'] as int?,
        realViewNum = json['real_view_num'] as int?,
        realLikeNum = json['real_like_num'] as int?,
        unlockCoins = json['unlock_coins'] as int?,
        contentNew = json['content_new'] as String?,
        fakeCt = json['fake_ct'] as int?,
        reviewedAt = json['reviewed_at'] as String?,
        topicSort = json['topic_sort'] as int?,
        contact = json['contact'] as String?,
        isOpen = json['is_open'] as int?,
        aiDraw = json['ai_draw'] as int?,
        isFavorite = json['is_favorite'] as int?,
        isLike = json['is_like'] as int?,
        relatedId = json['related_id'] as int?,
        xId = json['x_id'] as int?,
        user = (json['user'] as Map<String, dynamic>?) != null
            ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
            : null,
        topic = (json['topic'] as Map<String, dynamic>?) != null
            ? TopicModel.fromJson(json['topic'] as Map<String, dynamic>)
            : null,
        medias = (json['medias'] as List?)
            ?.map((dynamic e) => MediaModel.fromJson(e as Map<String, dynamic>))
            .toList();
}
