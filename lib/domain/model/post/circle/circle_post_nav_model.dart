class CirclePostNavModel {
  final int id;
  final String name;
  final int mask;

  CirclePostNavModel({
    required this.id,
    required this.name,
    required this.mask,
  });
  factory CirclePostNavModel.fromJson(Map<String, dynamic> json) =>
      CirclePostNavModel(
        id: json['id'],
        name: json['name'],
        mask: json['mask'] ?? 0,
      );
}
