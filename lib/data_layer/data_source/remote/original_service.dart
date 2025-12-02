import '../../../domain/type_def.dart';
import 'base_service.dart';

class OriginalService extends BaseService {
  OriginalService(super._dio);

  @override
  final service = 'original';

  ///发帖获取全部标签
  AsyncJson originalTopics({
    required int page,
    required int limit,
  }) =>
      post('/topics', data: {
        'page': page,
        'limit': limit,
      });
}
