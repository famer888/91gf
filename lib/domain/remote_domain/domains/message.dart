import '../../model/feedback_data_model.dart';
import '../../model/notice_message.dart';
import '../../model/system_notice_model.dart';
import '../../type_def.dart';

abstract class MessageDomain {
  /// 工单列表
  AsyncResult<List<FeedBackData>?> getFeedbackList({required int page});

  /// 工单列表
  AsyncJson sendFeeding(
      {required String content, required int type, required int helpType});

  /// 取得系统消息及官方客服信息
  AsyncResult<SystemNotice> getSystemNotice();

  /// 取得系统消息列表
  AsyncResult<List<NoticeMessage>?> getSystemNoticeList({
    required int page,
    required int limit,
  });
}
