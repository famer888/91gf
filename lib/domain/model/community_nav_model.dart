class CommunityNavModel {
  final int id;
  final String title;

  CommunityNavModel({
    required this.id,
    required this.title,
  });

  factory CommunityNavModel.fromJson(Map<String, dynamic> json) =>
      CommunityNavModel(
        id: json['id'],
        title: json['title'],
      );
}

class OriginalCommunityNavModel {
  final int id;
  final String title;
  final String uri;
  final String type;

  OriginalCommunityNavModel({
    required this.id,
    required this.title,
    required this.uri,
    required this.type,
  });
  factory OriginalCommunityNavModel.fromJson(Map<String, dynamic> json) =>
      OriginalCommunityNavModel(
        id: json['id'],
        title: json['title'],
        uri: json['uri'],
        type: json['type'],
      );
}
