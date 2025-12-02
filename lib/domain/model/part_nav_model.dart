class PartModel {
  final int id;
  final String title;
  final String router;
  final String type;
  final String icon;
  final String urlStr;
  final String config;
  final int redirectType;

  PartModel({
    required this.id,
    required this.title,
    required this.router,
    required this.type,
    required this.icon,
    required this.urlStr,
    required this.config,
    required this.redirectType,
  });

  factory PartModel.fromJson(Map<String, dynamic> json) => PartModel(
        id: json['id'] ?? 0,
        title: json['title'],
        router: json['router'],
        type: json['type'] ?? '1',
        icon: json['icon'],
        urlStr: json['url_str'],
        config: json['config'] ?? '',
        redirectType: json['redirect_type'] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'router': router,
        'type': type,
        'icon': icon,
        'url_str': urlStr,
        'config': config,
        'redirect_type': redirectType,
      };
}
