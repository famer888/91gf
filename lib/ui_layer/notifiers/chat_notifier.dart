import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../domain/domain.dart';
import '../../domain/model/member_model.dart';
import '../utils/im_web_socket.dart';

class ChatNotifier extends ChangeNotifier {
  ChatNotifier({
    required this.cache,
    required this.member,
    required this.oauthType,
    required this.oauthId,
  }) {
    if (member.chat case final chat?) {
      _initChats();
      _imWebSocket = ImWebSocket(
          urls: [chat.line],
          via: chat.via,
          key: chat.key,
          iv: chat.iv,
          token: chat.token,
          responseListener: _imResponseListener,
          onStatusChanged: (status) {
            if (status == ImWebSocketStatus.connected) {
              _sendInitUser();
            }
          });
      _imWebSocket!.webSocketConnect();
    }
  }

  ImWebSocket? _imWebSocket;

  late final Member member;
  final ChatCacheDomain cache;

  final String oauthType;
  final String oauthId;

  List<ChatList> get chats => [..._chats];

  List<ChatList> _chats = [];

  //获取本地im列表
  Future _initChats() async {
    final data = await cache.readChats();
    if (data.isEmpty) return;
    final st = jsonDecode(data);
    _chats = List<ChatList>.from(st.map((x) => ChatList.fromJson(x)));
    notifyListeners();
  }

  Future _sendInitUser() async {
    if (_imWebSocket == null) {
      return;
    }
    await _imWebSocket?.sendEvent(ImRequestType.initUser, data: {
      'uuid': member.uuid,
      'phone': member.username,
      'nickname': member.nickname,
      'oauth_type': oauthType,
      'oauth_id': oauthId,
      'avatar': member.thumb,
    });
  }

  Future saveChats() => cache.upsertChats(chats: jsonEncode(chats));

  clearChats() {
    _chats = [];

    cache.upsertChats(chats: '');
    notifyListeners();
  }

  removeChat(String touid) {
    _chats.removeWhere((el) => el.id == '${member.uuid}_$touid');
    saveChats();
    notifyListeners();
  }

  //更新chats列表
  updateChatIM(ChatMessage chat) {
    if (chat.touser?.uuid == '') return;
    ChatList? child;
    for (var item in _chats) {
      if (item.id == '${member.uuid}_${chat.touser?.uuid}') {
        child = item;
        break;
      }
    }
    if (child == null) {
      ChatList tp = ChatList(
        id: '${member.uuid}_${chat.touser?.uuid}',
        count: 0,
        list: [],
        touser: chat.touser,
      );

      tp.list.add(ChatMessage.fromJson(chat.toJson()));

      //处理未读消息 只针对他人
      if (chat.type == 1) tp.count = 1;
      //save
      _chats.add(ChatList.fromJson(tp.toJson()));
    } else {
      if (chat.type == 1) child.count += 1;
      //save
      child.list.add(ChatMessage.fromJson(chat.toJson()));
    }
    saveChats();
    notifyListeners();
  }

  Future _imResponseListener(ImResponseModel response) async {
    try {
      final type = response.type;
      final message = response.message;

      switch (type) {
        case ImResponseType.ackMessage:
          break;
        case ImResponseType.chatMessage:
          final data = message['data'];

          ChatMessage chat = ChatMessage(
            nickname: Uri.encodeComponent(data['nickname']),
            content: data['content'],
            type: 1,
            avatar: Uri.encodeComponent(
              data['avatar'],
            ),
            time: data['timestamp'].toString(),
            content_type: data['content_type'] == 'photos' ? 1 : 0,
            touser: ChatUser(
              nickname: Uri.encodeComponent(data['nickname']),
              avatar: Uri.encodeComponent(data['avatar']),
              uuid: data['from_uuid'],
            ),
          );

          updateChatIM(chat);

          break;
        case ImResponseType.unReadMessage:
          final data = message['data'];

          ChatMessage chat = ChatMessage(
            nickname: Uri.encodeComponent(data['nickname']),
            content: data['content'],
            type: 1,
            avatar: Uri.encodeComponent(
              data['avatar'],
            ),
            time: data['created_at'].toString(),
            content_type: data['content_type'] == 'photos' ? 1 : 0,
            touser: ChatUser(
              nickname: Uri.encodeComponent(data['nickname']),
              avatar: Uri.encodeComponent(data['avatar']),
              uuid: data['from_uuid'],
            ),
          );

          updateChatIM(chat);
          break;
        case ImResponseType.queryOnline:
          final data = message['data'];
          final uuid = data['query_uuid'];
          _queryOnlineCompleter[uuid]?.complete(data);
          _queryOnlineCompleter.remove(uuid);

          break;
        case ImResponseType.unknown:
          break;
      }
      notifyListeners();
    } catch (_) {}
  }

