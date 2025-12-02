import 'package:jygf/domain/model/banner_model.dart';

class AiNavModel {
  final List<BannerModel> ads;
  final List<AiNavItemModel> nav;

  AiNavModel({required this.ads, required this.nav});

  factory AiNavModel.fromJson(Map<String, dynamic> json) => AiNavModel(
        ads: List<BannerModel>.from(
            (json['ads'] ?? []).map((e) => BannerModel.fromJson(e))),
        nav: List<AiNavItemModel>.from(
            (json['nav'] ?? []).map((e) => AiNavItemModel.fromJson(e))),
      );
}

class AiNavItemModel {
  final String label;
  final String icon;
  final int type;

  AiNavItemModel({required this.label, required this.icon, required this.type});

  factory AiNavItemModel.fromJson(Map<String, dynamic> json) => AiNavItemModel(
        label: json['label'],
        icon: json['icon'],
        type: json['type'] ?? 0,
      );
}
