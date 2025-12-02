class SearchHotTag {
  final int type;
  final String work;
  final int num;
  SearchHotTag({required this.type, required this.work, required this.num});
  factory SearchHotTag.fromJson(Map<String, dynamic> json) =>
      SearchHotTag(type: json['type'], work: json['work'], num: json['num']);
  Map<String, dynamic> toJson() => {'type': type, 'work': work, 'num': num};
}
