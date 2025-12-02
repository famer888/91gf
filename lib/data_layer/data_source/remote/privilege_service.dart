import '../../../domain/type_def.dart';
import 'base_service.dart';

class PrivilegeService extends BaseService {
  PrivilegeService(super._dio);

  @override
  final service = 'privilege';

  /// 下载次数验证
  AsyncJson downNum({required String id}) =>
      post('/download', data: {'id': id});
}
