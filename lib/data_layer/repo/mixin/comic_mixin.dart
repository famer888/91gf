part of '../repo.dart';

mixin _Comic on _BaseAppRepo implements ComicDomain {
  @override
  AsyncResult<RecComicWithBannersModel> comicReComment({
    required int id,
    required int page,
    required int limit,
  }) =>
      _comicService
          .comicReComment(
            id: id,
            page: page,
            limit: limit,
          )
          .deserializeJsonBy(RecComicWithBannersModel.fromJson)
          .guard;

  @override
  AsyncResult<List<ComicItemsModel>?> comicMoreChangeList({
    required String sort,
    required int page,
    required int limit,
  }) =>
      _comicService
          .comicMoreChangeList(
            sort: sort,
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy(
              (e) => e.map(ComicItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<ComicWithBannersModel> comicThemeList({
    required int id,
    required String sort,
    required int page,
    required int limit,
  }) =>
      _comicService
          .comicThemeList(
            id: id,
            sort: sort,
            page: page,
            limit: limit,
          )
          .deserializeJsonBy(ComicWithBannersModel.fromJson)
          .guard;

  @override
  AsyncResult<List<ComicItemsModel>?> comicTypeList(
          {required String themeId,
          required String sort,
          required String end,
          required int page,
          required int limit}) =>
      _comicService
          .comicTypeList(
            themeId: themeId,
            sort: sort,
            end: end,
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy(
              (e) => e.map(ComicItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<ComicItemsModel>?> comicNewList({
    required int page,
    required int limit,
  }) =>
      _comicService
          .comicNewList(
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy(
              (e) => e.map(ComicItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<ComicItemsModel>?> comicEndList({
    required int page,
    required int limit,
  }) =>
      _comicService
          .comicEndList(
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy(
              (e) => e.map(ComicItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<ComicItemsModel>?> comicRankList({
    required int page,
    required int limit,
  }) =>
      _comicService
          .comicRankList(
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy(
              (e) => e.map(ComicItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<ComicItemsModel>?> comicSearchList({
    required String word,
    required int page,
    required int limit,
  }) =>
      _comicService
          .comicSearchList(
            word: word,
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy(
              (e) => e.map(ComicItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<ComicItemsModel>?> comicFavoriteList({
    required int page,
    required int limit,
  }) =>
      _comicService
          .comicFavoriteList(
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy(
              (e) => e.map(ComicItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<ComicItemsModel>?> comicBuyList({
    required int page,
    required int limit,
  }) =>
      _comicService
          .comicBuyList(
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy(
              (e) => e.map(ComicItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<ComicDetailWithBannersModel> comicDetail({
    required int id,
  }) =>
      _comicService
          .comicDetail(id: id)
          .deserializeJsonBy(ComicDetailWithBannersModel.fromJson)
          .guard;

  @override
  AsyncResult<ChaptersDetaiModel> comicChapterDetail({
    required int id,
  }) =>
      _comicService
          .comicChapterDetail(id: id)
          .deserializeJsonBy(ChaptersDetaiModel.fromJson)
          .guard;

  @override
  AsyncResult comicBuy({
    required int id,
  }) =>
      _comicService.comicBuy(id: id).deserialize().guard;

  @override
  AsyncResult comicComment({
    required int id,
    required String text,
  }) =>
      _comicService.comicComment(id: id, text: text).deserialize().guard;

  @override
  AsyncResult<List<VideoCommentListModel>?> comicCommentList(
          {required int limit, required int page, required int id}) =>
      _comicService
          .comicCommentList(id: id, page: page, limit: limit)
          .deserializeJsonListBy(
              (e) => e.map(VideoCommentListModel.fromJson).toList())
          .guard;

  @override
  AsyncResult comicLike({required int id}) =>
      _comicService.comicLike(id: id).deserialize().guard;

  @override
  AsyncResult comicFavorite({required int id}) =>
      _comicService.comicFavorite(id: id).deserialize().guard;
}
