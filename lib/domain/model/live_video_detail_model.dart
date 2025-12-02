

import 'package:jygf/domain/model/home_data_model.dart';

import 'live_model.dart';

class LiveVideoDetailData {
  LiveVideoDetailData({required this.live, this.banners});
  final LiveModel live;
  final List<Notice>? banners;

  factory LiveVideoDetailData.fromJson(Map<String, dynamic> json) =>
      LiveVideoDetailData(
          live: LiveModel.fromJson(json['live']),
          banners: json['banners'] == null
              ? null
              : List<Notice>.from(
                  json['banners'].map((e) => Notice.fromJson(e))));

  Map<String, dynamic> toJson() => {
        'live': live,
        'banners': banners,
      };
}
