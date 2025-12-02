class NavigatorModel {
  NavigatorModel({
    required this.title,
    required this.type,
  });

  final String title;
  final String type;

  factory NavigatorModel.fromJson(Map<String, dynamic> json) => NavigatorModel(
        title: json['title'],
        type: json['type'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'type': type,
      };
}

class VlogNavigatorModel {
  VlogNavigatorModel({
    required this.label,
    required this.value,
  });

  final String label;
  final int value;

  factory VlogNavigatorModel.fromJson(Map<String, dynamic> json) =>
      VlogNavigatorModel(
        label: json['label'],
        value: json['value'],
      );

  Map<String, dynamic> toJson() => {
        'label': label,
        'value': value,
      };
}

class FaceNavigatorModel {
  FaceNavigatorModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory FaceNavigatorModel.fromJson(Map<String, dynamic> json) =>
      FaceNavigatorModel(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class FaceSortModel {
  FaceSortModel(
      {required this.title,
      required this.value,
      required this.type,
      this.sort});

  final String title;
  final String value;
  final int type;
  String? sort; //自定义字段，// asc：正序 desc：倒序 null：默认状态
  factory FaceSortModel.fromJson(Map<String, dynamic> json) => FaceSortModel(
        title: json['title'],
        value: json['value'],
        type: json['type'],
      );

  Map<String, dynamic> toJson() =>
      {'title': title, 'value': value, 'type': type};
}

class VideoFaceSortModel {
  VideoFaceSortModel({
    required this.title,
    required this.type,
  });
  final String title;
  final String type;
  String? sort;
  factory VideoFaceSortModel.fromJson(Map<String, dynamic> json) =>
      VideoFaceSortModel(
        title: json['title'],
        type: json['type'],
      );
  Map<String, dynamic> toJson() => {
        'title': title,
        'type': type,
      };
}

class RankNavigatorModel {
  RankNavigatorModel({
    this.title,
    this.value,
  });

  final String? title;
  final String? value;

  factory RankNavigatorModel.fromJson(Map<String, dynamic> json) =>
      RankNavigatorModel(
        title: json['title'],
        value: json['value'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'value': value,
      };
}
