import '../../model/cash_withdraw_rule_model.dart';
import '../../type_def.dart';

abstract class WithdrawDomain {
  /// 提现 规则
  AsyncResult<CashWithdrawRule> cashWithdrawRule();
}
