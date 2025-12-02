import 'link_model.dart';

class ElementModel {
  ElementModel({
    required this.id,
    required this.constructId,
    required this.type,
    required this.contentType,
    required this.title,
    required this.moreButton,
    required this.morePageShowType,
    required this.maxNum,
    this.showField,
    required this.changeButton,
    this.sort,
    this.status,
    this.createdAt,
    this.updatedAt,
    required this.value,
  });

  int id;
  int constructId;
  int type;
  int contentType;
  String title;
  int moreButton;
  int morePageShowType;
  int maxNum;
  String? showField;
  int changeButton;
  int? sort;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<LinkModel> value;

  factory ElementModel.fromJson(Map<String, dynamic> json) {
    return ElementModel(
      id: json['id'],
      constructId: json['construct_id'],
      type: json['type'],
      contentType: json['content_type'],
      title: json['title'],
      moreButton: json['more_button'],
      morePageShowType: json['more_page_show_type'],
      maxNum: json['max_num'],
      showField: json['show_field'],
      changeButton: json['change_button'],
      sort: json['sort'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      value: List<LinkModel>.from(
          json['value']?.map((e) => LinkModel.fromJson(e)) ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'construct_id': constructId,
        'type': type,
        'content_type': contentType,
        'title': title,
        'more_button': moreButton,
        'more_page_show_type': morePageShowType,
        'max_num': maxNum,
        'show_field': showField,
        'change_button': changeButton,
        'sort': sort,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'value': value.map((e) => e.toJson()),
      };
}
