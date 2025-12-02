import '../../../domain/type_def.dart';
import 'base_service.dart';

class LiveService extends BaseService {
  LiveService(super._dio);

  @override
  final service = 'live';

  /// 直播列表
  AsyncJson getLiveIndex({
    required int id,
    required int page,
    required int limit}) =>
      post('/index', data: {'id': id, 'page': page, 'limit': limit});

  /// 直播搜索
  AsyncJson getLiveSearch({
    required String word,
    required int page,
    required int limit}) =>
      post('/search', data: {'word': word, 'page': page, 'limit': limit});

  /// 直播详情
  AsyncJson getLiveDetail({required int id}) =>
      post('/detail', data: {'id': id});

  /// 直播推荐数据
  AsyncJson getLiveRecommend({
    required int id,
    required int page,
    required int limit}) =>
      post('/recommend', data: {'id': id, 'page': page, 'limit': limit});

  /// 直播收藏
  AsyncJson getLiveFavorite({required int id}) =>
      post('/favorite', data: {'id': id});

  /// 直播购买
  AsyncJson getLiveBuy({required int id}) =>
      post('/buy', data: {'id': id});

  /// 直播收藏列表
  AsyncJson getLiveListFavorite({required int page,
    required int limit}) =>
      post('/list_favorite', data: {'page': page, 'limit': limit});

  /// 直播已购买列表
  AsyncJson getLiveListBuy({required int page,
    required int limit}) =>
      post('/list_buy', data: {'page': page, 'limit': limit});

  /// 直播评论
  AsyncJson getLiveComment({
    required String text,
    required int id}) =>
      post('/comment', data: {'text': text, 'id': id});

  /// 直播评论列表
  AsyncJson getLiveListComment({
    required int id,
    required int page,
    required int limit}) =>
      post('/list_comment', data: {'id': id, 'page': page, 'limit': limit});

  /// 直播评论点赞
  AsyncJson getLiveLikeComment({required int id}) =>
      post('/like_comment', data: {'id': id});

  /// 直播打赏
  AsyncJson getLiveReward({required int id, required int coins}) =>
      post('/reward', data: {'id': id, 'coins': coins});

  /// 直播热门推荐列表
  AsyncJson getLiveRecListComment({
    required int page,
    required int limit}) =>
      post('/rec', data: {'page': page, 'limit': limit});


}
