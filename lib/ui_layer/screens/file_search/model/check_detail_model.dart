import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/media_model.dart';
import 'package:jygf/domain/model/topic_detail_model.dart';
import 'package:jygf/domain/model/topic_model.dart';
import 'package:jygf/domain/model/user_model.dart';

class CheckDetailModel {
  List<BannerModel>? banner;
  List<RecommendModel>? recommend;
  TopicDetail? post;

  CheckDetailModel({this.banner, this.recommend, this.post});

  factory CheckDetailModel.fromJson(Map<String, dynamic> json) {
    return CheckDetailModel(
      banner: json['banner'] != null ? List.from(json['banner'].map((e) => BannerModel.fromJson(e))) : null,
      recommend: json['recommend'] != null ? List.from(json['recommend'].map((e) => RecommendModel.fromJson(e))) : null,
      post: json['post'] == null ? null : TopicDetail.fromJson(json['post']),
    );
  }
}

class RecommendModel {
  int id;
  String title;
  String aff;
  int topicId;
  final UserModel? user;
  final TopicModel? topic;
  final List<MediaModel>? medias;

  RecommendModel({this.id = 0, this.title = '', this.aff = '', this.topicId = 0, this.user, this.topic, this.medias});

  factory RecommendModel.fromJson(Map<String, dynamic> json) {
    return RecommendModel(
      id: json['id'],
      title: json['title'],
      aff: json['aff'],
      topicId: json['topic_id'],
      user: json['user'] == null ? null : UserModel.fromJson(json['user']),
      topic: json['topic'] == null ? null : TopicModel.fromJson(json['topic']),
      medias: json['medias'] != null ? List.from(json['medias'].map((e) => MediaModel.fromJson(e))) : null,
    );
  }
}
