part of '../repo.dart';

mixin _Seed on _BaseAppRepo implements SeedDomain {
  @override
  AsyncResult<List<BitNavModel>> reqGetPostBit({required int id}) =>
      _seedService
          .reqGetPostBit(id: id)
          .deserializeJsonListBy((e) => e.map(BitNavModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<PostsWithBannersModel> bitSortList({
    required int id,
    required String sort,
    required int page,
    required int limit,
  }) =>
      _seedService
          .bitSortList(id: id, sort: sort, page: page, limit: limit)
          .deserializeJsonBy(PostsWithBannersModel.fromJson)
          .guard;

  @override
  AsyncResult<BitDetail> bitTopicDetail({required String id}) => _seedService
      .bitTopicDetail(id: id)
      .deserializeJsonBy(BitDetail.fromJson)
      .guard;

  @override
  AsyncJson buyBit({required int id}) => _seedService.buyBit(id: id);

  @override
  AsyncResult<List<ReviewData>> bitPostComments(
          {required String id, required int page, required int limit}) =>
      _seedService
          .bitPostComments(id: id, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(ReviewData.fromJson).toList())
          .guard;

  @override
  AsyncResult bitCommentLike({required String id}) =>
      _seedService.bitCommentLike(id: id).deserialize().guard;

  @override
  AsyncJson bitPostComment({
    required String postId,
    required String content,
  }) =>
      _seedService.bitPostComment(
          postId: postId, content: content);

  @override
  AsyncResult bitTopicFavorite({required String id}) =>
      _seedService.bitTopicFavorite(id: id).deserialize().guard;

  @override
  AsyncResult<List<PostModel>> searchBit({
    required int page,
    required int limit,
    required String word,
  }) =>
      _seedService
          .searchBit(page: page, limit: limit, word: word)
          .deserializeJsonListBy((e) => e.map(PostModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<PostModel>> favoriteBitList({
    required int page,
    required int limit,
  }) =>
      _seedService
          .favoriteBitList(page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(PostModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<PostModel>> buyBitList({
    required int page,
    required int limit,
  }) =>
      _seedService
          .buyBitList(page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(PostModel.fromJson).toList())
          .guard;
}
