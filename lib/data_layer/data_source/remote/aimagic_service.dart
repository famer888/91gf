import 'package:jygf/domain/type_def.dart';
import 'base_service.dart';

class AIMagicService extends BaseService {
  AIMagicService(super._dio);

  @override
  final service = 'aimagic';

  AsyncJson aiMagicList({
    required int page,
    int limit = 15,
  }) =>
      post('/list_material', data: {'page': page, 'limit': limit});

  AsyncJson aiMagicGenerate(
          {required String materialId,
          required String thumb,
          required String thumbW,
          required String thumbH}) =>
      post('/generate_video', data: {
        'material_id': materialId,
        'thumb': thumb,
        'thumb_w': thumbW,
        'thumb_h': thumbH,
      });

  AsyncJson aiMagicRecord({
    required int status,
    required int page,
    required int limit,
  }) =>
      post('/my_generate_video',
          data: {'status': status, 'page': page, 'limit': limit});

  AsyncJson delAIMagicRecord({required int ids}) =>
      post('/del_generate_video', data: {'ids': ids});
}
