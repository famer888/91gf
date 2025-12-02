import '../../../domain/type_def.dart';
import 'base_service.dart';

class WithdrawService extends BaseService {
  WithdrawService(super._dio);

  @override
  final service = 'withdraw';

  /// 提现 规则
  AsyncJson cashWithdrawRule() => post('/index');
}
