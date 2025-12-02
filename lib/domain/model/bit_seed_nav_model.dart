class BitSeedNavModel {
  final String title;
  final int value;
  BitSeedNavModel({required this.title, required this.value});
  factory BitSeedNavModel.fromJson(Map<String, dynamic> json) =>
      BitSeedNavModel(
          title: json['title'] ?? 'null',
          value: json['value'] ?? 1);
}
