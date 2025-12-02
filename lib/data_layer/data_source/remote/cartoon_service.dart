import 'package:jygf/data_layer/data_source/remote/base_service.dart';
import 'package:jygf/domain/type_def.dart';

class CartoonService extends BaseService {
  CartoonService(super._dio);

  @override
  final service = 'cartoon';

  ///动漫推荐
  AsyncJson cartoonRec({
    required int id,
    required int page,
    int limit = 15,
  }) =>
      post('/rec', data: {'id': id, 'page': page, 'limit': limit});

  ///更多
  AsyncJson cartoonMore({
    required String sort,
    required int page,
    int limit = 15,
  }) =>
      post('/more', data: {'sort': sort, 'page': page, 'limit': limit});

  ///分类
  AsyncJson cartoonTheme({
    required int id,
    required String sort,
    required int page,
    int limit = 15,
  }) =>
      post('/theme',
          data: {'id': id, 'sort': sort, 'page': page, 'limit': limit});

  ///详情
  AsyncJson cartoonDetail({
    required String id,
  }) =>
      post('/detail', data: {'id': id});

  ///收藏列表
  AsyncJson cartoonFavoriteList({
    required int page,
    int limit = 15,
  }) =>
      post('/list_favorite', data: {'page': page, 'limit': limit});

  ///点赞列表
  AsyncJson cartoonLikeList({
    required int page,
    int limit = 15,
  }) =>
      post('/list_like', data: {'page': page, 'limit': limit});

  ///喜欢
  AsyncJson cartoonLike({
    required int id,
  }) =>
      post('/like', data: {
        'id': id,
      });

  ///收藏
  AsyncJson cartoonFavorite({
    required int id,
  }) =>
      post('/favorite', data: {
        'id': id,
      });

  ///购买
  AsyncJson cartoonBuy({
    required int id,
  }) =>
      post('/buy', data: {
        'id': id,
      });

  ///购买列表
  AsyncJson cartoonBuyList({
    required int page,
    int limit = 15,
  }) =>
      post('/list_buy', data: {'page': page, 'limit': limit});

  ///搜索列表
  AsyncJson cartoonSearchList({
    required String word,
    required int page,
    int limit = 15,
  }) =>
      post('/search', data: {'word': word, 'page': page, 'limit': limit});

  ///搜索列表
  AsyncJson cartoonComment({
    required String id,
    required String text,
  }) =>
      post('/comment', data: {'id': id, 'text': text});

  ///评论列表
  AsyncJson cartoonCommentList({
    required String id,
    required int page,
    int limit = 15,
  }) =>
      post('/list_comment', data: {'id': id, 'page': page, 'limit': limit});

  ///下载
  AsyncJson download({
    required String id,
  }) =>
      post('/download', data: {'id': id});
}
