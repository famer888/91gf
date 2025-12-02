import 'package:jygf/domain/type_def.dart';
import 'base_service.dart';

class AINovelService extends BaseService {
  AINovelService(super._dio);

  @override
  final service = 'ainovel';

  /// POST /api/ainovel/generate_novel
  AsyncJson aiNovelGenerate({
    required String description,
    required String characterSetting,
    required String locationScene,
    required String details,
    required String count,
  }) =>
      post('/generate_novel', data: {
        'description': description,
        'character_setting': characterSetting,
        'location_scene': locationScene,
        'details': details,
        'count': count,
      });

  AsyncJson aiNovelRecord({
    required int status,
    required int page,
    required int limit,
  }) =>
      post('/my_generate_novel',
          data: {'status': status, 'page': page, 'limit': limit});

  AsyncJson aiNovelDetail({
    required String id,
  }) =>
      post('/detail', data: {'id': id});

  AsyncJson delAINovelRecord({
    required String ids,
  }) =>
      post('/del_generate_novel', data: {'ids': ids});
}
