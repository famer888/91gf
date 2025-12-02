part of '../repo.dart';

mixin _Message on _BaseAppRepo implements MessageDomain {
  @override
  AsyncResult<List<FeedBackData>?> getFeedbackList({required int page}) =>
      _messageService
          .getFeedbackList(page: page)
          .deserializeJsonListBy((e) => e.map(FeedBackData.fromJson).toList())
          .guard;

  @override
  AsyncJson sendFeeding({
    required String content,
    required int type,
    required int helpType,
  }) =>
      _messageService.sendFeeding(
        content: content,
        type: type,
        helpType: helpType,
      );

  @override
  AsyncResult<SystemNotice> getSystemNotice() => _messageService
      .getSystemNotice()
      .deserializeJsonBy(SystemNotice.fromJson)
      .guard;

  @override
  AsyncResult<List<NoticeMessage>?> getSystemNoticeList({
    required int page,
    required int limit,
  }) =>
      _messageService
          .getSystemNoticeList(page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(NoticeMessage.fromJson).toList())
          .guard;
}
