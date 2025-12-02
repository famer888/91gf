import 'package:jygf/domain/model/ai/ai_magic_model.dart';
import 'package:jygf/domain/model/ai/ai_magic_record_model.dart';
import 'package:jygf/domain/type_def.dart';

abstract class AIMagicDomain {
  /// AI魔法列表
  AsyncResult<AIMagicListModel> aiMagicList({
    required int page,
    int limit,
  });

  AsyncResult<AIMagicModel> aiMagicGenerate(
      {required String materialId,
      required String thumb,
      required String thumbW,
      required String thumbH});

  AsyncResult<List<AIMagicRecordModel>> aiMagicRecord({
    required int status,
    required int page,
    required int limit,
  });

  AsyncResult delAIMagicRecord({required int ids});
}
