class CommunityCategoryTabModel {
  String title;
  int type;
  int id;
  String sort;

  CommunityCategoryTabModel({this.title = '', this.type = 0, this.id = 0, this.sort = '',});

  factory CommunityCategoryTabModel.fromJson(Map<String, dynamic> json) {
    return CommunityCategoryTabModel(
      title: json['title'],
      type: json['type'],
      id: json['id'],
      sort: json['sort'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'id': id,
      'sort': sort,
    };
  }
}

