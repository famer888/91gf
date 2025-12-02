class BloggerModel {
  final int? id;
  final int? agent;
  final int? aff;
  final int? fansCt;
  final int? viewCt;
  int isFollow;
  final int? likeCt;
  final String? nickName;
  final String? thumb;

  BloggerModel({
    required this.id,
    required this.agent,
    required this.aff,
    required this.fansCt,
    required this.viewCt,
    required this.likeCt,
    required this.nickName,
    required this.thumb,
    required this.isFollow,
  });

  factory BloggerModel.fromJson(Map<String, dynamic> json) => BloggerModel(
        id: json['id'],
        agent: json['agent'],
        aff: json['aff'],
        fansCt: json['fans_ct'],
        viewCt: json['view_ct'],
        likeCt: json['like_ct'],
        nickName: json['nickname'],
        thumb: json['thumb'],
        isFollow: json['is_follow'] ?? 0,
      );
}
