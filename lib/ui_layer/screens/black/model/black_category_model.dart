class BlackCategoryModel {
  List<BlackCategory>? list;
  String lastIx;

  BlackCategoryModel({this.list, this.lastIx = ''});

  factory BlackCategoryModel.fromJson(Map<String, dynamic> json) {
    return BlackCategoryModel(
      list: json['list'] != null ?  List<BlackCategory>.from(json['list'].map((e) => BlackCategory.fromJson(e))) : null,
      lastIx: json['last_ix'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'list': list,
      'last_ix': lastIx,
    };
  }
}

class BlackCategory {

  bool current;
  int mid;
  String name;
  String apiList;
  Map<String, dynamic>? paramsList;

  BlackCategory({this.current = false, this.mid = 0, this.name = '', this.apiList = '', this.paramsList});

  factory BlackCategory.fromJson(Map<String, dynamic> json) {
    return BlackCategory(
      current: json['current'],
      mid: json['mid'],
      name: json['name'],
      apiList: json['api_list'],
      paramsList: json['params_list'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current': current,
      'mid': mid,
      'name': name,
      'api_list': apiList,
      'params_list': paramsList,
    };
  }
}
