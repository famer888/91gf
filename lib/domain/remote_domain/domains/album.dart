import 'package:jygf/domain/model/album_model.dart';
import 'package:jygf/domain/model/video_comment_model.dart';
import 'package:jygf/domain/type_def.dart';

abstract class AlbumDomain {

  ///黄图推荐接口
  AsyncResult<RecAlbumWithBannersModel> albumReComment({
    required int page,
    required int limit,
  });

  ///除了推荐以外的其他分类列表
  AsyncResult<AlbumWithBannersModel> albumSortList({
    required int id, // AlbumNav字段下id的值
    required String sort, // AlbumSort字段下sort的值
    required int page,
    required int limit,
  });

  ///更多
  AsyncResult<List<AlbumItemsModel>?> albumMoreList({
    required String sort,
    required int page,
    required int limit,
  });
  
  ///搜索列表
  AsyncResult<List<AlbumItemsModel>?> albumSearchList({
    required String word,
    required int page,
    required int limit,
  });

  ///我的黄图收藏列表
  AsyncResult<List<AlbumItemsModel>?> albumFavoriteList({
    required int page,
    required int limit,
  });

  ///我的黄图购买列表
  AsyncResult<List<AlbumItemsModel>?> albumBuyList({
    required int page,
    required int limit,
  });

  ///黄图详情
  AsyncResult<AlbumDetailFartherModel> albumDetail({
    required int id,
  });

  ///黄图章节购买
  AsyncResult albumBuy({required int id});

  ///黄图评论
  AsyncResult albumComment({required int id, required String text});

  ///黄图评论列表
  AsyncResult<List<VideoCommentListModel>?> albumCommentList({
    required int limit,
    required int page,
    required int id,
  });

  ///标签色图列表
  AsyncResult<List<AlbumItemsModel>?> albumTagList({
    required String sort,
    required String tag,
    required int page,
    required int limit
  });
}
