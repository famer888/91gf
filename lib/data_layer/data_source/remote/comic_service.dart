import 'package:jygf/data_layer/data_source/remote/base_service.dart';
import 'package:jygf/domain/type_def.dart';

class ComicService extends BaseService {
  ComicService(super._dio);

  @override
  final service = 'comic';

  AsyncJson comicReComment(
          {required int id, required int page, required int limit}) =>
      post('/rec', data: {'id': id, 'page': page, 'limit': limit});

  AsyncJson comicMoreChangeList(
          {required String sort, required int page, required int limit}) =>
      post('/more', data: {'sort': sort, 'page': page, 'limit': limit});

  AsyncJson comicThemeList(
          {required int id,
          required String sort,
          required int page,
          required int limit}) =>
      post('/theme',
          data: {'id': id, 'sort': sort, 'page': page, 'limit': limit});

  AsyncJson comicTypeList(
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

  AsyncJson comicNewList({required int page, required int limit}) =>
      post('/new', data: {'page': page, 'limit': limit});

  AsyncJson comicEndList({required int page, required int limit}) =>
      post('/end', data: {'page': page, 'limit': limit});

  AsyncJson comicRankList({required int page, required int limit}) =>
      post('/rank', data: {'page': page, 'limit': limit});

  AsyncJson comicSearchList(
          {required String word, required int page, required int limit}) =>
      post('/search', data: {'word': word, 'page': page, 'limit': limit});

  AsyncJson comicFavoriteList({required int page, required int limit}) =>
      post('/list_favorite', data: {'page': page, 'limit': limit});

  AsyncJson comicBuyList({required int page, required int limit}) =>
      post('/list_buy', data: {'page': page, 'limit': limit});

  AsyncJson comicDetail(
      {required int id}) =>
      post('/detail', data: {'id': id});

  AsyncJson comicChapterDetail(
      {required int id}) =>
      post('/chapter_detail', data: {'id': id});

  AsyncJson comicBuy({required int id}) => post('/buy', data: {'id': id});

  AsyncJson comicComment({required int id, required String text}) =>
      post('/comment', data: {'id': id, 'text': text});

  AsyncJson comicCommentList(
      {required int id, required int page, required int limit}) =>
      post('/list_comment', data: {'id': id, 'page': page, 'limit': limit});

  AsyncJson comicLike({required int id}) => post('/like', data: {'id': id});

  AsyncJson comicFavorite({required int id}) => post('/favorite', data: {'id': id});

}
