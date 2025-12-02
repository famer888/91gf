import 'package:jygf/domain/type_def.dart';

abstract class AINovelDomain {
  /// AI小说生成
  AsyncResult aiNovelGenerate({
    required String description,
    required String characterSetting,
    required String locationScene,
    required String details,
    required String count,
  });

  /// 我的小说
  AsyncResult<List<dynamic>> aiNovelRecord({
    required int status,
    required int page,
    required int limit,
  });

  /// 小说详情
  AsyncResult<Json> aiNovelDetail({
    required String id,
  });

  /// 删除AI小说
  AsyncResult delAINovelRecord({
    required String ids,
  });
}
