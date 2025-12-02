import 'package:jygf/domain/type_def.dart';

abstract class AIAudioDomain {
  /// 语音创作
  AsyncResult aiAudioGenerate({
    required String text,
    required String spkId,
  });

  /// 我的语音
  AsyncResult<List<dynamic>> aiAudioRecord({
    required int status,
    required int page,
    required int limit,
  });

  /// 删除语音
  AsyncResult delAIAudioRecord({
    required String ids,
  });
}
