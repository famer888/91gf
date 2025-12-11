class BitNavModel {
  final int id;
  final String name;
  final int? type;
  final String? title;
  final String? value;
  final String? sort;

  final int? uiType; // 0: UI热门推荐布局  1: UI主题布局

  BitNavModel({
    required this.id,
    required this.name,
    this.type,
    this.title,
    this.value,
    this.sort,
    this.uiType,
  });

  factory BitNavModel.fromJson(Map<String, dynamic> json) => BitNavModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        type: json['type'],
        title: json['title'],
        value: json['value'].toString(),
        sort: json['sort'],
        uiType: json['ui_type'],
      );
}
