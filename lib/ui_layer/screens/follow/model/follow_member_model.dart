import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/post_model.dart';

class FollowMemberModel {
  List<BannerModel> banner;
  List<PostModel> posts;

  FollowMemberModel({this.banner = const [], this.posts = const [],});

  factory FollowMemberModel.fromJson(Map<String, dynamic> json) {
    return FollowMemberModel(
      banner: json['banner'] != null ? List<BannerModel>.from(json['banner']?.map((app) => BannerModel.fromJson(app))) : [],
      posts: json['posts'] != null ? List<PostModel>.from(json['posts']?.map((app) => PostModel.fromJson(app))) : [],
    );
  }

  Map<String, dynamic> toJson() => {
    "banner": banner,
    "posts": posts,
  };
}