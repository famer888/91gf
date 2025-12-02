class NoticeMessage {
  NoticeMessage(
      {this.id,
      this.aff,
      this.content,
      this.read,
      this.createdAt,
      this.updatedAt,
      this.title,
      required this.type,
      required this.relatedId});

  final int? id;
  final int? aff;
  final String? content;
  final int? read;
  final dynamic createdAt;
  final dynamic updatedAt;
  final String? title;
  final int type;
  final int relatedId;

  factory NoticeMessage.fromJson(Map<String, dynamic> json) => NoticeMessage(
      id: json['id'],
      aff: json['aff'],
      content: json['content'],
      read: json['read'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      title: json['title'],
      type: json['type'] ?? 0,
      relatedId: json['related_id'] ?? 0);

  Map<String, dynamic> toJson() => {
        'id': id,
        'aff': aff,
        'content': content,
        'read': read,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'title': title,
        'type': type,
        'related_id': relatedId
      };
}
