class GirlOptionModel {
  GirlOptionModel({
    this.label,
    this.value,
    this.items,
  });

  final String? label;
  final String? value;
  final List<GirlOptionItemModel>? items;

  factory GirlOptionModel.fromJson(Map<String, dynamic> json) =>
      GirlOptionModel(
        label: json['label'],
        value: json['value'],
        items: List.from(
            json['items'].map((x) => GirlOptionItemModel.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        'label': label,
        'value': value,
        'items': (items ?? []).map((x) => x.toJson()),
      };
}

class GirlOptionItemModel {
  GirlOptionItemModel({
    this.name,
    this.value,
  });

  final String? name;
  final String? value;

  factory GirlOptionItemModel.fromJson(Map<String, dynamic> json) =>
      GirlOptionItemModel(
        name: json['name'],
        value: json['value'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
      };
}
