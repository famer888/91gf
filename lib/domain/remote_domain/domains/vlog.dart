import 'package:jygf/domain/model/vlog_model.dart';

import '../../model/video_comment_model.dart';
import '../../type_def.dart';

abstract class VlogDomain {
  /// 点击播放上报
  AsyncResult reportVlogPlay({required int id});

  /// 短视频首页接口
  AsyncResult<List<VlogModel>?> vlogRecommendList();

  ///发现页面
  AsyncResult<List<VlogModel>?> vlogDiscoverList({
    required int limit,
    required int page,
    required String type, // 排序类型config接口中vlog_discover_sort_nav中type值
  });

  ///他人短视频列表
  AsyncResult<List<VlogModel>?> otherUserVlogList({
    required int limit,
    required int page,
    required int aff,
  });

  /// 评论
  AsyncResult vlogComment({
    required int id,
    required String text,
  });

  ///评论列表
  AsyncResult<List<VideoCommentListModel>?> vlogCommentList({
    required int limit,
    required int page,
    required int id,
  });

  ///喜欢
  AsyncResult vlogLike({
    required int id,
  });

  ///收藏
  AsyncResult vlogFavorite({
    required int id,
  });

  ///评论点赞
  AsyncResult vlogCommentLike({
    required int id,
  });

  /// 短视频购买
  AsyncResult vlogBuy({
    required int id,
  });

  ///我的购买列表
  AsyncResult<List<VlogModel>?> vlogBuyList({
    required int limit,
    required int page,
  });

  ///标签相关短视频列表
  AsyncResult<List<VlogModel>?> vlogListTag({
    required int limit,
    required int page,
    required String type, // hot 排序类型
    required String word, // 标签
  });

  ///搜索短视频列表
  AsyncResult<List<VlogModel>?> vlogSearchList({
    required String word,
    required int page,
    required int limit,
  });

  ///我收藏的短视频列表
  AsyncResult<List<VlogModel>?> vlogFavoriteList({
    required int page,
    required int limit,
  });

  ///我的关注列表
  AsyncResult<HotFollowUseRecommendModel> vlogFollowList({
    required int page,
    required int limit,
  });

  ///发现
  AsyncResult<List<VlogModel>?> mvDiscoverList({
    required int limit,
    required int page,
    required String type, // 排序类型config接口中mv_discover_sort_nav中type值
  });
}
