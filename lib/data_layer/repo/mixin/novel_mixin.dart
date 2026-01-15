part of '../repo.dart';

mixin _Novel on _BaseAppRepo implements NovelDomain {
  @override
  AsyncResult<RecNovelWithBannersModel> novelReComment({
    required int page,
    required int limit,
  }) =>
      _novelService
          .novelReComment(
            page: page,
            limit: limit,
          )
          .deserializeJsonBy(RecNovelWithBannersModel.fromJson)
          .guard;

  @override
  AsyncResult<NovelWithBannersModel?> novelSortList({
    required int id,
    required String sort,
    required int page,
    required int limit,
  }) =>
      _novelService
          .novelSortList(
            id: id,
            sort: sort,
            page: page,
            limit: limit,
          )
          .deserializeJsonBy(NovelWithBannersModel.fromJson)
          .guard;

  @override
  AsyncResult<List<NovelItemsModel>?> novelMoreList(
      {required String sort,
        required int page,
        required int limit}) =>
      _novelService
          .novelMoreList(
        sort: sort,
        page: page,
        limit: limit,
      )
          .deserializeJsonListBy(
              (e) => e.map(NovelItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<NovelItemsModel>?> novelTypeList(
          {required String themeId,
          required String sort,
          required String end,
          required int page,
          required int limit}) =>
      _novelService
          .novelTypeList(
            themeId: themeId,
            sort: sort,
            end: end,
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy(
              (e) => e.map(NovelItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<NovelItemsModel>?> novelNewList({
    required int page,
    required int limit,
  }) =>
      _novelService
          .novelNewList(
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy(
              (e) => e.map(NovelItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<NovelItemsModel>?> novelEndList({
    required int page,
    required int limit,
  }) =>
      _novelService
          .novelEndList(
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy(
              (e) => e.map(NovelItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<NovelItemsModel>?> novelUpdatingList({
    required int page,
    required int limit,
  }) =>
      _novelService
          .novelUpdatingList(
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy(
              (e) => e.map(NovelItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<NovelItemsModel>?> novelSearchList({
    required String word,
    required int page,
    required int limit,
  }) =>
      _novelService
          .novelSearchList(
            word: word,
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy(
              (e) => e.map(NovelItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<NovelItemsModel>?> novelFavoriteList({
    required int page,
    required int limit,
  }) =>
      _novelService
          .novelFavoriteList(
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy(
              (e) => e.map(NovelItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<NovelItemsModel>?> novelBuyList({
    required int page,
    required int limit,
  }) =>
      _novelService
          .novelBuyList(
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy(
              (e) => e.map(NovelItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<NovelDetailWithBannersModel> novelDetail({
    required int id,
  }) =>
      _novelService
          .novelDetail(id: id)
          .deserializeJsonBy(NovelDetailWithBannersModel.fromJson)
          .guard;

  @override
  AsyncResult novelBuy({
    required int id,
  }) =>
      _novelService.novelBuy(id: id).deserialize().guard;

  @override
  AsyncResult novelComment({
    required int id,
    required String text,
  }) =>
      _novelService.novelComment(id: id, text: text).deserialize().guard;

  @override
  AsyncResult<List<VideoCommentListModel>?> novelCommentList(
          {required int limit, required int page, required int id}) =>
      _novelService
          .novelCommentList(id: id, page: page, limit: limit)
          .deserializeJsonListBy(
              (e) => e.map(VideoCommentListModel.fromJson).toList())
          .guard;

  @override
  AsyncResult novelFollowSubject({
    required int id,
  }) =>
      _novelService.novelFollowSubject(id: id).deserialize().guard;

  @override
  AsyncResult<NovelSubjectListModel> novelFollowSubjectList({
    required int page,
    required int limit,
  }) =>
      _novelService
          .novelFollowSubjectList(
            page: page,
            limit: limit,
          )
          .deserializeJsonBy(NovelSubjectListModel.fromJson)
          .guard;

  @override
  AsyncResult<NovelSubjectNovelListModel> novelFollowSubjectNovelsList({
    required int page,
    required int limit,
  }) =>
      _novelService
          .novelFollowSubjectNovelsList(
            page: page,
            limit: limit,
          )
          .deserializeJsonBy(NovelSubjectNovelListModel.fromJson)
          .guard;

  @override
  AsyncResult<List<NovelItemsModel>?> novelSeeList({
    required int page,
    required int limit,
  }) =>
      _novelService
          .novelSeeList(
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy(
              (e) => e.map(NovelItemsModel.fromJson).toList())
          .guard;

  @override
  AsyncResult novelFavorite({required int id}) =>
      _novelService.novelFavorite(id: id).deserialize().guard;

  @override
  AsyncResult novelLike({required int id}) =>
      _novelService.novelLike(id: id).deserialize().guard;
}
