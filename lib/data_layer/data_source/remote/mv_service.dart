import '../../../domain/type_def.dart';
import 'base_service.dart';

class MvService extends BaseService {
  MvService(super._dio);

  @override
  final service = 'mv';

  /// 取得搜索视频结果
  AsyncJson videoSearch({
    required int page,
    required int limit,
    required String word,
    int type = 1,
  }) =>
      post('/search', data: {
        'page': page,
        'limit': limit,
        'word': word,
        'type': type,
      });

  /// 类别列表
  AsyncJson getListConstructWithParam({
    required String id,
    required int limit,
    required int page,
    required String sort,
  }) =>
      post(
        '/list_construct',
        data: {
          'id': id,
          'page': page,
          'limit': limit,
          'sort': sort,
        },
      );

  /// 获取视频详情
  AsyncJson getVideoDetail({
    required String id,
  }) =>
      post('/getDetail', data: {'id': id});

  /// 视频详情推荐视频
  AsyncJson getDetailRecommendList({required String id}) =>
      post('/getDetailRecommendList', data: {'id': id});

  /// 获取视频的评论
  AsyncJson cartoonListCommentMv({
    required String id,
    required String lastIx,
    required int page,
    required int limit,
  }) =>
      post('/list_comment_mv', data: {
        'last_ix': lastIx,
        'page': page,
        'limit': limit,
        'id': id,
      });

  /// 对视频的评论点赞
  AsyncJson cartoonCommentMvLike({required int id}) =>
      post('/toggle_comment_like', data: {'id': id});

  /// 对视频发布评论
  AsyncJson cartoonCreateCommentMv({
    required String id,
    required String content,
  }) =>
      post('/create_comment_mv', data: {
        'content': content,
        'id': id,
      });

  /// 购买视频
  AsyncJson buyVideo({
    required int id,
  }) =>
      post('/buy', data: {'id': id});

}
