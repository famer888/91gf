import 'package:jygf/domain/model/cartoon/cartoon_comment_model.dart';

import '../../model/cartoon/cartoon_model.dart';
import '../../type_def.dart';

abstract class CartoonDomain {
  ///动漫推荐
  AsyncResult cartoonRec({
    required int id,
    required int page,
    int limit,
  });

  ///更多
  AsyncResult<List<CartoonModel>?> cartoonMore({
    required String sort,
    required int page,
    int limit,
  });

  ///分类
  AsyncResult cartoonTheme({
    required int id,
    required String sort,
    required int page,
    int limit,
  });

  ///详情
  AsyncResult cartoonDetail({
    required String id,
  });

  ///收藏列表
  AsyncResult<List<CartoonModel>?> cartoonFavoriteList({
    required int page,
    int limit,
  });

  ///点赞列表
  AsyncResult<List<CartoonModel>?> cartoonLikeList({
    required int page,
    int limit,
  });

  ///喜欢
  AsyncResult like({
    required int id,
  });

  ///收藏
  AsyncResult cartoonFavorite({
    required int id,
  });

  ///购买
  AsyncResult cartoonBuy({
    required int id,
  });

  ///购买列表
  AsyncResult<List<CartoonModel>?> cartoonBuyList({
    required int page,
    int limit,
  });

  ///搜索列表
  AsyncResult<List<CartoonModel>?> cartoonSearchList({
    required String word,
    required int page,
    int limit,
  });

  ///搜索列表
  AsyncResult cartoonComment({
    required String id,
    required String text,
  });

  ///评论列表
  AsyncResult<List<CartoonCommentListModel>?> cartoonCommentList({
    required String id,
    required int page,
    int limit,
  });

  ///下载
  AsyncResult download({
    required String id,
  });
}
