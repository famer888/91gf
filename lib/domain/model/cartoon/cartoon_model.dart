


class CartoonModel {
  final int? id; // 5,
  final String? themeIds; // "",
  final String?
      cover; // "https://new1.sanheyiliao.xyz/upload_01/xiao/20240902/2024090210181644508.jpg",
  final String? title; // "极品粉嫩萝莉  粉红jk萝莉自慰",
  final int? duration; // 938,
  final int? type; // 1,
  final int? coins; // 0,
  final int viewFakeCount; // 254198,
  final int? commentCount; // 0,
  final String? createdAt; // "2024-09-02 12:22:52"

  CartoonModel({
    this.id,
    this.themeIds,
    this.cover,
    this.title,
    this.duration,
    this.type,
    this.coins,
    this.viewFakeCount = 0,
    this.commentCount,
    this.createdAt,
  });

  factory CartoonModel.fromJson(Map<String, dynamic> json) => CartoonModel(
        id: json['id'],
        themeIds: json['theme_ids'],
        cover: json['cover'],
        title: json['title'],
        duration: json['duration'],
        type: json['type'],
        coins: json['coins'],
        viewFakeCount: json['view_fct'],
        commentCount: json['comment_ct'],
        createdAt: json['created_at'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'theme_ids': themeIds,
        'cover': cover,
        'title': title,
        'duration': duration,
        'type': type,
        'coins': coins,
        'view_fct': viewFakeCount,
        'comment_ct': commentCount,
        'created_at': createdAt,
      };
}
