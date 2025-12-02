import 'media_model.dart';
import 'topic_model.dart';
import 'user_model.dart';

class BitDetail {
  final String? aff;
  final String? content;
  final int? isDeleted;
  final int? likeNum;
  final int? commentNum;
  final int? commentCt;
  final int? isBest;
  final int? category;
  final String? refuseReason;
  final int? photoNum;
  final int? videoNum;
  final int? isFinished;
  final String? ipstr;
  final String? cityname;
  final int? topicId;
  final int? viewNum;
  final int? viewFct;
  final int? favoriteFct;
  final String? refreshAt;
  final String? title;
  final int? rewardAmount;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final int? sort;
  final int? favoriteNum;
  final int? rewardNum;
  final int? setTop;
  final int? id;
  final int? realViewNum;
  final int? realLikeNum;
  final int? unlockCoins;
  final String? contentNew;
  final int? fakeCt;
  final int? fakeViewCt;
  final String? reviewedAt;
  final int? topicSort;
  final String? contact;
  final int? isOpen;
  final int? aiDraw;
  int? isLike;
  int? isFavorite;
  final int? isPay;
  final UserModel? user;
  final TopicModel? topic;
  final List<MediaModel>? medias;
        int? type;
        String? link;
  final int? coins;
        String? secret;
  final String? payTip;

  BitDetail(
      {this.aff,
      this.content,
      this.isDeleted,
      this.likeNum,
      this.commentNum,
      this.commentCt,
      this.isBest,
      this.category,
      this.refuseReason,
      this.photoNum,
      this.videoNum,
      this.isFinished,
      this.ipstr,
      this.cityname,
      this.topicId,
      this.viewNum,
      this.refreshAt,
      this.title,
      this.rewardAmount,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.sort,
      this.favoriteNum,
      this.rewardNum,
      this.setTop,
      this.id,
      this.realViewNum,
      this.realLikeNum,
      this.unlockCoins,
      this.contentNew,
      this.fakeCt,
      this.fakeViewCt,
      this.reviewedAt,
      this.topicSort,
      this.contact,
      this.isOpen,
      this.aiDraw,
      this.isLike,
      this.isFavorite,
      this.isPay,
      this.user,
      this.topic,
      this.medias,
      this.type,
      this.link,
      this.coins,
      this.secret,
      this.payTip,
      this.viewFct,
      this.favoriteFct});

  factory BitDetail.fromJson(Map<String, dynamic> json) => BitDetail(
        aff: json['aff'],
        content: json['content'],
        isDeleted: json['is_deleted'],
        likeNum: json['like_num'],
        commentNum: json['comment_num'],
        commentCt: json['comment_ct'],
        isBest: json['is_best'],
        category: json['category'],
        refuseReason: json['refuse_reason'],
        photoNum: json['photo_num'],
        videoNum: json['video_num'],
        isFinished: json['is_finished'],
        ipstr: json['ipstr'],
        cityname: json['cityname'],
        topicId: json['topic_id'],
        viewNum: json['view_num'],
        refreshAt: json['refresh_at'],
        title: json['title'],
        rewardAmount: json['reward_amount'],
        status: json['status'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        sort: json['sort'],
        favoriteNum: json['favorite_num'],
        rewardNum: json['reward_num'],
        setTop: json['set_top'],
        id: json['id'],
        realViewNum: json['real_view_num'],
        realLikeNum: json['real_like_num'],
        unlockCoins: json['unlock_coins'],
        contentNew: json['content_new'],
        fakeCt: json['fake_ct'],
        fakeViewCt: json['fake_view_ct'],
        reviewedAt: json['reviewed_at'],
        topicSort: json['topic_sort'],
        contact: json['contact'],
        isOpen: json['is_open'],
        aiDraw: json['ai_draw'],
        isLike: json['is_like'],
        isFavorite: json['is_favorite'],
        isPay: json['is_pay'],
        user: json['user'] == null ? null : UserModel.fromJson(json['user']),
        topic:
            json['topic'] == null ? null : TopicModel.fromJson(json['topic']),
        medias: json['medias'] != null
            ? List.from(json['medias'].map((e) => MediaModel.fromJson(e)))
            : null,
        type: json['type'],
        link: json['link'],
        coins: json['coins'],
        secret: json['secret'],
        payTip: json['pay_tip'],
        viewFct: json['view_fct'],
        favoriteFct: json['favorite_fct'],
      );
}
