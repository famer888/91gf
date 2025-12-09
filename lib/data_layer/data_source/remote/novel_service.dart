import 'package:jygf/data_layer/data_source/remote/base_service.dart';
import 'package:jygf/domain/type_def.dart';

class NovelService extends BaseService {
  NovelService(super._dio);

  @override
  final service = 'novel';

  AsyncJson novelReComment({required int page, required int limit}) =>
      post('/rec', data: {'page': page, 'limit': limit});

  AsyncJson novelSortList(
          {required int id,
          required String sort,
          required int page,
          required int limit}) =>
      post('/more',
          data: {'id': id, 'sort': sort, 'page': page, 'limit': limit});

  AsyncJson novelMoreList(
      {required String sort,
        required int page,
        required int limit}) =>
      post('/rec_more',
          data: {'sort': sort, 'page': page, 'limit': limit});

  AsyncJson novelTypeList(
          {required String themeId,
          required String sort,
          required String end,
          required int page,
          required int limit}) =>
      post('/type', data: {
        'theme_id': themeId,
        'sort': sort,
        'end': end,
        'page': page,
        'limit': limit
      });

  AsyncJson novelNewList({required int page, required int limit}) =>
      post('/new', data: {'page': page, 'limit': limit});

  AsyncJson novelUpdatingList({required int page, required int limit}) =>
      post('/serialize', data: {'page': page, 'limit': limit});

  AsyncJson novelEndList({required int page, required int limit}) =>
      post('/end', data: {'page': page, 'limit': limit});

  AsyncJson novelSearchList(
          {required String word, required int page, required int limit}) =>
      post('/search', data: {'word': word, 'page': page, 'limit': limit});

  AsyncJson novelFavoriteList({required int page, required int limit}) =>
      post('/list_favorite', data: {'page': page, 'limit': limit});

  AsyncJson novelDetail({required int id}) => post('/detail', data: {'id': id});

  AsyncJson novelBuyList({required int page, required int limit}) =>
      post('/list_buy', data: {'page': page, 'limit': limit});

  AsyncJson novelBuy({required int id}) => post('/buy', data: {'id': id});

  AsyncJson novelComment({required int id, required String text}) =>
      post('/comment', data: {'id': id, 'text': text});

  AsyncJson novelCommentList(
          {required int id, required int page, required int limit}) =>
      post('/list_comment', data: {'id': id, 'page': page, 'limit': limit});

  AsyncJson novelFollowSubject({required int id}) =>
      post('/follow', data: {'id': id});

  AsyncJson novelFollowSubjectList({required int page, required int limit}) =>
      post('/list_follow_theme', data: {'page': page, 'limit': limit});

  AsyncJson novelFollowSubjectNovelsList(
          {required int page, required int limit}) =>
      post('/list_follow_novel', data: {'page': page, 'limit': limit});

  AsyncJson novelSeeList({required int page, required int limit}) =>
      post('/cutover', data: {'page': page, 'limit': limit});
}
