part of '../repo.dart';

// import 'package:dio/dio.dart';
// import 'package:jygf/data_layer/data_source/remote/game_service.dart';
// import 'package:jygf/domain/model/game/game_comment_model.dart';
// import 'package:jygf/domain/model/game/game_model.dart';
// import 'package:jygf/domain/remote_domain/domains/game.dart';
// import 'package:jygf/domain/result.dart';
// import 'package:jygf/domain/type_def.dart';

// mixin _Game on _BaseAppRepo implements GameDomain {

mixin _Game on _BaseAppRepo implements GameDomain {
  // GameService _gameService = GameService(Dio()).guard;

// mixin _Game on _BaseAppRepo implements GameDomain {
  @override
  AsyncResult gameRec({
    required int id,
    required int page,
    int limit = 15,
  }) =>
      _gameService.gameRec(id: id, page: page).deserialize().guard;

  ///更多
  @override
  AsyncResult<List<GameModel>?> gameMore({
    required String sort,
    required int page,
    int limit = 15,
  }) =>
      _gameService
          .gameMore(sort: sort, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(GameModel.fromJson).toList())
          .guard;

  ///分类
  @override
  AsyncResult gameTheme({
    required int id,
    required String sort,
    required int page,
    int limit = 15,
  }) =>
      _gameService
          .gameTheme(id: id, sort: sort, page: page, limit: limit)
          .deserialize()
          .guard;

  ///nav 热销/热门/最新/手游
  @override
  AsyncResult<List<GameModel>?> gameNav({
    required String type,
    required int page,
    int limit = 15,
  }) =>
      _gameService
          .gameNav(type: type, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(GameModel.fromJson).toList())
          .guard;

  ///标签
  @override
  AsyncResult<List<GameModel>?> gameTag({
    required String tag,
    required String type,
    required int page,
    int limit = 15,
  }) =>
      _gameService
          .gameTag(tag: tag, type: type, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(GameModel.fromJson).toList())
          .guard;

  ///详情
  @override
  AsyncResult<GameDetailModel> gameDetail({
    required String id,
  }) =>
      _gameService
          .gameDetail(id: id)
          .deserializeJsonBy(GameDetailModel.fromJson)
          .guard;
  // .deserializeJsonBy(GameDetailModel.fromJson)
  // .guard;

  ///收藏列表
  @override
  AsyncResult<List<GameModel>?> gameFavoriteList({
    required int page,
    int limit = 15,
  }) =>
      _gameService
          .gameFavoriteList(page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(GameModel.fromJson).toList())
          .guard;

  ///点赞列表
  @override
  AsyncResult<List<GameModel>?> gameLikeList({
    required int page,
    int limit = 15,
  }) =>
      _gameService
          .gameLikeList(page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(GameModel.fromJson).toList())
          .guard;

  ///喜欢
  @override
  AsyncResult like({required int id}) =>
      _gameService.like(id: id).deserialize().guard;

  ///收藏
  @override
  AsyncResult favorite({required int id}) =>
      _gameService.favorite(id: id).deserialize().guard;

  ///购买
  @override
  AsyncResult gameBuy({
    required int id,
  }) =>
      _gameService.gameBuy(id: id).deserialize().guard;

  ///购买列表
  @override
  AsyncResult<List<GameModel>?> gameBuyList({
    required int page,
    int limit = 15,
  }) =>
      _gameService
          .gameBuyList(page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(GameModel.fromJson).toList())
          .guard;

  ///搜索列表
  @override
  AsyncResult<List<GameModel>?> gameSearchList({
    required String word,
    required int page,
    int limit = 15,
  }) =>
      _gameService
          .gameSearchList(word: word, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(GameModel.fromJson).toList())
          .guard;

  ///搜索列表
  @override
  AsyncResult gameComment({
    required String id,
    required String text,
  }) =>
      _gameService.gameComment(id: id, text: text).deserialize().guard;

  ///评论列表
  @override
  AsyncResult<List<GameCommentListModel>?> gameCommentList({
    required String id,
    required int page,
    int limit = 15,
  }) =>
      _gameService
          .gameCommentList(id: id, page: page, limit: limit)
          .deserializeJsonListBy(
              (e) => e.map(GameCommentListModel.fromJson).toList())
          .guard;
}
