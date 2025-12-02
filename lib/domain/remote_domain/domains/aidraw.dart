import 'package:jygf/domain/model/ai/ai_draw_model.dart';
import 'package:jygf/domain/model/ai/ai_draw_record_model.dart';
import 'package:jygf/domain/type_def.dart';

abstract class AIDrawDomain {
  /// AI绘画列表
  AsyncResult<AIDrawListModel> aiDrawList();

  /// AI绘画提交
  AsyncResult aiDrawGenerate(
      {required String prompt,
      required String negativeprompt,
      required String size,
      required String image});

  AsyncResult<List<AIDrawRecordModel>> aiDrawRecord({
    required int status,
    required int page,
    required int limit,
  });

  AsyncResult delAIDrawRecord({required int ids});
}
