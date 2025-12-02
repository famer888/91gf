import 'package:jygf/domain/model/game/game_comment_model.dart';
import 'package:jygf/domain/model/game/game_detail_model.dart';

import '../../model/game/game_model.dart';
import '../../type_def.dart';

abstract class GameDomain {
  ///推荐
  AsyncResult gameRec({
    required int id,
    required int page,
    int limit,
  });

  ///更多
  AsyncResult<List<GameModel>?> gameMore({
    required String sort,
    required int page,
    int limit,
  });

  ///分类
  AsyncResult gameTheme({
    required int id,
    required String sort,
    required int page,
    int limit,
  });

  ///nav 热销/热门/最新/手游
  AsyncResult<List<GameModel>?> gameNav({
    required String type,
    required int page,
    int limit,
  });

  ///标签
  AsyncResult<List<GameModel>?> gameTag({
    required String tag,
    required String type,
    required int page,
    int limit = 15,
  });

  ///详情
  AsyncResult<GameDetailModel> gameDetail({
    required String id,
  });

  ///收藏列表
  AsyncResult<List<GameModel>?> gameFavoriteList({
    required int page,
    int limit,
  });

  ///点赞列表
  AsyncResult<List<GameModel>?> gameLikeList({
    required int page,
    int limit,
  });

  ///喜欢
  AsyncResult like({
    required int id,
  });

  ///收藏
  AsyncResult favorite({
    required int id,
  });

  ///购买
  AsyncResult gameBuy({
    required int id,
  });

  ///购买列表
  AsyncResult<List<GameModel>?> gameBuyList({
    required int page,
    int limit,
  });

  ///搜索列表
  AsyncResult<List<GameModel>?> gameSearchList({
    required String word,
    required int page,
    int limit,
  });

  ///搜索列表
  AsyncResult gameComment({
    required String id,
    required String text,
  });

  ///评论列表
  AsyncResult<List<GameCommentListModel>?> gameCommentList({
    required String id,
    required int page,
    int limit,
  });
}
