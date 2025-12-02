import 'package:jygf/domain/model/live_model.dart';

import 'banner_model.dart';
import 'post_model.dart';

class PostsWithBannersModel {
  List<PostModel> posts;
  List<BannerModel> banners;
  List<TipModel>? tips;

  PostsWithBannersModel({required this.posts, required this.banners, this.tips});
  factory PostsWithBannersModel.fromJson(Map<String, dynamic> json) =>
      PostsWithBannersModel(
          posts: List<PostModel>.from(
              json['posts'].map((e) => PostModel.fromJson(e))),
          banners: List<BannerModel>.from(
              json['banners'].map((e) => BannerModel.fromJson(e))),
          tips: List<TipModel>.from(
          json['tips'].map((e) => TipModel.fromJson(e))));
  Map<String, dynamic> toJson() => {'posts': posts, 'banners': banners, 'tips': tips ?? []};
}
