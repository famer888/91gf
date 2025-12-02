class CashWithdrawRule {
  /// 提现规则
  final String? ruleText;
  final String? ruleProxyText;

  /// 提现规则
  final String? ruleCoinsText;
  final num? incomeMoney;
  final double? incomeRate;
  final double? proxyRate;
  final String? proxyMoney;
  final String scaleTip;
  CashWithdrawRule({
    this.ruleText,
    this.ruleProxyText,
    this.ruleCoinsText,
    this.incomeMoney,
    this.incomeRate,
    this.proxyRate,
    this.proxyMoney,
    required this.scaleTip,
  });
  factory CashWithdrawRule.fromJson(Map<String, dynamic> json) {
    return CashWithdrawRule(
        ruleText: json['rule_text'],
        ruleProxyText: json['rule_proxy_text'],
        ruleCoinsText: json['rule_coins_text'],
        incomeMoney: json['income_money'],
        incomeRate: json['income_rate'],
        proxyRate: json['proxy_rate'],
        proxyMoney: json['proxy_money'],
        scaleTip: json['scale_tip']);
  }
}
