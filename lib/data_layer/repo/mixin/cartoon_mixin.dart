part of '../repo.dart';

mixin _Cartoon on _BaseAppRepo implements CartoonDomain {
  // @override
  //   required int id,
  //   required int page,
  //   required int limit,
  // }) =>
  //     _liveService.getLiveIndex(
  // AsyncResult<LiveWithBannersModel> getLiveIndex({
  //       id: id,
  //       page: page,
  //       limit: limit,
  //     ).deserializeJsonBy(LiveWithBannersModel.fromJson).guard;

  @override
  AsyncResult cartoonRec(
          {required int id, required int page, int limit = 15}) =>
      _cartoonService
          .cartoonRec(id: id, page: page, limit: limit)
          .deserialize()
          .guard;

  //     downNum(id: id).deserialize().guard;

  @override
  AsyncResult<List<CartoonModel>?> cartoonMore({
    required String sort,
    required int page,
    int limit = 15,
  }) =>
      _cartoonService
          .cartoonMore(sort: sort, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(CartoonModel.fromJson).toList())
          .guard;

  @override
  AsyncResult cartoonTheme({
    required int id,
    required String sort,
    required int page,
    int limit = 15,
  }) =>
      _cartoonService
          .cartoonTheme(id: id, sort: sort, page: page, limit: limit)
          .deserialize()
          .guard;

  @override
  AsyncResult<CartoonDetailModel> cartoonDetail({
    required String id,
  }) =>
      _cartoonService
          .cartoonDetail(id: id)
          .deserializeJsonBy(CartoonDetailModel.fromJson)
          .guard;

  @override
  AsyncResult<List<CartoonModel>?> cartoonFavoriteList({
    required int page,
    int limit = 15,
  }) =>
      _cartoonService
          .cartoonFavoriteList(page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(CartoonModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<CartoonModel>?> cartoonLikeList({
    required int page,
    int limit = 15,
  }) =>
      _cartoonService
          .cartoonLikeList(page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(CartoonModel.fromJson).toList())
          .guard;

  ///喜欢
  @override
  AsyncResult like({required int id}) =>
      _cartoonService.cartoonLike(id: id).deserialize().guard;

  ///收藏
  @override
  AsyncResult cartoonFavorite({required int id}) =>
      _cartoonService.cartoonFavorite(id: id).deserialize().guard;

  @override
  AsyncResult cartoonBuy({
    required int id,
  }) =>
      _cartoonService.cartoonBuy(id: id).deserialize().guard;

  @override
  AsyncResult<List<CartoonModel>?> cartoonBuyList({
    required int page,
    int limit = 15,
  }) =>
      _cartoonService
          .cartoonBuyList(page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(CartoonModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<CartoonModel>?> cartoonSearchList({
    required String word,
    required int page,
    int limit = 15,
  }) =>
      _cartoonService
          .cartoonSearchList(word: word, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(CartoonModel.fromJson).toList())
          .guard;

  @override
  AsyncResult cartoonComment({
    required String id,
    required String text,
  }) =>
      _cartoonService.cartoonComment(id: id, text: text).deserialize().guard;

  @override
  AsyncResult<List<CartoonCommentListModel>?> cartoonCommentList({
    required String id,
    required int page,
    int limit = 15,
  }) =>
      _cartoonService
          .cartoonCommentList(id: id, page: page, limit: limit)
          .deserializeJsonListBy(
              (e) => e.map(CartoonCommentListModel.fromJson).toList())
          .guard;

  @override

  ///下载
  AsyncResult download({
    required String id,
  }) =>
      _cartoonService.download(id: id).deserialize().guard;
}
