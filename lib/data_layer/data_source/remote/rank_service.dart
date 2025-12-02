import 'package:jygf/data_layer/data_source/remote/base_service.dart';
import 'package:jygf/domain/type_def.dart';

class RankService extends BaseService {
  RankService(super._dio);

  @override
  final service = 'rank';

  /// 视频排行榜
  AsyncJson rankMVList({
    required String type,
    required String cycle,
  }) =>
      post('/mv', data: {
        'type': type,
        'cycle': cycle
      });

}
