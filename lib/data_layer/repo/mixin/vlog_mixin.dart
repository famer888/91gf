part of '../repo.dart';

mixin _Vlog on _BaseAppRepo implements VlogDomain {
  @override
  AsyncResult reportVlogPlay({
    required int id,
  }) =>
      _vlogService.reportVlogPlay(id: id).deserialize().guard;

  @override
  AsyncResult<List<VlogModel>?> vlogRecommendList() => _vlogService
      .vlogRecommendList()
      .deserializeJsonListBy((e) => e.map(VlogModel.fromJson).toList())
      .guard;

  @override
  AsyncResult<List<VlogModel>?> vlogDiscoverList({
    required int limit,
    required int page,
    required String type,
  }) =>
      _vlogService
          .vlogDiscoverList(limit: limit, page: page, type: type)
          .deserializeJsonListBy((e) => e.map(VlogModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<VlogModel>?> otherUserVlogList({
    required int limit,
    required int page,
    required int aff,
  }) =>
      _vlogService
          .otherUserVlogList(limit: limit, page: page, aff: aff)
          .deserializeJsonListBy((e) => e.map(VlogModel.fromJson).toList())
          .guard;

  @override
  AsyncResult vlogComment({
    required int id,
    required String text,
  }) =>
      _vlogService.vlogComment(id: id, text: text).deserialize().guard;

  @override
  AsyncResult<List<VideoCommentListModel>?> vlogCommentList({
    required int limit,
    required int page,
    required int id,
  }) =>
      _vlogService
          .vlogCommentList(limit: limit, page: page, id: id)
          .deserializeJsonListBy(
              (e) => e.map(VideoCommentListModel.fromJson).toList())
          .guard;

  ///喜欢
  @override
  AsyncResult vlogLike({required int id}) =>
      _vlogService.vlogLike(id: id).deserialize().guard;

  ///收藏
  @override
  AsyncResult vlogFavorite({required int id}) =>
      _vlogService.vlogFavorite(id: id).deserialize().guard;

  ///评论点赞
  @override
  AsyncResult vlogCommentLike({required int id}) =>
      _vlogService.vlogCommentLike(id: id).deserialize().guard;

  @override
  AsyncResult vlogBuy({
    required int id,
  }) =>
      _vlogService.vlogBuy(id: id).deserialize().guard;

  @override
  AsyncResult<List<VlogModel>?> vlogBuyList({
    required int limit,
    required int page,
  }) =>
      _vlogService
          .vlogBuyList(limit: limit, page: page)
          .deserializeJsonListBy((e) => e.map(VlogModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<VlogModel>?> vlogListTag({
    required int limit,
    required int page,
    required String type,
    required String word,
  }) =>
      _vlogService
          .vlogListTag(limit: limit, page: page, type: type, word: word)
          .deserializeJsonListBy((e) => e.map(VlogModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<VlogModel>?> vlogSearchList({
    required String word,
    required int page,
    required int limit,
  }) =>
      _vlogService
          .vlogSearchList(word: word, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(VlogModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<VlogModel>?> vlogFavoriteList({
    required int page,
    required int limit,
  }) =>
      _vlogService
          .vlogFavoriteList(page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(VlogModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<HotFollowUseRecommendModel> vlogFollowList({
    required int page,
    required int limit,
  }) =>
      _vlogService
          .vlogFollowList(page: page, limit: limit)
          .deserializeJsonBy(HotFollowUseRecommendModel.fromJson)
          .guard;

  @override
  AsyncResult<List<VlogModel>?> mvDiscoverList({
    required int limit,
    required int page,
    required String type,
  }) =>
      _vlogService
          .mvDiscoverList(limit: limit, page: page, type: type)
          .deserializeJsonListBy((e) => e.map(VlogModel.fromJson).toList())
          .guard;
}
