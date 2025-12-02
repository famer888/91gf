
import '../../model/feed/feed_model.dart';
import '../../model/video_comment_model.dart';
import '../../model/video_detail_model.dart';
import '../../type_def.dart';

abstract class MvDomain {
  /// 视频搜索
  AsyncResult<List<FeedVideoModel>> videoSearch({
    required int page,
    required int limit,
    required String word,
    int type = 1,
  });

  /// 常规更多
  AsyncResult<List<FeedModel>> getListConstructWithParam({
    required String id,
    required int limit,
    required int page,
    required String sort,
  });

  /// 获取视频详情
  AsyncResult<VideoDetailData> getVideoDetail({required String id});

  /// 视频详情推荐视频
  AsyncResult<List<FeedModel>> getDetailRecommendList({required String id});

  /// 获取视频的评论
  AsyncResult<VideoCommentModel> cartoonListCommentMv({
    required String id,
    required String lastIx,
    required int page,
    required int limit,
  });

  /// 对视频的评论点赞
  AsyncResult cartoonCommentMvLike({required int id});

  /// 对视频发布评论
  AsyncResult cartoonCreateCommentMv({
    required String id,
    required String content,
  });

  /// 购买视频
  AsyncResult buyVideo({
    required int id,
  });

}
