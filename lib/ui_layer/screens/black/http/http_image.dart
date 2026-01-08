import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:isolated_worker/worker_delegator.dart';
import 'package:universal_html/html.dart' as html;

import 'http_config.dart';

Dio _imageDio = Dio(BaseOptions(
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 60),
  responseType: ResponseType.bytes,
  validateStatus: (status) => status! < 500,
));

class HttpImage {
  /////////////////////////////////////////////////
  /// 单例
  static final HttpImage _instance = HttpImage._();
  HttpImage._();
  static HttpImage get instance => _instance;
  /////////////////////////////////////////////////

  final List<dynamic> taskList = [];
  final Map<dynamic, Map> tasksMap = {};
  final List<bool> syncTaskStatus = List.generate(5, (index) => false);
  void addImageTask({
    required dynamic key, // 标识
    required String url, // 资源地址
    void Function(Uint8List)? success,
    void Function()? failure,
  }) {
    taskList.add(key); // 有序任务列表
    tasksMap[key] = {0: url.trim(), 1: success, 2: failure}; // 任务集
    executeNextTask(); // 执行任务
  }

  void cancleImageTask(dynamic key) {
    bool isOk = taskList.remove(key);
    isOk ? tasksMap.remove(key) : null;
    // LogUtil.i('remove task -----> $key $isOk');
  }

  void executeNextTask() {
    int freeIndex = syncTaskStatus.indexWhere((i) => !i);
    if (freeIndex == -1 || taskList.isEmpty) return;

    /// 有任务可执行
    syncTaskStatus[freeIndex] = true;
    onloadImage(taskList.removeLast(), freeIndex);
  }

  void onloadImage(dynamic key, int index) async {
    Map task = tasksMap.remove(key) ?? {};

    /// 数据检查
    // if (task.isEmpty) return LogUtil.i('-- error --> $key');
    // if (task[0] == null || task[0] == '') return; // url
    // if (task[1] is! Function) return; // 回调函数
    if (task.isEmpty ||
        task[0] == null ||
        task[0] == '' ||
        task[1] is! Function) {
      // debugPrint('-- error --> $key');
      syncTaskStatus[index] = false;
      return executeNextTask();
    }

    /// 数据获取
    dynamic decrypted = HttpConfig.instance.imageCacheBox?.get(task[0]);
    decrypted ??= await toGetRemoteImageData(task[0], index);
    if (decrypted is Uint8List) {
      task[1](decrypted); // success -> Uint8List
    } else if (task[2] != null) {
      task[2](); // void Function()? failure
    }

    /// 执行下一个任务
    decrypted = null; // 强制 释放
    syncTaskStatus[index] = false;
    executeNextTask();
  }

  Future toGetRemoteImageData(String url, int index) async {
    try {
      var data = await toGetEncryptImageData(url);
      dynamic decrypted;
      // 解密
      if (data != '' && data != null) {
        decrypted = await WorkerDelegator().run('decryptImage$index', data);
      }
      // 缓存 及 返回
      if (decrypted != '' && decrypted != null) {
        decrypted = base64Decode(decrypted);
        // if (isNovel) {
        //   decrypted = utf8.decode(decrypted);
        // }
        HttpConfig.instance.imageCacheBox?.put(url, decrypted);
        return decrypted;
      } else {
        dPrint('image error -----> $url');
        return null;
      }
    } catch (error) {
      dPrint('image catch -----> ${error.toString()}');
      return null;
    }
  }

  Future toGetEncryptImageData(String url) {
    if (url.contains('http') == false) return Future(() => '');
    return kIsWeb
        ? html.HttpRequest.request(
            url,
            responseType: 'arraybuffer',
          ).then((xhr) {
            if (xhr.response == null) return '';
            return base64Encode(xhr.response.asUint8List());
          }).onError((error, stackTrace) => '')
        : _imageDio.get(url).then((res) {
            if (res.data == null) return '';
            return base64Encode(res.data);
          }).onError((error, stackTrace) => '');
  }

  static Future unencryptImage(String url) {
    if (url.contains('http') == false) return Future(() => '');
    return kIsWeb
        ? html.HttpRequest.request(
            url,
            responseType: 'arraybuffer',
          ).then((xhr) {
            if (xhr.response == null) return '';
            return xhr.response.asUint8List();
          }).onError((error, stackTrace) => '')
        : _imageDio.get(url).then((res) {
            if (res.data == null) return '';
            return Uint8List.fromList(res.data);
          }).onError((error, stackTrace) => '');
  }
}
