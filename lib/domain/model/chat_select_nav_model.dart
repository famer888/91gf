class ChatSelectNavModel {
  ChatSelectNavModel({
    this.id,
    this.name,
  });
  final int? id;
  final String? name;

  factory ChatSelectNavModel.fromJson(Map<String, dynamic> json) =>
      ChatSelectNavModel(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
