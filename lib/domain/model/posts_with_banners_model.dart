import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/topic_model.dart';

import 'banner_model.dart';
import 'post_model.dart';

class PostsWithBannersModel {
  List<PostModel> posts;
  List<BannerModel> banners;
  List<TipModel>? tips;
  List<TopicModel> topics;


  PostsWithBannersModel({required this.posts, required this.banners, this.tips, required this.topics});
  factory PostsWithBannersModel.fromJson(Map<String, dynamic> json) =>
      PostsWithBannersModel(
          posts: List<PostModel>.from(
              json['posts'].map((e) => PostModel.fromJson(e))),
          banners: List<BannerModel>.from(
              json['banners'].map((e) => BannerModel.fromJson(e))),
          tips: List<TipModel>.from(
          json['tips'].map((e) => TipModel.fromJson(e))),
          topics: List<TopicModel>.from(
              json['topics'].map((e) => TopicModel.fromJson(e))));
          
  Map<String, dynamic> toJson() => {'posts': posts, 'banners': banners, 'tips': tips ?? []};
}
