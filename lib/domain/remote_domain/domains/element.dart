import '../../model/element_model.dart';
import '../../type_def.dart';

abstract class ElementDomain {
  /// 获取精选��部导航
  AsyncResult<ElementModel> getFirstTopNavConfig({int? navId});
}
