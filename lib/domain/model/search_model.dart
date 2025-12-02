import 'banner_model.dart';
import 'tag.dart';

class SearchModel {
  final List<BannerModel> banner;
  final TopSearch top;
  SearchModel({required this.banner, required this.top});
  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
      banner: List<BannerModel>.from(
          json['banner']?.map((x) => BannerModel.fromJson(x)) ?? []),
      top: TopSearch.fromJson(json['top']));
}

class TopSearch {
  final List<SearchHotTag> mv;
  final List<SearchHotTag> vlog;
  final List<SearchHotTag> book;
  final List<SearchHotTag> girl;
  final List<SearchHotTag> pic;
  final List<SearchHotTag> story;
  final List<SearchHotTag> all;
  TopSearch(
      {required this.mv,
      required this.vlog,
      required this.book,
      required this.girl,
      required this.pic,
      required this.story,
      required this.all});

  factory TopSearch.fromJson(Map<String, dynamic> json) => TopSearch(
      mv: List<SearchHotTag>.from(
          json['mv']?.map((x) => SearchHotTag.fromJson(x)) ?? []),
      vlog: List<SearchHotTag>.from(
          json['vlog']?.map((x) => SearchHotTag.fromJson(x)) ?? []),
      book: List<SearchHotTag>.from(
          json['book']?.map((x) => SearchHotTag.fromJson(x)) ?? []),
      girl: List<SearchHotTag>.from(
          json['girl']?.map((x) => SearchHotTag.fromJson(x)) ?? []),
      pic: List<SearchHotTag>.from(
          json['pic']?.map((x) => SearchHotTag.fromJson(x)) ?? []),
      story: List<SearchHotTag>.from(
          json['story']?.map((x) => SearchHotTag.fromJson(x)) ?? []),
      all: List<SearchHotTag>.from(
          json['all']?.map((x) => SearchHotTag.fromJson(x)) ?? []));

  Map<String, dynamic> toJson() => {
        'mv': mv,
        'vlog': vlog,
        'book': book,
        'girl': girl,
        'pic': pic,
        'story': story,
        'all': all
      };
}
