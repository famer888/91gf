import 'package:jygf/domain/model/novel_model.dart';
import 'package:jygf/domain/model/video_comment_model.dart';
import 'package:jygf/domain/type_def.dart';

abstract class NovelDomain {

  ///小说推荐接口
  AsyncResult<RecNovelWithBannersModel> novelReComment({
    required int page,
    required int limit,
  });

  ///除了推荐以外的其他分类列表
  AsyncResult<NovelWithBannersModel?> novelSortList({
    required int id, // novelNav字段下id的值
    required String sort, // novelSort字段下sort的值
    required int page,
    required int limit,
  });

  ///更多
  AsyncResult<List<NovelItemsModel>?> novelMoreList({
    required String sort,
    required int page,
    required int limit,
  });

  ///分类筛选列表
  AsyncResult<List<NovelItemsModel>?> novelTypeList({
    required String themeId, //分类ID
    required String sort, // 分类排序
    required String end, //是否完结
    required int page,
    required int limit,
  });

  ///最新列表
  AsyncResult<List<NovelItemsModel>?> novelNewList({
    required int page,
    required int limit,
  });

  ///连载列表
  AsyncResult<List<NovelItemsModel>?> novelUpdatingList({
    required int page,
    required int limit,
  });

  ///完结列表
  AsyncResult<List<NovelItemsModel>?> novelEndList({
    required int page,
    required int limit,
  });

  ///搜索列表
  AsyncResult<List<NovelItemsModel>?> novelSearchList({
    required String word,
    required int page,
    required int limit,
  });

  ///我的小说收藏列表
  AsyncResult<List<NovelItemsModel>?> novelFavoriteList({
    required int page,
    required int limit,
  });

  ///我的小说购买列表
  AsyncResult<List<NovelItemsModel>?> novelBuyList({
    required int page,
    required int limit,
  });

  ///小说详情
  AsyncResult<NovelDetailWithBannersModel> novelDetail({
    required int id,
  });

  ///小说章节购买
  AsyncResult novelBuy({required int id});

  ///小说评论
  AsyncResult novelComment({required int id, required String text});

  ///小说评论列表
  AsyncResult<List<VideoCommentListModel>?> novelCommentList({
    required int limit,
    required int page,
    required int id,
  });

  ///小说关注专题
  AsyncResult novelFollowSubject({required int id});

  ///关注的小说专题列表
  AsyncResult<NovelSubjectListModel> novelFollowSubjectList({
    required int page,
    required int limit,
  });

  ///关注的专题中包含的小说列表
  AsyncResult<NovelSubjectNovelListModel> novelFollowSubjectNovelsList({
    required int page,
    required int limit,
  });

  ///大家都在看
  AsyncResult<List<NovelItemsModel>?> novelSeeList({
    required int page,
    required int limit,
  });

  ///小说收藏
  AsyncResult novelFavorite({required int id});

  ///小说点赞
  AsyncResult novelLike({required int id});
}
