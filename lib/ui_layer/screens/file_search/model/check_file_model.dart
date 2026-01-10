import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/community/community_model.dart';
import 'package:jygf/domain/model/post_model.dart';

class CheckFileModel {
  List<CommunityCategoryTabModel>? nav;
  List<BannerModel>? banners;
  List<PostModel>? posts;

  CheckFileModel({
    this.nav,
    this.banners,
    this.posts,
  });

  factory CheckFileModel.fromJson(Map<String, dynamic> json) {
    return CheckFileModel(
      // nav: json['nav'] != null ? List.from(json['nav'].map((e) => CommunityCategoryTabModel.fromJson(e))) : null,
      banners: json['banner'] != null ? List.from(json['banner'].map((e) => BannerModel.fromJson(e))) : null,
      posts: json['posts'] != null ? List.from(json['posts'].map((e) => PostModel.fromJson(e))) : null,
    );
  }
}
