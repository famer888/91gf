import 'banner_model.dart';
import 'post_model.dart';
import 'topic_model.dart';

class CommunityWithBannerModel {
  List<TopicModel> topics;
  List<BannerModel> banners;
  List<PostModel> posts;
  CommunityWithBannerModel(
      {required this.topics, required this.banners, required this.posts});
  factory CommunityWithBannerModel.fromJson(Map<String, dynamic> json) =>
      CommunityWithBannerModel(
          topics: List<TopicModel>.from(
              (json['topics'] ?? []).map((e) => TopicModel.fromJson(e))),
          banners: List<BannerModel>.from(
              (json['banner'] ?? []).map((e) => BannerModel.fromJson(e))),
          posts: List<PostModel>.from(
              json['posts'].map((e) => PostModel.fromJson(e))));
  Map<String, dynamic> toJson() => {'topics': topics, 'banner': banners};
}
