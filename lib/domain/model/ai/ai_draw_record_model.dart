class AIDrawRecordModel {
  final int id;
  final int aff;
  final String title;
  final String prompt;
  final String negativePrompt;
  final String size;
  final List<Thumbs> thumb;
  final int status;
  final String reason;
  final String createdAt;

  AIDrawRecordModel({
    required this.id,
    required this.aff,
    required this.title,
    required this.prompt,
    required this.negativePrompt,
    required this.size,
    required this.thumb,
    required this.status,
    required this.reason,
    required this.createdAt,
  });

  factory AIDrawRecordModel.fromJson(Map<String, dynamic> json) {
    return AIDrawRecordModel(
      id: json["id"],
      aff: json["aff"],
      title: json["title"],
      prompt: json["prompt"],
      negativePrompt: json["negative_prompt"],
      size: json["size"],
      thumb: List<Thumbs>.from(json["thumb"].map((x) => Thumbs.fromJson(x))),
      status: json["status"],
      reason: json["reason"],
      createdAt: json["created_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "aff": aff,
      "title": title,
      "prompt": prompt,
      "negative_prompt": negativePrompt,
      "size": size,
      "thumb": List<dynamic>.from(thumb.map((x) => x.toJson())),
      "status": status,
      "reason": reason,
      "created_at": createdAt,
    };
  }
}

class Thumbs {
  final String url;
  final int w;
  final int h;

  Thumbs({
    required this.url,
    required this.w,
    required this.h,
  });

  factory Thumbs.fromJson(Map<String, dynamic> json) => Thumbs(
        url: json["url"],
        w: json["w"],
        h: json["h"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "w": w,
        "h": h,
      };
}
