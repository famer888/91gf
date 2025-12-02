class LinkModel {
  LinkModel(
      {required this.id,
      this.relatedId,
      this.elementId,
      required this.linkUrl,
      required this.resourceUrl,
      required this.redirectType,
      required this.name,
      required this.desc,
      this.sort,
      this.createdAt,
      this.updatedAt,
      required this.api,
      required this.params,
      this.uiType,
      this.is_nav_prepend});

  int id;
  int? relatedId;
  int? elementId;
  String linkUrl;
  String resourceUrl;
  int redirectType;
  String name;
  String desc;
  int? sort;
  String? createdAt;
  String? updatedAt;
  String api;
  Map params;
  int? uiType;
  bool? is_nav_prepend;

  factory LinkModel.fromJson(Map<String, dynamic> json) => LinkModel(
        id: json['id'],
        relatedId: json['related_id'],
        elementId: json['element_id'],
        linkUrl: json['link_url'],
        resourceUrl: json['resource_url'],
        redirectType: json['redirect_type'],
        name: json['name'],
        desc: json['desc'],
        sort: json['sort'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        api: json['api'],
        params: json['params'],
        uiType: json['ui_type'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'related_id': relatedId,
        'element_id': elementId,
        'link_url': linkUrl,
        'resource_url': resourceUrl,
        'redirect_type': redirectType,
        'name': name,
        'desc': desc,
        'sort': sort,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'api': api,
        'params': params,
        'ui_type': uiType,
      };
}
