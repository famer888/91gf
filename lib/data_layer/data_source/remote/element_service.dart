import '../../../domain/type_def.dart';
import 'base_service.dart';

class ElementService extends BaseService {
  ElementService(super._dio);

  @override
  final service = 'element';

  /// 获取精选��部导航
  AsyncJson getFirstTopNavConfig({required int navId}) =>
      post('/getElementById', data: {'id': navId});
}
