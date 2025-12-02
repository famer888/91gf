import '../../../domain/type_def.dart';
import 'base_service.dart';

class MessageService extends BaseService {
  MessageService(super._dio);

  @override
  final service = 'message';

  /// 工单列表
  AsyncJson getFeedbackList({required int page}) =>
      post('/feedback', data: {'page': page});

  ///
  AsyncJson getSystemNotice() => post('/getUnreadCount');

  /// 工单列表
  AsyncJson sendFeeding({
    required String content,
    required int type,
    required int helpType,
  }) =>
      post('/feeding', data: {
        'content': content,
        'type': type,
        'helpType': helpType,
      });

  ///
  AsyncJson getSystemNoticeList({
    required int page,
    required int limit,
  }) =>
      post('/getSystemNoticeList', data: {
        'page': page,
        'limit': limit,
      });
}
