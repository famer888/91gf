import 'post_model.dart';

class MineVideoListModel {
  final List<MineVideoCardData>? list;
  final String? lastIx;

  MineVideoListModel({
    this.list,
    this.lastIx,
  });

  factory MineVideoListModel.fromJson(Map<String, dynamic> json) {
    return MineVideoListModel(
        list: List.from(json['list'].map((e) => MineVideoCardData.fromJson(e))),
        lastIx: json['last_ix'] as String?);
  }

  Map<String, dynamic> toJson() =>
      {'list': list?.map((e) => e.toJson()).toList(), 'last_ix': lastIx};
}

class MineVideoCardData {
  final int? mvType;
  final int? duration;
  final int? id;
  final int? playCt;
  final String? title;
  final String? coverVertical;
  final String? coverHorizontal;

  MineVideoCardData({
    this.mvType,
    this.duration,
    this.id,
    this.playCt,
    this.title,
    this.coverVertical,
    this.coverHorizontal,
  });

  MineVideoCardData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        mvType = json['mv_type'],
        duration = json['duration'],
        playCt = json['play_ct'],
        title = json['title'],
        coverVertical = json['cover_vertical'],
        coverHorizontal = json['cover_horizontal'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'mv_type': mvType,
        'duration': duration,
        'play_ct': playCt,
        'title': title,
        'cover_vertical': coverVertical,
        'cover_horizontal': coverHorizontal,
      };
}

class MineTieztListModel {
  final List<PostModel>? list;
  final String? lastIx;

  MineTieztListModel({
    this.list,
    this.lastIx,
  });

  factory MineTieztListModel.fromJson(Map<String, dynamic> json) {
    return MineTieztListModel(
      list: List.from(json['list'].map((e) => PostModel.fromJson(e))),
      lastIx: json['last_ix'] as String?,
    );
  }
}
