import 'banner_model.dart';

class AppCenterModel {
  AppCenterModel({
    required this.banner,
    required this.recommend,
    required this.common,
  });

  final List<BannerModel> banner;
  final List recommend;
  final List common;

  factory AppCenterModel.fromJson(Map<String, dynamic> json) => AppCenterModel(
        banner: List<BannerModel>.from(
            json['banner']?.map((x) => BannerModel.fromJson(x)) ?? []),
        recommend: List.from(json['apps']['recommend'] ?? []),
        common: List.from(json['apps']['common'] ?? []),
      );
}
