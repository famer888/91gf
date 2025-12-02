import 'package:jygf/domain/type_def.dart';
import 'base_service.dart';

class AIAudioService extends BaseService {
  AIAudioService(super._dio);

  @override
  final service = 'aiaudio';

  // AI语音生成
  AsyncJson aiAudioGenerate({
    required String text,
    required String spkId,
  }) =>
      post('/generate_audio', data: {
        'text': text,
        'spk_id': spkId,
      });

  // 我的语音
  AsyncJson aiAudioRecord({
    required int status,
    required int page,
    required int limit,
  }) =>
      post('/my_generate_audio',
          data: {'status': status, 'page': page, 'limit': limit});

  // 删除语音
  AsyncJson delAIAudioRecord({
    required String ids,
  }) =>
      post('/del_generate_audio', data: {'ids': ids});
}
