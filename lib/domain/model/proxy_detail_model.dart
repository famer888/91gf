class ProxyDetail {
  final ProxyRecord today;
  final ProxyRecord curMonth;
  final String money;
  final int? level;
  final String? levelStr;
  final String levelRate;
  final String allReward;
  final int? directProxyNum;
  final int? directPayNum;
  final int? directXiaJiDaiLi;
  final String tips;
  final List<String> colorKey;
  ProxyDetail({
    required this.today,
    required this.curMonth,
    required this.money,
    this.level,
    required this.levelStr,
    required this.levelRate,
    required this.allReward,
    this.directProxyNum,
    this.directPayNum,
    this.directXiaJiDaiLi,
    required this.tips,
    required this.colorKey,
  });
  factory ProxyDetail.fromJson(Map<String, dynamic> json) {
    return ProxyDetail(
        today: ProxyRecord.fromJson(json['today']),
        curMonth: ProxyRecord.fromJson(json['curMonth']),
        money: json['proxy_money'].toString(),
        level: json['proxy_level'],
        levelStr: json['proxy_level_str'],
        levelRate: json['proxy_level_rate'].toString(),
        allReward: json['all_reward'].toString(),
        directProxyNum: json['direct_proxy_num'],
        directPayNum: json['direct_pay_num'],
        directXiaJiDaiLi: json['direct_xiajidaili'],
        tips: json['tips'],
        colorKey: List.from(json['color_key']));
  }
}

class ProxyRecord {
  final String reward;
  final String sell;
  final String invitedNum;
  ProxyRecord({
    required this.reward,
    required this.sell,
    required this.invitedNum,
  });
  factory ProxyRecord.fromJson(Map<String, dynamic> json) {
    return ProxyRecord(
        reward: json['reward'].toString(),
        sell: json['sell'].toString(),
        invitedNum: json['invited_num'].toString());
  }
}
