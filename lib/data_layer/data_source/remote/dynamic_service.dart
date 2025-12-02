import '../../../domain/type_def.dart';
import 'base_service.dart';

class DynamicService extends BaseService {
  DynamicService(super._dio);

  @override
  final service = '';

  AsyncJson getConstructByApiLink({
    required String apiLink,
    required Map params,
  }) =>
      post(apiLink, data: params);
}
