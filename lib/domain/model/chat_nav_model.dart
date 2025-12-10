class ChatNavModel {
  ChatNavModel({
    this.id,
    this.sort,
    this.name,
    this.type,
  });
  final int? id;
  final String? sort;
  final String? name;
  final int? type;

  factory ChatNavModel.fromJson(Map<String, dynamic> json) => ChatNavModel(
        id: json['id'],
        sort: json['sort'],
        name: json['name'],
        type: json['type'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sort': sort,
        'name': name,
        'type': type,
      };
}
