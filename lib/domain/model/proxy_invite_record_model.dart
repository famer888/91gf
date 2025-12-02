class ProxyInviteRecordData {
  final List<ProxyInviteRecord> list;
  final String lastIx;
  ProxyInviteRecordData({required this.list, required this.lastIx});
  factory ProxyInviteRecordData.fromJson(Map<String, dynamic> json) {
    return ProxyInviteRecordData(
        list: json['list'] != null
            ? List.from(json['list'].map((e) => ProxyInviteRecord.fromJson(e)))
            : [],
        lastIx: json['last_ix'] ?? '');
  }
}

class ProxyInviteRecord {
  final String affCode;
  final String phone;
  final String regStatus;
  final String logDate;

  ProxyInviteRecord({
    required this.affCode,
    required this.phone,
    required this.regStatus,
    required this.logDate,
  });
  factory ProxyInviteRecord.fromJson(Map<String, dynamic> json) {
    return ProxyInviteRecord(
        affCode: json['aff_code'],
        phone: json['phone'],
        regStatus: json['reg_status'],
        logDate: json['log_date']);
  }
}
