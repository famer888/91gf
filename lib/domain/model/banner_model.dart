class BannerModel {
  final int id;
  final String linkUrl;
  final String resourceUrl;
  final int redirectType;
  final String? title;
  final String? name;
  final String? desc;
  final String router;
  final int? openType;
  final int? fId;
  final int reportId;
  final int? reportType;
  final String? imgUrl;
  final String? urlStr;
  final int? adType;
  final String? adSlotName;
  final String? advertiseCode;
  final String? advertiseLocationCode;

  BannerModel({
    required this.id,
    required this.linkUrl,
    required this.resourceUrl,
    required this.redirectType,
    this.title,
    this.name,
    this.desc,
    required this.router,
    this.openType,
    this.fId,
    required this.reportId,
    required this.reportType,
    required this.urlStr,
    this.imgUrl,
    this.adType,
    this.adSlotName,
    this.advertiseCode,
    this.advertiseLocationCode,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json['id'],
        linkUrl: json['link_url'] ?? '',
        resourceUrl: json['resource_url'] ?? '',
        redirectType: json['redirect_type'] ?? 0,
        title: json['title'],
        name: json['name'],
        desc: json['desc'],
        router: json['router'] ?? '',
        openType: json['open_type'],
        fId: json['f_id'],
        reportId: json['report_id'] ?? 0,
        reportType: json['report_type'] ?? 0,
        urlStr: json['url_str'] ?? '',
        imgUrl: json['img_url'] ?? '',
        adType: json['ad_type'] is int
            ? json['ad_type']
            : int.tryParse('${json['ad_type']}'),
        adSlotName: json['ad_slot_name'] as String?,
        advertiseCode: json['advertise_code'] as String?,
        advertiseLocationCode: json['advertise_location_code'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'link_url': linkUrl,
        'resource_url': resourceUrl,
        'redirect_type': redirectType,
        'title': title,
        'desc': desc,
        'router': router,
        'open_type': openType,
        'f_id': fId,
        'report_id': reportId,
        'report_type': reportType,
        'url_str': urlStr,
        'img_url': imgUrl,
        'ad_type': adType,
        'ad_slot_name': adSlotName,
        'advertise_code': advertiseCode,
        'advertise_location_code': advertiseLocationCode,
      };
}
