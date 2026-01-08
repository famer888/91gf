import 'package:jygf/domain/type_def.dart';

import 'base_service.dart';

class BlackService extends BaseService {
  BlackService(super._dio);

  @override
  final service = 'contents';

  /// 获取黑料公告
  AsyncJson getBlackNotices() => post('/list_notice');

  /// 分类列表
  /// @param token 登录token 选传
  AsyncJson getCategoryList({String token = ''}) => post('/list_category', data: {'token': token});

  /// 黑料列表
  /// @param mid 分类id 必传 0表示全部
  /// @param page 页码 选传
  /// @param limit 每页数量 选传
  AsyncJson getBlackList({String apiListUrl = '/list_contents', required int mid, required int page, required int limit})
    => post(apiListUrl, data: {
        'mid': mid,
        'page': page,
        'limit': limit,
      });

  /// 黑料详情
  /// @param id 黑料id 必传
  /// @param token 登录token 选传
  AsyncJson getBlackDetail({required int id, String token = ''})
  => post('/detail_content', data: {
        'id': id,
        'token': token,
      });

  /// 黑料点赞
  /// @param mid 黑料id 必传
  AsyncJson getBlackLike({required int id}) => post('/like', data: {'id': id});

  /// 黑料收藏
  /// @param mid 黑料id 必传
  AsyncJson getBlackCollect({required int id}) => post('/favorite', data: {'id': id});

  /// 黑料购买
  /// @param mid 黑料id 必传
  AsyncJson getBlackBuy({required int id}) => post('/buy', data: {'id': id});

  /// 黑料评论列表
  /// @param mid 黑料id 必传
  /// @param page 页码 选传
  /// @param limit 每页数量 选传
  AsyncJson getBlackCommentList({required int id, required int page, required int limit}) => post('/list_comments', data: {
        'id': id,
        'page': page,
        'limit': limit,
      });

  /// 黑料发布评论
  /// @param mid 黑料id 必传
  /// @param content 评论内容 必传
  AsyncJson publishBlackComment({required int cid, required String content}) => post('/create_comment', data: {
        'cid': cid,
        'content': content,
      });

  /// 黑料标签列表
  AsyncJson getBlackLabelList({required int page, required int limit, required String tag}) => post('/list_contents_tag', data: {
        'page': page,
        'limit': limit,
        'tag': tag,
      });
}
