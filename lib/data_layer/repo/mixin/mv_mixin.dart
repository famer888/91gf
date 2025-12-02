part of '../repo.dart';

mixin _Mv on _BaseAppRepo implements MvDomain {
  @override
  AsyncResult<List<FeedVideoModel>> videoSearch({
    required int page,
    required int limit,
    required String word,
    int type = 1,
  }) =>
      _mvService
          .videoSearch(page: page, limit: limit, word: word)
          .deserializeJsonListBy((e) => e.map(FeedVideoModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<FeedModel>> getListConstructWithParam({
    required String id,
    required int limit,
    required int page,
    required String sort,
  }) =>
      _mvService
          .getListConstructWithParam(
              id: id, limit: limit, page: page, sort: sort)
          .then((value) => {...value, 'data': value['data']['list']})
          .deserializeJsonListBy((e) => e.map(FeedModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<VideoDetailData> getVideoDetail({required String id}) =>
      _mvService
          .getVideoDetail(id: id)
          .deserializeJsonBy(VideoDetailData.fromJson)
          .guard;

  @override
  AsyncResult<List<FeedModel>> getDetailRecommendList({required String id}) =>
      _mvService
          .getDetailRecommendList(id: id)
          .deserializeJsonListBy((e) => e.map(FeedModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<VideoCommentModel> cartoonListCommentMv({
    required String id,
    required String lastIx,
    required int page,
    required int limit,
  }) =>
      _mvService
          .cartoonListCommentMv(
              id: id, lastIx: lastIx, page: page, limit: limit)
          .deserializeJsonBy(VideoCommentModel.fromJson)
          .guard;

  @override
  AsyncResult cartoonCommentMvLike({required int id}) =>
      _mvService.cartoonCommentMvLike(id: id).deserialize().guard;

  @override
  AsyncResult cartoonCreateCommentMv({
    required String id,
    required String content,
  }) =>
      _mvService
          .cartoonCreateCommentMv(id: id, content: content)
          .deserialize()
          .guard;

  @override
  AsyncResult buyVideo({required int id}) =>
      _mvService.buyVideo(id: id).deserialize().guard;

}
