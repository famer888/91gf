import 'package:jygf/data_layer/data_source/remote/base_service.dart';
import 'package:jygf/domain/type_def.dart';

class GameService extends BaseService {
  GameService(super._dio);

  @override
  final service = 'game';

  ///动漫推荐
  AsyncJson gameRec({
    required int id,
    required int page,
    int limit = 15,
  }) =>
      post('/rec', data: {'id': id, 'page': page, 'limit': limit});

  ///更多
  AsyncJson gameMore({
    required String sort,
    required int page,
    int limit = 15,
  }) =>
      post('/more', data: {'sort': sort, 'page': page, 'limit': limit});

  ///分类
  AsyncJson gameTheme({
    required int id,
    required String sort,
    required int page,
    int limit = 15,
  }) =>
      post('/theme',
          data: {'id': id, 'sort': sort, 'page': page, 'limit': limit});

  ///分类
  AsyncJson gameNav({
    required String type,
    required int page,
    int limit = 15,
  }) =>
      post('/nav', data: {'type': type, 'page': page, 'limit': limit});

  ///标签
  AsyncJson gameTag({
    required String tag,
    required String type,
    required int page,
    int limit = 15,
  }) =>
      post('/tag',
          data: {'tag': tag, 'type': type, 'page': page, 'limit': limit});

  ///详情
  AsyncJson gameDetail({
    required String id,
  }) =>
      post('/detail', data: {'id': id});

  ///收藏列表
  AsyncJson gameFavoriteList({
    required int page,
    int limit = 15,
  }) =>
      post('/list_favorite', data: {'page': page, 'limit': limit});

  ///点赞列表
  AsyncJson gameLikeList({
    required int page,
    int limit = 15,
  }) =>
      post('/list_like', data: {'page': page, 'limit': limit});

  ///喜欢
  AsyncJson like({
    required int id,
  }) =>
      post('/like', data: {
        'id': id,
      });

  ///收藏
  AsyncJson favorite({
    required int id,
  }) =>
      post('/favorite', data: {
        'id': id,
      });

  ///购买
  AsyncJson gameBuy({
    required int id,
  }) =>
      post('/buy', data: {
        'id': id,
      });

  ///购买列表
  AsyncJson gameBuyList({
    required int page,
    int limit = 15,
  }) =>
      post('/list_buy', data: {'page': page, 'limit': limit});

  ///搜索列表
  AsyncJson gameSearchList({
    required String word,
    required int page,
    int limit = 15,
  }) =>
      post('/search', data: {'word': word, 'page': page, 'limit': limit});

  ///搜索列表
  AsyncJson gameComment({
    required String id,
    required String text,
  }) =>
      post('/comment', data: {'id': id, 'text': text});

  ///评论列表
  AsyncJson gameCommentList({
    required String id,
    required int page,
    int limit = 15,
  }) =>
      post('/list_comment', data: {'id': id, 'page': page, 'limit': limit});
}
