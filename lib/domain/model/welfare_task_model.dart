class WelfareTaskModel {
  String? title;
  int? freeViewCnt;
  int? totalFreeViewCnt;
  int? invitedNum;
  int? exp;
  List<WelfareTaskListModel>? list;
  List<WelfareTaskListModel>? signRewardList;
  int? incomeMoney;
  bool? signStatus;
  int? signNum;

  WelfareTaskModel(
      {this.title,
      this.freeViewCnt,
      this.totalFreeViewCnt,
      this.invitedNum,
      this.exp,
      this.list,
      this.signRewardList,
      this.signStatus,
      this.signNum,
      this.incomeMoney});

  WelfareTaskModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    freeViewCnt = json['free_view_cnt'];
    totalFreeViewCnt = json['total_free_view_cnt'];
    invitedNum = json['invited_num'];
    exp = json['exp'];
    if (json['list'] != null) {
      list = <WelfareTaskListModel>[];
      json['list'].forEach((v) {
        list!.add(WelfareTaskListModel.fromJson(v));
      });
    }
    if (json['sign_reward_list'] != null) {
      signRewardList = <WelfareTaskListModel>[];
      json['sign_reward_list'].forEach((v) {
        signRewardList!.add(WelfareTaskListModel.fromJson(v));
      });
    }
    incomeMoney = json['income_money'];
    signStatus = json['sign_status'] ?? false;
    signNum = json['sign_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['free_view_cnt'] = freeViewCnt;
    data['total_free_view_cnt'] = totalFreeViewCnt;
    data['invited_num'] = invitedNum;
    data['exp'] = exp;
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    if (signRewardList != null) {
      data['sign_reward_list'] =
          signRewardList!.map((v) => v.toJson()).toList();
    }
    data['income_money'] = incomeMoney;
    data['sign_status'] = signStatus;
    data['sign_num'] = signNum;
    return data;
  }
}

class WelfareTaskListModel {
  int? id;
  String? title;
  String? subTitle;
  String? icon;
  int? taskType;
  int? rewardType;
  int? rewardValue;
  int? status;
  int? sort;
  String? appUrl;
  int? progressStatus;
  String? desc;

  WelfareTaskListModel({
    this.id,
    this.title,
    this.subTitle,
    this.icon,
    this.taskType,
    this.rewardType,
    this.rewardValue,
    this.status,
    this.sort,
    this.appUrl,
    this.progressStatus,
    this.desc,
  });

  WelfareTaskListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subTitle = json['sub_title'];
    icon = json['icon'];
    taskType = json['task_type'];
    rewardType = json['reward_type'];
    rewardValue = json['reward_value'];
    status = json['status'];
    sort = json['sort'];
    appUrl = json['app_url'];
    progressStatus = json['progress_status'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['sub_title'] = subTitle;
    data['icon'] = icon;
    data['task_type'] = taskType;
    data['reward_type'] = rewardType;
    data['reward_value'] = rewardValue;
    data['status'] = status;
    data['sort'] = sort;
    data['app_url'] = appUrl;
    data['progress_status'] = progressStatus;
    data['desc'] = desc;
    return data;
  }
}
