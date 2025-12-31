part of '../repo.dart';

mixin _Chat on _BaseAppRepo implements ChatDomain {
  @override
  AsyncResult<ChatIndexModel> chatIndex({
    required int id,
    required int page,
    required int limit,
  }) =>
      _chatService
          .chatIndex(id: id, page: page, limit: limit)
          .deserializeJsonBy(ChatIndexModel.fromJson)
          .guard;

  @override
  AsyncResult<ChatIndexModel> chatSortIndex({
    required String sort,
    required int page,
    required int limit,
  }) =>
      _chatService
          .chatSortIndex(sort: sort, page: page, limit: limit)
          .deserializeJsonBy(ChatIndexModel.fromJson)
          .guard;

  @override
  AsyncResult<ChatDetailModel> chatDetail({
    required int id,
  }) =>
      _chatService
          .chatDetail(id: id)
          .deserializeJsonBy(ChatDetailModel.fromJson)
          .guard;

  @override
  AsyncJson chatCreate({
    required Map<String, dynamic> allInfo,
  }) =>
      _chatService.chatCreate(allInfo: allInfo);

  @override
  AsyncJson chatBuy({
    required int id,
  }) =>
      _chatService.chatBuy(id: id);

  @override
  AsyncJson chatFavorite({
    required int id,
  }) =>
      _chatService.chatFavorite(id: id);

  @override
  AsyncResult<List<ChatListModel>> chatBuyList({
    required int page,
    required int limit,
  }) =>
      _chatService
          .chatBuyList(page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(ChatListModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<ChatListModel>> chatPeerList({
    required int aff,
    required int page,
    required int limit,
  }) =>
      _chatService
          .chatPeerList(aff: aff, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(ChatListModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<ChatListModel>> chatMyList({
    required int status, // 状态 1-待审核 2-已拒绝 3-处理中 4-已通过
    required int page,
    required int limit,
  }) =>
      _chatService
          .chatMyList(status: status, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(ChatListModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<ChatListModel>> chatSearchList({
    required String word,
    required int page,
    required int limit,
  }) =>
      _chatService
          .chatSarchList(word: word, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(ChatListModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<ChatListModel>> chatLikeList({
    required int page,
    required int limit,
  }) =>
      _chatService
          .chatLikeList(page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(ChatListModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<ChatListModel>> chatFavoriteList({
    required int page,
    required int limit,
  }) =>
      _chatService
          .chatFavoriteList(page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(ChatListModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<ChatListModel>> chatMineList({
    required int page,
    required int limit,
    required int status,
  }) =>
      _chatService
          .chatMineList(page: page, limit: limit, status: status)
          .deserializeJsonListBy((e) => e.map(ChatListModel.fromJson).toList())
          .guard;
}
