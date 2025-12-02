class MineWithdrawalRecord {
  final String amount;
  final String statusStr;
  final String updatedAt;
  MineWithdrawalRecord({
    required this.amount,
    required this.statusStr,
    required this.updatedAt,
  });
  factory MineWithdrawalRecord.fromJson(Map<String, dynamic> json) =>
      MineWithdrawalRecord(
          amount: '${json['amount']}',
          statusStr: json['status_str'],
          updatedAt: json['updated_at']);
}
