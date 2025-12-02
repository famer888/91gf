import 'package:jygf/domain/type_def.dart';

abstract class AIKissDomain {
  /// 生成接吻视频
  AsyncResult aiKissGenerate({
    required String firstThumb,
    required String firstThumbW,
    required String firstThumbH,
    required String endThumb,
    required String endThumbW,
    required String endThumbH,
  });

  /// 我的接吻视频记录
  AsyncResult<List<dynamic>> aiKissRecord({
    required int status,
    required int page,
    required int limit,
  });

  /// 删除我的接吻视频记录
  AsyncResult delAIKissRecord({
    required String ids,
  });
}
