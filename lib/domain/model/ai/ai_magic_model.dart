
import 'package:jygf/domain/model/banner_model.dart';

class AIMagicListModel {
   List<BannerModel> banner;
   List<AIMagicModel> material;

  AIMagicListModel({required this.banner, required this.material});


  factory AIMagicListModel.fromJson(Map<String, dynamic> json) =>
      AIMagicListModel(
        banner: List<BannerModel>.from(
            (json['banner'] ?? []).map((e) => BannerModel.fromJson(e))),
        material: List<AIMagicModel>.from(
            (json['material'] ?? []).map((e) => AIMagicModel.fromJson(e))),
      );

}

class AIMagicModel {
  final int id;
  final String title;
  final String cover;
  final String video;

  AIMagicModel({required this.id, required this.cover,required this.title,required this.video});

  factory AIMagicModel.fromJson(Map<String, dynamic> json) {
    return AIMagicModel(
      id: json['id'],
      cover: json['cover'],
      title: json['title'],
      video: json['video'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cover': cover,
      'title': title,
      'video': video,
    };
  }
}
