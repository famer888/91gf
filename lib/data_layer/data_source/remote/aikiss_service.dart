import 'package:jygf/domain/type_def.dart';
import 'base_service.dart';

class AIKissService extends BaseService {
  AIKissService(super._dio);

  @override
  final service = 'aikiss';

  // 生成接吻视频
  AsyncJson aiKissGenerate({
    required String firstThumb,
    required String firstThumbW,
    required String firstThumbH,
    required String endThumb,
    required String endThumbW,
    required String endThumbH,
  }) =>
      post('/generate_video', data: {
        'first_thumb': firstThumb,
        'first_thumb_w': firstThumbW,
        'first_thumb_h': firstThumbH,
        'end_thumb': endThumb,
        'end_thumb_w': endThumbW,
        'end_thumb_h': endThumbH,
      });

  // 我的接吻视频记录
  AsyncJson aiKissRecord({
    required int status,
    required int page,
    required int limit,
  }) =>
      post('/my_generate_video',
          data: {'status': status, 'page': page, 'limit': limit});

  // 删除接吻视频记录
  AsyncJson delAIKissRecord({
    required String ids,
  }) =>
      post('/del_generate_video', data: {'ids': ids});
}
