part of '../repo.dart';

mixin _Withdraw on _BaseAppRepo implements WithdrawDomain {
  @override
  AsyncResult<CashWithdrawRule> cashWithdrawRule() => _withdrawService
      .cashWithdrawRule()
      .deserializeJsonBy(CashWithdrawRule.fromJson)
      .guard;
}
