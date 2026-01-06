import '../../../domain/type_def.dart';
import 'base_service.dart';

class CommunityService extends BaseService {
  CommunityService(super._dio);

  @override
  final service = 'community';

  /// 获取Tab分类列表
  AsyncJson getCategoryTabList() => post('/category');

  /// 社区排序列表
  AsyncJson communitySortList({
    required int id,
    required String sort,
    required int page,
    required int limit,
  }) =>
      post('/construct', data: {
        'id': id,
        'sort': sort,
        'page': page,
        'limit': limit,
        'type': '',
      });


  /// 话题列表
  AsyncJson postList({required int page, required int limit}) =>
      post('/list_tutorial', data: {'page': page, 'limit': limit});

  /// 购买帖子列表
  AsyncJson buyPostTutorials({required int id}) =>
      post('/unlock_topic', data: {'id': id});

  /// 获取帖子导航
  AsyncJson reqGetPostNav({String type = ''}) =>
      post('/nav', data: {'type': type});

  /// 社区排序列表
  AsyncJson communityAiList({
    required int page,
    required int limit,
  }) =>
      post('/ai_posts', data: {'page': page, 'limit': limit});

  /// 帖子详情
  AsyncJson communityTopicDetail({
    required String id,
  }) =>
      post('/post_detail', data: {
        'id': id,
      });

  /// 一级评论列表
  AsyncJson communityPostComments({
    required String id,
    required int page,
    required int limit,
  }) =>
      post('/post_comments', data: {
        'id': id,
        'page': page,
        'limit': limit,
      });

  /// 发布评论
  AsyncJson communityPostComment({
    required String postId,
    required String commentId,
    required String content,
  }) =>
      post('/comment', data: {
        'post_id': postId,
        'comment_id': commentId,
        'content': content
      });

  /// 帖子或评论点赞/取消点赞
  AsyncJson communityTopicLike({
    required String type,
    required String id,
  }) =>
      post('/like', data: {
        'type': type,
        'id': id,
      });

  /// 获取帖子的播放链接
  AsyncJson reqGetPostURL({required int id}) =>
      post('/unlock', data: {'id': id});

  /// 帖子收藏/取消收藏
  AsyncJson communityTopicFavorite({required String id, required int type, required int requestType}) =>
      post('/favorite', data: {'id': id, 'type': type, 'request_type': requestType});

  /// 二级评论列表
  AsyncJson communityPostCommentsSecond(
          {required String commentId, required int page, required int limit}) =>
      post('/comments', data: {
        'comment_id': commentId,
        'page': page,
        'limit': limit,
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
    int money = 0,
  }) =>
      post('/post', data: {
        'topic_id': topicId,
        'title': title,
        'content': content,
        'medias': medias,
        'coins': coins,
        'class': type,
        'contact': contact,
        'is_public': isPublic,
      });

  /// 发帖获取全部标签
  AsyncJson communityTopics({
    required int page,
    required int limit,
  }) =>
      post('/topics', data: {
        'page': page,
        'limit': limit,
      });

  /// 他人帖子
  AsyncJson peerCenterPost({
    required String aff,
    required int page,
    required int limit,
    String lastIx = '',
  }) =>
      post('/peer_center_post', data: {
        'aff': aff,
        'page': page,
        'limit': limit,
        'last_ix': lastIx,
      });

  /// 他人中心
  AsyncJson peerCenterInfo({required String aff}) =>
      post('/peer_center', data: {'aff': aff});

  /// 关注话题
  AsyncJson focusTops({
    required int page,
    required int limit,
  }) =>
      post('/followTopics', data: {
        'page': page,
        'limit': limit,
        'last_ix': '',
      });

  /// 话题关注/取消关注
  AsyncJson communityFollowTopic({required String topicId}) =>
      post('/follow_topic', data: {'topic_id': topicId});

  /// 社区标签
  AsyncJson communityTopicsDetail({
    required String topicId,
    String type = '',
  }) =>
      post('/topic_detail', data: {
        'topic_id': topicId,
        'type': type,
      });

  /// 话题详情-帖子分页
  AsyncJson communityListTopicPost({
    required String topicId,
    required String cate,
    required int page,
    required int limit,
    String type = '',
  }) =>
      post('/list_topic_post', data: {
        'topic_id': topicId,
        'cate': cate,
        'page': page,
        'limit': limit,
        'type': type,
      });

  /// 取得搜索帖子结果
  AsyncJson searchCommunity({
    required int page,
    required int limit,
    required String word,
    String type = '',
  }) =>
      post('/search', data: {
        'page': page,
        'limit': limit,
        'word': word,
        'type': type,
      });

  /// 圈子排序列表
  AsyncJson circleSortList({
    required int id,
    required String sort,
    required int page,
    required int limit,
  }) =>
      post('/circle_post', data: {
        'id': id,
        'sort': sort,
        'page': page,
        'limit': limit,
      });    

  /// 获取圈子导航
  AsyncJson reqGetCircleNav({String type = ''}) =>
      post('/circle_nav', data: {'type': type});

  AsyncJson myPosts({
    required int page,
    required int limit,
    required int status,
  }) =>
      post('/list_my', data: {
        'page': page,
        'limit': limit,
        'status': status,
      });
}
