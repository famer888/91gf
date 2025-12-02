class CoinDetail {
  CoinDetail({
    this.id,
    this.aff,
    this.source,
    this.type,
    this.coinCnt,
    this.desc,
    this.sourceAff,
    this.createdAt,
    this.sourceStr,
    this.typeStr,
    this.sourceName,
    this.coin,
  });

  final int? id;
  final int? aff;
  final int? source;
  final int? type;
  final String? coinCnt;
  final String? desc;
  final int? sourceAff;
  final String? createdAt;
  final String? sourceStr;
  final String? typeStr;
  final String? sourceName;
  final int? coin;

  factory CoinDetail.fromJson(Map<String, dynamic> json) => CoinDetail(
        id: json['id'],
        aff: json['aff'],
        source: json['source'],
        type: json['type'],
        coinCnt: json['coinCnt'],
        desc: json['desc'],
        sourceAff: json['source_aff'],
        createdAt: json['created_at'],
        sourceStr: json['source_str'],
        typeStr: json['type_str'],
        sourceName: json['source_name'],
        coin: json['coin'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'aff': aff,
        'source': source,
        'type': type,
        'coinCnt': coinCnt,
        'desc': desc,
        'source_aff': sourceAff,
        'created_at': createdAt,
        'source_str': sourceStr,
        'type_str': typeStr,
        'source_name': sourceName,
        'coin': coin,
      };
}
