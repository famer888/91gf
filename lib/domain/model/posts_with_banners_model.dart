import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/topic_model.dart';

import 'banner_model.dart';
import 'post_model.dart';

class PostsWithBannersModel {
  List<PostModel>? posts;
  List<BannerModel>? banners;
  List<TipModel>? tips;
  List<TopicModel>? topics;

  PostsWithBannersModel({required this.posts, required this.banners, this.tips, required this.topics});

  factory PostsWithBannersModel.fromJson(Map<String, dynamic> json) => PostsWithBannersModel(
        posts: json['posts'] != null ? List<PostModel>.from(json['posts'].map((e) => PostModel.fromJson(e))) : null,
        banners: json['banners'] != null ? List<BannerModel>.from(json['banners'].map((e) => BannerModel.fromJson(e))) : null,
        tips: json['tips'] != null ? List<TipModel>.from(json['tips'].map((e) => TipModel.fromJson(e))) : null,
        topics: json['topics'] != null ? List<TopicModel>.from(json['topics'].map((e) => TopicModel.fromJson(e))) : null,
      );

  Map<String, dynamic> toJson() => {'posts': posts ?? [], 'banners': banners ?? [], 'tips': tips ?? [], 'topics': topics ?? []};
}
