import 'package:jygf/data_layer/data_source/remote/base_service.dart';
import 'package:jygf/domain/type_def.dart';

class AlbumService extends BaseService {
  AlbumService(super._dio);

  @override
  final service = 'album';

  AsyncJson albumReComment({required int page, required int limit}) =>
      post('/rec', data: {'page': page, 'limit': limit});

  AsyncJson albumSortList(
          {required int id,
          required String sort,
          required int page,
          required int limit}) =>
      post('/more',
          data: {'id': id, 'sort': sort, 'page': page, 'limit': limit});

  AsyncJson albumMoreList(
      {required String sort,
        required int page,
        required int limit}) =>
      post('/rec_more',
          data: {'sort': sort, 'page': page, 'limit': limit});

  AsyncJson albumSearchList(
          {required String word, required int page, required int limit}) =>
      post('/search', data: {'word': word, 'page': page, 'limit': limit});

  AsyncJson albumFavoriteList({required int page, required int limit}) =>
      post('/list_favorite', data: {'page': page, 'limit': limit});

  AsyncJson albumDetail({required int id}) => post('/detail', data: {'id': id});

  AsyncJson albumBuyList({required int page, required int limit}) =>
      post('/list_buy', data: {'page': page, 'limit': limit});

  AsyncJson albumBuy({required int id}) => post('/buy', data: {'id': id});

  AsyncJson albumComment({required int id, required String text}) =>
      post('/comment', data: {'id': id, 'text': text});

  AsyncJson albumCommentList(
          {required int id, required int page, required int limit}) =>
      post('/list_comment', data: {'id': id, 'page': page, 'limit': limit});

  AsyncJson albumTagList(
      {required String sort, required String tag, required int page, required int limit}) =>
      post('/list_tag_album', data: {'sort': sort, 'tag': tag, 'page': page, 'limit': limit});

}
