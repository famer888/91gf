import 'package:jygf/domain/model/banner_model.dart';

import '../../../../domain/model/topic_model.dart';

class FollowTopicModel {
  List<BannerModel> banner;
  List<TopicModel> topics;

  FollowTopicModel({
    this.banner = const [],
    this.topics = const [],
  });

  factory FollowTopicModel.fromJson(Map<String, dynamic> json) {
    return FollowTopicModel(
      banner: json['banner'] != null ? List<BannerModel>.from(json['banner']?.map((app) => BannerModel.fromJson(app))) : [],
      topics: json['topics'] != null ? List<TopicModel>.from(json['topics']?.map((app) => TopicModel.fromJson(app))) : [],
    );
  }


  Map<String, dynamic> toJson() => {
    "banner": banner,
    "posts": topics,
  };

}
