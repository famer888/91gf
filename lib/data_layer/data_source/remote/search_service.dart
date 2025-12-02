import '../../../domain/type_def.dart';
import 'base_service.dart';

class SearchService extends BaseService {
  SearchService(super._dio);

  @override
  final service = 'search';

  /// 取得搜索菜单栏
  AsyncJson searchHotList() => post('/index');
}
