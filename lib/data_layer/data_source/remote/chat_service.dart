import 'package:jygf/data_layer/data_source/remote/base_service.dart';
import 'package:jygf/domain/type_def.dart';

class ChatService extends BaseService {
  ChatService(super._dio);

  @override
  final service = 'chat';

  /// 获取裸聊列表
  AsyncJson chatIndex({
    required int id,
    required int page,
    required int limit,
  }) =>
      post('/index', data: {'id': id, 'page': page, 'limit': limit});

  /// 获取排序裸聊列表
  AsyncJson chatSortIndex({
    required String sort,
    required int page,
    required int limit,
  }) =>
      post('/list_sort', data: {'sort': sort, 'page': page, 'limit': limit});

  /// 裸聊详情
  AsyncJson chatDetail({
    required int id,
  }) =>
      post('/detail', data: {'id': id});

  // 发布裸聊信息
  AsyncJson chatCreate({
    required Map<String, dynamic> allInfo,
  }) =>
      post('/create', data: allInfo);

  // 解锁裸聊信息
  AsyncJson chatBuy({
    required int id,
  }) =>
      post('/buy', data: {'id': id});

  // 收藏
  AsyncJson chatFavorite({
    required int id,
  }) =>
      post('/favorite', data: {'id': id});

  /// 我的购买
  AsyncJson chatBuyList({
    required int page,
    required int limit,
  }) =>
      post('/list_buy', data: {
        'page': page,
        'limit': limit,
      });

  /// 他人发布
  AsyncJson chatPeerList({
    required int aff,
    required int page,
    required int limit,
  }) =>
      post('/list_peer', data: {
        'aff': aff,
        'page': page,
        'limit': limit,
      });

  /// 我的发布
  AsyncJson chatMyList({
    required int status, // 状态 1-待审核 2-已拒绝 3-处理中 4-已通过
    required int page,
    required int limit,
  }) =>
      post('/list_my', data: {
        'status': status,
        'page': page,
        'limit': limit,
      });

  /// 搜索
  AsyncJson chatSearchList({
    required String word,
    required int page,
    required int limit,
  }) =>
      post('/search', data: {
        'word': word,
        'page': page,
        'limit': limit,
      });

  /// 我的点赞列表
  AsyncJson chatLikeList({
    required int page,
    required int limit,
  }) =>
      post('/list_like', data: {
        'page': page,
        'limit': limit,
      });

  /// 我的收藏列表
  AsyncJson chatFavoriteList({
    required int page,
    required int limit,
  }) =>
      post('/list_favorite', data: {
        'page': page,
        'limit': limit,
      });

  /// 我的发布列表
  AsyncJson chatMineList({
    required int page,
    required int limit,
    required int status,
  }) =>
      post('/list_my', data: {
        'page': page,
        'limit': limit,
        'status': status,
      });
}
