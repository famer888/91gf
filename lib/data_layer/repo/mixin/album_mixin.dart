part of '../repo.dart';

mixin _Album on _BaseAppRepo implements AlbumDomain {

  @override
  AsyncResult<RecAlbumWithBannersModel> albumReComment({
    required int page,
    required int limit,
  }) =>
      _albumService
          .albumReComment(
        page: page,
        limit: limit,
      )
          .deserializeJsonBy(RecAlbumWithBannersModel.fromJson)
          .guard;

  @override
  AsyncResult<AlbumWithBannersModel> albumSortList({
    required int id,
    required String sort,
    required int page,
    required int limit,
  }) =>
      _albumService
          .albumSortList(
        id: id,
        sort: sort,
        page: page,
        limit: limit,
      )
          .deserializeJsonBy(AlbumWithBannersModel.fromJson)
          .guard;

  @override
  AsyncResult<List<AlbumItemsModel>?> albumMoreList({
    required String sort,
    required int page,
    required int limit,
  }) =>
      _albumService
          .albumMoreList(
        sort: sort,
        page: page,
        limit: limit,
      )
          .deserializeJsonListBy(
              (e) => e.map(AlbumItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<AlbumItemsModel>?> albumSearchList({
    required String word,
    required int page,
    required int limit,
  }) =>
      _albumService
          .albumSearchList(
        word: word,
        page: page,
        limit: limit,
      )
          .deserializeJsonListBy(
              (e) => e.map(AlbumItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<AlbumItemsModel>?> albumFavoriteList({
    required int page,
    required int limit,
  }) =>
      _albumService
          .albumFavoriteList(
        page: page,
        limit: limit,
      )
          .deserializeJsonListBy(
              (e) => e.map(AlbumItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<AlbumItemsModel>?> albumBuyList({
    required int page,
    required int limit,
  }) =>
      _albumService
          .albumBuyList(
        page: page,
        limit: limit,
      )
          .deserializeJsonListBy(
              (e) => e.map(AlbumItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<AlbumDetailFartherModel> albumDetail({
    required int id,
  }) =>
      _albumService
          .albumDetail(id: id)
          .deserializeJsonBy(AlbumDetailFartherModel.fromJson)
          .guard;

  @override
  AsyncResult albumBuy({
    required int id,
  }) =>
      _albumService.albumBuy(id: id).deserialize().guard;

  @override
  AsyncResult albumComment({
    required int id,
    required String text,
  }) =>
      _albumService.albumComment(id: id, text: text).deserialize().guard;

  @override
  AsyncResult<List<VideoCommentListModel>?> albumCommentList(
      {required int limit, required int page, required int id}) =>
      _albumService
          .albumCommentList(id: id, page: page, limit: limit)
          .deserializeJsonListBy(
              (e) => e.map(VideoCommentListModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<AlbumItemsModel>?> albumTagList({
    required String sort,
    required String tag,
    required int page,
    required int limit,
  }) =>
      _albumService
          .albumTagList(
        sort: sort,
        tag: tag,
        page: page,
        limit: limit,
      )
          .deserializeJsonListBy(
              (e) => e.map(AlbumItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult albumLike({required int id}) =>
      _albumService.albumLike(id: id).deserialize().guard;

  @override
  AsyncResult albumFavorite({required int id}) =>
      _albumService.albumFavorite(id: id).deserialize().guard;

}
