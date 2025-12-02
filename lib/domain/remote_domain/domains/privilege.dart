import '../../type_def.dart';

abstract class PrivilegeDomain {
  /// 下载次数验证
  AsyncResult downNum({required String id});
}
