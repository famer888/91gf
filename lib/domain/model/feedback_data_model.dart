class FeedBackData {
  final int? id;
  final String? nickname;
  final String? thumb;
  final dynamic message;
  final int messageType;
  final int status;
  final String? createdAt;
  final int? isLocal;
  final List<Problem>? problemList;

  FeedBackData({
    required this.id,
    required this.nickname,
    required this.thumb,
    this.message,
    required this.messageType,
    required this.status,
    this.createdAt,
    this.isLocal,
    this.problemList,
  });

  factory FeedBackData.fromJson(Map<String, dynamic> json) => FeedBackData(
        id: json['id'],
        nickname: json['nickname'],
        thumb: json['thumb'],
        message: json['message'],
        messageType: json['messageType'],
        status: json['status'],
        createdAt: json['createdAt'],
        isLocal: json['isLocal'],
        problemList: json['problemList'] == null
            ? null
            : List<Problem>.from(
                json['problemList'].map((x) => Problem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'thumb': thumb,
        'message': message,
        'messageType': messageType,
        'status': status,
        'createdAt': createdAt,
        'isLocal': isLocal,
        'problemList': problemList == null
            ? null
            : List<dynamic>.from(problemList!.map((x) => x.toJson())),
      };
}

class Problem {
  final String? problem;
  final String? reply;

  Problem({
    this.problem,
    this.reply,
  });

  factory Problem.fromJson(Map<String, dynamic> json) => Problem(
        problem: json['problem'],
        reply: json['reply'],
      );

  Map<String, dynamic> toJson() => {
        'problem': problem,
        'reply': reply,
      };
}
