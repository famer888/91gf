class AIDrawListModel {
  List<AIDrawModeModel> labelModeForm;
  List<AIDrawModeModel> expertModeForm;

  AIDrawListModel({required this.labelModeForm, required this.expertModeForm});

  factory AIDrawListModel.fromJson(Map<String, dynamic> json) =>
      AIDrawListModel(
        labelModeForm: List<AIDrawModeModel>.from(
            (json['label_mode_form'] ?? [])
                .map((e) => AIDrawModeModel.fromJson(e))),
        expertModeForm: List<AIDrawModeModel>.from(
            (json['expert_mode_form'] ?? [])
                .map((e) => AIDrawModeModel.fromJson(e))),
      );
}

class AIDrawModeModel {
  final int id;
  final String title;
  final int type;
  final int layoutType;
  final List<Element> element;

  AIDrawModeModel({
    required this.id,
    required this.title,
    required this.type,
    required this.layoutType,
    required this.element,
  });

  factory AIDrawModeModel.fromJson(Map<String, dynamic> json) {
    return AIDrawModeModel(
      id: json["id"],
      title: json["title"],
      type: json["type"],
      layoutType: json["layout_type"],
      element:
          List<Element>.from(json["element"].map((x) => Element.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "type": type,
      "layout_type": layoutType,
      "element": List<dynamic>.from(element.map((x) => x.toJson())),
    };
  }
}

class Element {
  final int id;
  final int cateId;
  final String name;
  final String cover;
  final String key;
  final String val;

  Element({
    required this.id,
    required this.cateId,
    required this.name,
    required this.cover,
    required this.key,
    required this.val,
  });

  factory Element.fromJson(Map<String, dynamic> json) => Element(
        id: json["id"],
        cateId: json["cate_id"],
        name: json["name"],
        cover: json["cover"],
        key: json["key"],
        val: json["val"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cate_id": cateId,
        "name": name,
        "cover": cover,
        "key": key,
        "val": val,
      };
}

