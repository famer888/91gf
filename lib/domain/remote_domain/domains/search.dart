import '../../model/search_model.dart';
import '../../type_def.dart';

abstract class SearchDomain {
  /// 搜索菜单栏
  AsyncResult<SearchModel> searchHotList();
}