  final Map<String, Completer<Map>> _queryOnlineCompleter = {};

  Future<Map> queryOnline(String uuid) async {
    final completer = Completer<Map>();
    _queryOnlineCompleter[uuid] = completer;
    _imWebSocket?.sendEvent(ImRequestType.queryOnline, data: {
      'to_uuid': uuid,
    });
    Future.delayed(const Duration(seconds: 10)).then((_) {
      _queryOnlineCompleter[uuid]?.completeError(TimeoutException(''));
      _queryOnlineCompleter.remove(uuid);
    });
    return completer.future;
  }

  //发送WebSocket消息
  Future<void> sendMessage(
      ChatUser target, String content, String msgType) async {
    if (_imWebSocket == null) {
      return;
    }
    ChatMessage chat = ChatMessage(
      nickname: Uri.encodeComponent(member.nickname),
      content: content,
      type: 0,
      avatar: Uri.encodeComponent(member.thumb ?? ''),
      time: (DateTime.now().millisecondsSinceEpoch / 1000).floor().toString(),
      content_type: msgType == 'photos' ? 1 : 0,
      touser: target,
    );

    updateChatIM(chat);

    return _imWebSocket?.sendEvent(ImRequestType.chat, data: {
      'to_uuid': target.uuid,
      'type': 'friend',
      'msgType': msgType,
      'content': content,
      'microtime': chat.time,
    });
  }

  @override
  void dispose() {
    _imWebSocket?.webSocketDisconnect();
    super.dispose();
  }
}

class ChatMessage {
  ChatMessage({
    required this.nickname,
    required this.content,
    required this.type,
    required this.avatar,
    required this.time,
    required this.content_type,
    required this.touser,
  });
  String nickname;
  String avatar;
  String content;
  int type;
  int content_type; // 0 是文本 1 是图片
  String time;

  ChatUser? touser;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        nickname: json['nickname'] ?? '',
        content: json['content'] ?? '',
        avatar: json['avatar'] ?? '',
        type: json['type'] ?? 0,
        content_type: json['content_type'] ?? 0,
        time: json['time'] ?? '',
        touser:
            json['touser'] == null ? null : ChatUser.fromJson(json['touser']),
      );

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'content': content,
        'avatar': avatar,
        'content_type': content_type,
        'type': type,
        'time': time,
        'touser': touser?.toJson(),
      };
}

class ChatList {
  ChatList({
    required this.id,
    required this.count,
    required this.list,
    required this.touser,
  });
  String id; //uuid + other uuid
  int count;
  List<ChatMessage> list;
  ChatUser? touser;

  factory ChatList.fromJson(Map<String, dynamic> json) => ChatList(
        id: json['id'] ?? '',
        count: json['count'] ?? 0,
        list: json['list'] == null
            ? []
            : List<ChatMessage>.from(
                json['list'].map((x) => ChatMessage.fromJson(x))),
        touser:
            json['touser'] == null ? null : ChatUser.fromJson(json['touser']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'count': count,
        'list': List<dynamic>.from(list.map((x) => x.toJson())),
        'touser': touser?.toJson(),
      };
}

class ChatUser {
  ChatUser({required this.nickname, required this.avatar, required this.uuid});
  String nickname;
  String avatar;
  String uuid;

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        nickname: json['nickname'] ?? '',
        avatar: json['avatar'] ?? '',
        uuid: json['uuid'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'avatar': avatar,
        'uuid': uuid,
      };
}

class IMChatModel {
  IMChatModel({
    required this.token,
    required this.via,
    required this.key,
    required this.iv,
    required this.imgBase,
    required this.line,
  });
  final String token;
  final String via;
  final String key;
  final String iv;
  final String imgBase;
  final String line;

  factory IMChatModel.fromJson(Map<String, dynamic> json) => IMChatModel(
        token: json['token'] ?? '',
        via: json['via'] ?? '',
        key: json['key'] ?? '',
        iv: json['iv'] ?? '',
        imgBase: json['img_base'] ?? '',
        line: json['line'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'token': token,
        'via': via,
        'key': key,
        'iv': iv,
        'img_base': imgBase,
        'line': line,
      };
}
