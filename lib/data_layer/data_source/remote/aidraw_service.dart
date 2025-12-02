import 'package:jygf/domain/type_def.dart';
import 'base_service.dart';

class AIDrawService extends BaseService {
  AIDrawService(super._dio);

  @override
  final service = 'aidraw';

  AsyncJson aiDrawList() => post('/list_form_element');

  AsyncJson aiDrawGenerate(
          {required String prompt,
          required String negativeprompt,
          required String size,
          required String image}) =>
      post('/generate_image', data: {
        'prompt': prompt,
        'negative_prompt': negativeprompt,
        'size': size,
        'image': image
      });

  AsyncJson aiDrawRecord({
    required int status,
    required int page,
    required int limit,
  }) =>
      post('/my_generate_image',
          data: {'status': status, 'page': page, 'limit': limit});

  AsyncJson delAIDrawRecord({required int ids}) =>
      post('/del_generate_image', data: {'ids': ids});
}
