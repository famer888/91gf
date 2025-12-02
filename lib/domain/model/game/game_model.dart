class GameModel {
    final int? id;
    final String? themeIds;
    final String? cover;
    final String? title;
    final String? tags;
    final int? likeFct;
    final int? payFct;

  GameModel({this.id, this.themeIds, this.cover, this.title, this.tags, this.likeFct, this.payFct});

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      themeIds: json['theme_ids'],
      cover: json['cover'],
      title: json['title'],
      tags: json['tags'],
      likeFct: json['like_fct'],
      payFct: json['pay_fct'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'theme_ids': themeIds,
      'cover': cover,
      'title': title,
      'tags': tags,
      'like_fct': likeFct,
      'pay_fct': payFct,
    };
  }
}