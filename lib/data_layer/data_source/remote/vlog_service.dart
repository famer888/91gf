import '../../../domain/type_def.dart';
import 'base_service.dart';

class VlogService extends BaseService {
  VlogService(super._dio);

  @override
  final service = 'vlog';

  /// 点击播放上报
  AsyncJson reportVlogPlay({
    required int id,
  }) =>
      post('/play', data: {
        'id': id,
      });

  /// 短视频首页接口
  AsyncJson vlogRecommendList() => post('/list_recommend');

  ///发现页面
  AsyncJson vlogDiscoverList({
    required int limit,
    required int page,
    required String type,
  }) =>
      post('/list_discover', data: {
        'page': page,
        'limit': limit,
        'type': type, // 排序类型config接口中vlog_discover_sort_nav中type值
      });

  ///他人短视频列表
  AsyncJson otherUserVlogList({
    required int limit,
    required int page,
    required int aff,
  }) =>
      post('/list_peer', data: {
        'page': page,
        'limit': limit,
        'aff': aff,
      });

  ///评论
  AsyncJson vlogComment({
    required int id,
    required String text,
  }) =>
      post('/comment', data: {
        'id': id,
        'text': text,
      });

  ///评论列表
  AsyncJson vlogCommentList({
    required int limit,
    required int page,
    required int id,
  }) =>
      post('/list_comment', data: {
        'page': page,
        'limit': limit,
        'id': id,
      });

  ///喜欢
  AsyncJson vlogLike({
    required int id,
  }) =>
      post('/like', data: {
        'id': id,
      });

  ///收藏
  AsyncJson vlogFavorite({
    required int id,
  }) =>
      post('/favorite', data: {
        'id': id,
      });

  ///评论点赞
  AsyncJson vlogCommentLike({
    required int id,
  }) =>
      post('/comment_like', data: {
        'id': id,
      });

  ///短视频购买
  AsyncJson vlogBuy({
    required int id,
  }) =>
      post('/buy', data: {
        'id': id,
      });

  ///我的购买列表
  AsyncJson vlogBuyList({
    required int limit,
    required int page,
  }) =>
      post('/list_buy', data: {
        'page': page,
        'limit': limit,
      });

  ///标签相关短视频列表
  AsyncJson vlogListTag({
    required int limit,
    required int page,
    required String type, // hot 排序类型
    required String word, // 标签
  }) =>
      post('/list_tag', data: {
        'page': page,
        'limit': limit,
        'type': type,
        'word': word,
      });

  ///搜索短视频
  AsyncJson vlogSearchList({
    required String word,
    required int page,
    required int limit,
  }) =>
      post('/search', data: {
        'word': word,
        'page': page,
        'limit': limit,
      });

  ///我收藏的短视频列表
  AsyncJson vlogFavoriteList({
    required int page,
    required int limit,
  }) =>
      post('/list_favorite', data: {
        'page': page,
        'limit': limit,
      });

  AsyncJson vlogFollowList({
    required int page,
    required int limit,
  }) =>
      post('/list_follow2', data: {
        'page': page,
        'limit': limit,
      });

  ///发现页面
  AsyncJson mvDiscoverList({
    required int limit,
    required int page,
    required String type,
  }) =>
      post('/list_discover', data: {
        'page': page,
        'limit': limit,
        'type': type, // 排序类型config接口中mv_discover_sort_nav中type值
      });
}
