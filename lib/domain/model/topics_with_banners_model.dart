import 'banner_model.dart';
import 'topic_model.dart';

class TopicsWithBannersModel {
  List<TopicModel> topics;
  List<BannerModel> banners;

  TopicsWithBannersModel({required this.topics, required this.banners});

  factory TopicsWithBannersModel.fromJson(Map<String, dynamic> json) => TopicsWithBannersModel(
      topics: List<TopicModel>.from(json['topics'].map((e) => TopicModel.fromJson(e))),
      banners: List<BannerModel>.from(json['banners'].map((e) => BannerModel.fromJson(e))));

  Map<String, dynamic> toJson() => {'topics': topics, 'banners': banners};
}
