class TrackReportInfo  {
  String? typeId;
  String? typeName;

  static TrackReportInfo fromMap(Map<String, dynamic>? map) {
    map ??= {};
    TrackReportInfo info = TrackReportInfo();
    info.typeId = map['typeId'];
    info.typeName = map['typeName'];
    return info;
  }

  Map toJson() => {
    "typeId": typeId,
    "typeName": typeName,
  };
}