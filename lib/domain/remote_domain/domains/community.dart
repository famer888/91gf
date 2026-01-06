import 'package:jygf/domain/model/post/circle/circle_post_nav_model.dart';
import 'package:jygf/domain/model/posts_with_banners_model.dart';

import '../../enum.dart';
import '../../model/community_nav_model.dart';
import '../../model/community_with_banner_model.dart';
import '../../model/creator_info_model.dart';
import '../../model/post_model.dart';
import '../../model/review_data_model.dart';
import '../../model/tiezt_model.dart';
import '../../model/topic_detail_model.dart';
import '../../model/topic_model.dart';
import '../../model/topics_with_banners_model.dart';
import '../../type_def.dart';

abstract class CommunityDomain {
  /// 话题列表
  AsyncResult<TopicsWithBannersModel> postList({
    required int page,
    required int limit,
  });

  /// 购买帖子列表
  AsyncResult buyPostTutorials({required int id});

  /// 获取帖子
  AsyncResult<List<CommunityNavModel>> reqGetPostNav({String type = ''});

  /// 社区列表排序
  AsyncResult<CommunityWithBannerModel> communitySortList({
    required int id,
    required String sort,
    required int page,
    required int limit,
  });

  /// 社区列表排序
  AsyncResult<CommunityWithBannerModel> communityAiList({
    required int page,
    required int limit,
  });

  /// 帖子详情
  AsyncResult<TopicDetail> communityTopicDetail({required String id});

  /// 社区 一级评论列表
  AsyncResult<List<ReviewData>> communityPostComments({
    required String id,
    required int page,
    required int limit,
  });

  /// 发布评论
  AsyncJson communityPostComment({
    required String postId,
    required String commentId,
    required String content,
  });

  /// 帖子或评论点赞/取消点赞
  AsyncResult communityTopicLike(
      {required MyLikeType type, required String id});

  /// 获取帖子的播放链接
  AsyncJson reqGetPostURL({required int id});

  /// 帖子收藏/取消收藏
  AsyncResult communityTopicFavorite({required String id});

  /// 评论详情列表
  AsyncResult<List<ReviewData>> communityPostCommentsSecond({
    required String commentId,
    required int page,
    required int limit,
  });

  /// 发布帖子
  AsyncJson communityPost({
    required String topicId,
    required String title,
    String content = '',
    required String medias,
    required String coins,
    String type = '',
    String contact = '',
    int isPublic = 0,
  });

  /// 发帖获取全部标签
  AsyncResult<List<TopicModel>> communityTopics({
    required int page,
    required int limit,
  });

  /// 他人帖子
  AsyncResult<List<TieztModel>> peerCenterPost({
    required String aff,
    required int page,
    required int limit,
    String lastIx = '',
  });

  /// 他人中心
  AsyncResult<CreatorInfo> peerCenterInfo({required String aff});

  /// 关注话题
  AsyncResult<List<TopicModel>> focusTops({
    required int page,
    required int limit,
  });

  /// 话题关注/取消关注
  AsyncJson communityFollowTopic({required String topicId});

  /// 话题详情
  AsyncResult<TopicModel> communityTopicsDetail({
    required String topicId,
    String type = '',
  });

  /// 话题详情-帖子分页
  AsyncResult<List<PostModel>> communityListTopicPost({
    required String topicId,
    required String cate,
    required int page,
    required int limit,
    String type = '',
  });

  /// 帖子搜索
  AsyncResult<List<PostModel>> searchCommunity({
    required int page,
    required int limit,
    required String word,
    required String type,
  });

   /// 圈子排序列表
  AsyncResult<PostsWithBannersModel> circleSortList({
    required int id,
    required String sort,
    required int page,
    required int limit,
  });

   /// 获取圈子导航
  AsyncResult<List<CirclePostNavModel>> reqGetCircleNav({String type = ''});

  /// 我的帖子
  AsyncResult<List<TieztModel>> myPosts({
    required int page,
    required int limit,
    required int status,
  });
}
