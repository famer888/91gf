part of '../repo.dart';

mixin _Black on _BaseAppRepo implements BlackDomain {

  @override
  AsyncResult<BlackSearchModel> getBlackSearch({required String word, required int page, required int limit}) {
    return _blackService
        .getBlackSearch(word: word, page: page, limit: limit)
        .deserializeJsonBy(BlackSearchModel.fromJson)
        .guard;
  }

  @override
  AsyncResult<List<TipModel>> getBlackNotices() =>
      _blackService.getBlackNotices().deserializeJsonListBy((e) => e.map(TipModel.fromJson).toList()).guard;

  @override
  AsyncResult<BlackClassModel> getCategoryList({String token = ''}) =>
      _blackService.getCategoryList(token: token).deserializeJsonBy(BlackClassModel.fromJson).guard;

  @override
  AsyncResult<BlackListContentModel> getBlackList(
          {String apiListUrl = '/list_contents', required int mid, required int page, required int limit}) =>
      _blackService.getBlackList(mid: mid, page: page, limit: limit).deserializeJsonBy(BlackListContentModel.fromJson).guard;

  @override
  AsyncResult<BlackDetailModel> getBlackDetail({required int id}) {
    final token = info.token ?? '';
    return _blackService.getBlackDetail(id: id, token: token).deserializeJsonBy(BlackDetailModel.fromJson).guard;
  }

  /// 黑料点赞
  /// @param mid 黑料id 必传
  @override
  AsyncResult<BlackPostLikeModel> getBlackLike({required int id}) =>
      _blackService.getBlackLike(id: id).deserializeJsonBy(BlackPostLikeModel.fromJson).guard;

  /// 黑料收藏
  /// @param mid 黑料id 必传
  @override
  AsyncResult getBlackCollect({required int id}) => _blackService.getBlackCollect(id: id).deserializeJsonBy((e) => e).guard;

  /// 黑料购买
  /// @param mid 黑料id 必传
  @override
  AsyncResult getBlackBuy({required int id}) => _blackService.getBlackBuy(id: id).deserializeJsonBy((e) => e).guard;

  /// 黑料评论列表
  /// @param mid 黑料id 必传
  /// @param page 页码 选传
  /// @param limit 每页数量 选传
  @override
  AsyncResult<CommentListModel> getBlackCommentList({required int id, required int page, required int limit}) =>
      _blackService.getBlackCommentList(id: id, page: page, limit: limit).deserializeJsonBy(CommentListModel.fromJson).guard;

  /// 黑料发布评论
  /// @param mid 黑料id 必传
  /// @param content 评论内容 必传
  @override
  AsyncResult publishBlackComment({required int cid, required String content}) =>
      _blackService.publishBlackComment(cid: cid, content: content).deserializeJsonBy((e) => e).guard;

  /// 黑料标签列表
  @override
  AsyncResult<BlackLabelListModel> getBlackLabelList({required int page, required int limit, required String tag}) =>
      _blackService.getBlackLabelList(page: page, limit: limit, tag: tag).deserializeJsonBy(BlackLabelListModel.fromJson).guard;

  /// 黑料搜索列表
  @override
  AsyncResult<List<BlackListItemModel>> getBlackSearchList({required String word, required int page, required int limit})
    => _blackService
      .getBlackSearchList(word: word, page: page, limit: limit)
      .deserializeJsonListBy((e) => e.map(BlackListItemModel.fromJson).toList())
      .guard;

  /// 黑料收藏列表
  @override
  AsyncResult<List<BlackListItemModel>> getBlackCollectList({required int page, required int limit})
    => _blackService
      .getBlackCollectList(page: page, limit: limit)
      .deserializeJsonBy((e) => (e['list'] as List<dynamic>).map((item) => BlackListItemModel.fromJson(item)).toList())
      .guard;

  /// 黑料购买列表
  @override
  AsyncResult<List<BlackListItemModel>> getBlackBuyList({required int page, required int limit})
    => _blackService
      .getBlackBuyList(page: page, limit: limit)
      .deserializeJsonBy((e) => (e['list'] as List<dynamic>).map((item) => BlackListItemModel.fromJson(item)).toList())
      .guard;
}
