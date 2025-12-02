class NavModel {
  final int id;
  final String linkUrl;
  final String resourceUrl;
  final int redirectType;
  final String name;
  final String desc;
  final String router;
  final int openType;
  final String urlStr;

  NavModel(
      {required this.id,
      required this.linkUrl,
      required this.resourceUrl,
      required this.redirectType,
      required this.name,
      required this.desc,
      required this.router,
      required this.openType,
      required this.urlStr});

  factory NavModel.fromJson(Map<String, dynamic> json) => NavModel(
        id: json['id'],
        linkUrl: json['link_url'],
        resourceUrl: json['resource_url'],
        redirectType: json['redirect_type'],
        name: json['name'],
        desc: json['desc'],
        router: json['router'],
        openType: json['open_type'],
        urlStr: json['url_str'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'link_url': linkUrl,
        'resource_url': resourceUrl,
        'redirect_type': redirectType,
        'name': name,
        'desc': desc,
        'router': router,
        'open_type': openType,
        'url_str': urlStr,
      };
}
