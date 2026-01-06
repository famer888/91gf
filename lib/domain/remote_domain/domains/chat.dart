import 'package:jygf/domain/model/chat/chat_detail_model.dart';
import 'package:jygf/domain/model/chat/chat_index_model.dart';
import 'package:jygf/domain/model/chat/chat_list_model.dart';
import 'package:jygf/domain/type_def.dart';

abstract class ChatDomain {
  /// 裸聊信息列表
  AsyncResult<ChatIndexModel> chatIndex({
    required int id,
    required int page,
    required int limit,
  });

    /// 裸聊排序信息列表
  AsyncResult<ChatIndexModel> chatSortIndex({
    required String sort,
    required int page,
    required int limit,
  });

  /// 裸聊详情
  AsyncResult<ChatDetailModel> chatDetail({
    required int id,
  });

  // 发布裸聊信息
  AsyncJson chatCreate({
    required Map<String, dynamic> allInfo,
  });

  // 解锁裸聊信息
  AsyncJson chatBuy({
    required int id,
  });

  // 收藏
  AsyncJson chatFavorite({
    required int id,
  });

  /// 我的购买
  AsyncResult<List<ChatListModel>> chatBuyList({
    required int page,
    required int limit,
  });

  /// 他人发布
  AsyncResult<List<ChatListModel>> chatPeerList({
    required int aff,
    required int page,
    required int limit,
  });

  /// 我的发布
  AsyncResult<List<ChatListModel>> chatMyList({
    required int status, // 状态 1-待审核 2-已拒绝 3-处理中 4-已通过
    required int page,
    required int limit,
  });

  /// 搜索
  AsyncResult<List<ChatListChatModel>> chatSearchList({
    required String word,
    required int page,
    required int limit,
  });

  /// 我的点赞列表
  AsyncResult<List<ChatListModel>> chatLikeList({
    required int page,
    required int limit,
  });

  /// 我的收藏列表
  AsyncResult<List<ChatListModel>> chatFavoriteList({
    required int page,
    required int limit,
  });

  /// 我的发布列表
  AsyncResult<List<ChatListModel>> chatMineList({
    required int page,
    required int limit,
    required int status,
  });
}
