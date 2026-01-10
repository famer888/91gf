import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/ui_layer/screens/black/model/black_model.dart';
import '../../type_def.dart';

abstract class BlackDomain {

  /// 获取黑料公告
  AsyncResult<List<TipModel>> getBlackNotices();

  /// 分类列表
  /// @param token 登录token 选传
  AsyncResult<BlackClassModel> getCategoryList({String token = ''});

  /// 黑料列表
  /// @param mid 分类id 必传 0表示全部
  /// @param page 页码 选传
  /// @param limit 每页数量 选传
  AsyncResult<BlackListContentModel> getBlackList({String apiListUrl = '/list_contents', required int mid, required int page, required int limit});

  /// 黑料详情
  /// @param id 黑料id 必传
  /// @param token 登录token 选传
  AsyncResult<BlackDetailModel> getBlackDetail({required int id, String token = ''});

  /// 黑料点赞
  /// @param mid 黑料id 必传
  AsyncResult<BlackPostLikeModel> getBlackLike({required int id});

  /// 黑料收藏
  /// @param mid 黑料id 必传
  AsyncResult getBlackCollect({required int id});

  /// 黑料购买
  /// @param mid 黑料id 必传
  AsyncResult getBlackBuy({required int id});

  /// 黑料评论列表
  /// @param mid 黑料id 必传
  /// @param page 页码 选传
  /// @param limit 每页数量 选传
  AsyncResult<CommentListModel> getBlackCommentList({required int id, required int page, required int limit});

  /// 黑料发布评论
  /// @param cid 黑料id 必传
  /// @param content 评论内容 必传
  AsyncResult publishBlackComment({required int cid, required String content});

  /// 黑料标签列表
  AsyncResult<BlackLabelListModel> getBlackLabelList({required int page, required int limit, required String tag});

  /// 黑料搜索列表
  AsyncResult<List<BlackListItemModel>> getBlackSearchList({required String word, required int page, required int limit});
}
