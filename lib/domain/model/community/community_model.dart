class CommunityCategoryTabModel {
  String title;
  int type;
  int id;

  CommunityCategoryTabModel({this.title = '', this.type = 0, this.id = 0});

  factory CommunityCategoryTabModel.fromJson(Map<String, dynamic> json) {
    return CommunityCategoryTabModel(
      title: json['title'],
      type: json['type'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'id': id,
    };
  }
}

