enum ProxyProfitType {
  /// 收入
  income,

  /// 支出
  expenditure,
}

enum ProxyProfitSource {
  ///提现
  withdrawal,

  /// 提现退款
  refundWithdrawal,

  /// 代理分成
  agentCommission
}

extension _Helper on int? {
  ProxyProfitType? get toProxyProfitType => switch (this) {
        1 => ProxyProfitType.income,
        2 => ProxyProfitType.expenditure,
        _ => null,
      };

  ProxyProfitSource? get toProxyProfitSource => switch (this) {
        1 => ProxyProfitSource.withdrawal,
        2 => ProxyProfitSource.refundWithdrawal,
        3 => ProxyProfitSource.agentCommission,
        _ => null,
      };
}

class ProxyProfit {
  final String? nickName;
  final ProxyProfitType? type;
  final String? amount;

  final ProxyProfitSource? source;
  final String? createdAt;
  ProxyProfit({
    this.nickName,
    required this.type,
    this.amount,
    required this.source,
    this.createdAt,
  });
  factory ProxyProfit.fromJson(Map<String, dynamic> json) => ProxyProfit(
      nickName: json['nickname'],
      type: (json['type'] as int?).toProxyProfitType,
      amount: json['amount'],
      source: (json['source'] as int?).toProxyProfitSource,
      createdAt: json['created_at']);
}
