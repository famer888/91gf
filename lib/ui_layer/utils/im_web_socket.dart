import 'dart:async';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class ImWebSocket {
  ImWebSocket({
    required this.urls,
    required this.via,
    required this.key,
    required this.iv,
    required this.token,
    required this.responseListener,
    required this.onStatusChanged,
  });

  final List<String> urls;
  final String via;
  final String token;
  final String key;
  final String iv;

  ImWebSocketStatus _webSocketStatus = ImWebSocketStatus.disconnected;

  final ValueChanged<ImWebSocketStatus> onStatusChanged;

  final ValueChanged<ImResponseModel> responseListener;

  WebSocketChannel? _webSocketChannel;
  StreamSubscription? _webSocketSubscription;

  Timer? _heartBeatTimer;
  final int _hearBeatInterval = 12;
  Timer? _reconnectTimer;
  final int _reconnectInterval = 5;

  int _retryCount = 0;

  void _setWebSocketStatus(ImWebSocketStatus status) {
    _webSocketStatus = status;
    onStatusChanged(_webSocketStatus);
  }

  Future webSocketConnect() async {
    if (_webSocketStatus != ImWebSocketStatus.disconnected) return;
    _setWebSocketStatus(ImWebSocketStatus.connecting);
    final url = urls[_retryCount % urls.length];
    _webSocketChannel = WebSocketChannel.connect(Uri.parse(url));
    try {
      await _webSocketChannel!.ready;
      _webSocketSubscription = _webSocketChannel?.stream.listen(
        _onData,
        onError: (e) => _webSocketReconnect,
        onDone: _webSocketReconnect,
      );
      _startHeartBeat();
      _setWebSocketStatus(ImWebSocketStatus.connected);
    } catch (e) {
      _webSocketReconnect();
    }
  }

  void _onData(dynamic event) async {
    if (event == '"pong"') return;

    try {
      final message = jsonDecode(event);
      if (message is Map) {
        final String messageType = message['message_type'];
        final type = messageType.toImResponseType();
        final data = message['data'];
        if (data != null) {
          final decryptMessage =
              await _Crypto.decryptResData(message['data'], key, iv);
          final data = jsonDecode(decryptMessage);
          message['data'] = data;
        }
        responseListener(ImResponseModel(message: message, type: type));
      }
    } catch (_) {}
  }

  void webSocketDisconnect() async {
    _webSocketChannel?.sink.close();
    _webSocketChannel = null;
    _webSocketSubscription?.cancel();
    _webSocketSubscription = null;
    _heartBeatTimer?.cancel();
    _heartBeatTimer = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _setWebSocketStatus(ImWebSocketStatus.disconnected);
  }

  Future<void> _webSocketReconnect() async {
    _retryCount++;
    webSocketDisconnect();
    _reconnectTimer = Timer(Duration(seconds: _reconnectInterval), () {
      webSocketConnect();
    });
  }

  void _startHeartBeat() {
    _heartBeatTimer = Timer.periodic(Duration(seconds: _hearBeatInterval),
        (_) => sendEvent(ImRequestType.ping));
  }

  Future sendEvent(ImRequestType type, {Map? data}) async {
    final Map payload = {
      'route': type.toRoute(),
      'encrypt': 'self',
    };

    if (type != ImRequestType.ping) {
      payload['via'] = via;
      payload['token'] = token;
    }

    if (data != null) {
      if (data['sign'] != null) {
        payload['ack_id'] = data['sign'];
      }
      final encryptedData =
          await _Crypto.encryptReqParams(jsonEncode(data), key, iv);
      payload['data'] = encryptedData;
    }

    _webSocketChannel?.sink.add(jsonEncode(payload));
  }
}

class _Crypto {
  static FutureOr<dynamic> encryptReqParams(
      String word, String key, String iv) async {
    final encrypter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));
    final encrypted =
        encrypter.encryptBytes(utf8.encode(word), iv: IV.fromUtf8(iv));
    final data = utf8.decode(encrypted.base64.codeUnits);
    return data;
  }

  static FutureOr<String> decryptResData(
      dynamic data, String key, String iv) async {
    final encrypter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));
    final encrypted = Encrypted.fromBase64(data);
    final decrypted = encrypter.decrypt(encrypted, iv: IV.fromUtf8(iv));
    return decrypted;
  }
}

enum ImWebSocketStatus {
  connecting,
  connected,
  disconnected,
}

enum ImRequestType {
  initUser,
  queryOnline,
  chat,
  ping,
}

enum ImResponseType {
  chatMessage,
  unReadMessage,
  queryOnline,
  ackMessage,
  unknown,
}

extension _ToRoute on ImRequestType {
  String toRoute() {
    switch (this) {
      case ImRequestType.initUser:
        return 'chat/initUser';
      case ImRequestType.queryOnline:
        return 'chat/isOnline';
      case ImRequestType.chat:
        return 'chat/chat';
      case ImRequestType.ping:
        return 'chat/ping';
    }
  }
}

extension _ToImResponseType on String {
  ImResponseType toImResponseType() {
    switch (this) {
      case 'ackMessage':
        return ImResponseType.ackMessage;
      case 'chatMessage':
        return ImResponseType.chatMessage;
      case 'unReadMessage':
        return ImResponseType.unReadMessage;
      case 'queryOnline':
        return ImResponseType.queryOnline;
      default:
        return ImResponseType.unknown;
    }
  }
}

class ImResponseModel {
  ImResponseModel({required this.type, required this.message});
  final ImResponseType type;
  final Map message;
}
