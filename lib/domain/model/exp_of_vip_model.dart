class ExpOfVIPData {
  final List<ExpOfVIP> list;
  final int? exp;
  ExpOfVIPData({required this.list, required this.exp});
  factory ExpOfVIPData.fromJson(Map<String, dynamic> json) {
    return ExpOfVIPData(
        list: List.from(json['list'].map((e) => ExpOfVIP.fromJson(e))),
        exp: json['exp']);
  }
  Map<String, dynamic> toJson() {
    return {'list': list.map((e) => e.toJson()).toList(), 'exp': exp};
  }
}

class ExpOfVIP {
  final int id;
  final String vipStr;
  final String expStr;
  final String title;
  final int type;
  final String? bgImg;
  final String? icon;
  final String? desc;

  ExpOfVIP({
    required this.id,
    required this.vipStr,
    required this.expStr,
    required this.title,
    required this.type,
    this.bgImg,
    this.icon,
    this.desc,
  });
  factory ExpOfVIP.fromJson(Map<String, dynamic> json) {
    return ExpOfVIP(
      id: json['id'] ?? '',
      vipStr: json['vip_str'] ?? '',
      expStr: json['exp_str'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      bgImg: json['bg_img'] ?? '',
      icon: json['icon'] ?? '',
      desc: json['desc'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vip_str': vipStr,
      'exp_str': expStr,
      'type': type,
      'title': title,
      'bg_img': bgImg,
      'icon': icon,
      'desc': desc,
    };
  }
}
