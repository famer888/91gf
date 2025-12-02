import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app_global.dart';
import '../../crypto.dart';
import '../../domain/domain.dart';
import 'common_utils.dart';
import 'my_toast.dart';

Dio dio = Dio();

class DownloadUtil {
  DownloadUtil({required this.cache});
  final VideoDownloadCacheDomain cache;

  List downloadTasks = []; // 下载任务队列
  bool downloading = false; // 是否存在下载任务
  int finishCount = 0; // 当前下载完成的分片数量
  bool creating = false; // 防止连点
  bool currentRemove = false; // 当前下载任务是否被删除

  final ValueNotifier<Map> downloadVideoProgress = ValueNotifier({});

  removeTask(String deleteId) {
    if (downloadTasks.isEmpty) {
      return;
    }
    bool haveCurrent = deleteId == downloadTasks[0]['taskInfo']['id'];
    downloadTasks.removeWhere((e) => e['taskInfo']['id'] == deleteId);
    if (haveCurrent) {
      downloading = false;
      currentRemove = true;
      startNext();
    }
  }

  // 获取地址
  Future<String> getPath(String folderName) async {
    late final Directory documents;
    if (Platform.isAndroid) {
      documents = await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory();
    } else {
      documents = await getApplicationDocumentsDirectory();
    }
    final path = documents.path;
    final cachePath = '$path/$folderName/';
    final directory = Directory(cachePath);
    final isExists = await directory.exists();
    if (!isExists) {
      await directory.create(recursive: true);
    }
    return cachePath;
  }

  // 获取地址
  Future<String> getEnvironmentPath(String folderName) async {
    late final String path;
    if (Platform.isAndroid) {
      final osp = await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory();
      final packageInfo = await PackageInfo.fromPlatform();
      path = osp.path.replaceAll('/${packageInfo.packageName}/files', '');
    } else {
      final osp = await getApplicationDocumentsDirectory();
      path = osp.path;
    }

    String cachePath = '$path/$folderName/';
    Directory directory = Directory(path);
    bool isExists = await directory.exists();
    if (!isExists) {
      await directory.create(recursive: true);
    }
    return cachePath;
  }

  static String _checkIV(String data) {
    if (data.contains('IV=') == false) {
      String ivData = data.replaceAll(
          '#EXT-X-KEY:METHOD=AES-128,', '#EXT-X-KEY:METHOD=AES-128,IV=0x0,');
      return ivData;
    }
    return data;
  }

  // 视频解密，返回ts队列
  static Future<Map> getTsList(String urlPath) async {
    // 视频地址解密
    String decrypted;
    var res = await Dio().get(urlPath);
    if (AppGlobal.m3u8Encrypt == '1') {
      decrypted = PlatformAwareCrypto.decryptM3U8(res.data);
    } else {
      decrypted = res.data;
    }
    decrypted = _checkIV(decrypted);
    String localM3u8 = decrypted;
    // 整理key和ts链接
    List<String> lists = decrypted.split('#EXTINF:');
    List<String> tsLists = [];
    for (var el in lists) {
      var regSrcExp = RegExp(
          r'(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?');
      String matchfix = regSrcExp.stringMatch(el) ?? '';
      if (matchfix.contains('.key')) {
        localM3u8 = localM3u8.replaceAll(
            matchfix,
            matchfix.substring(
                matchfix.lastIndexOf('/') + 1, matchfix.indexOf('.key') + 4));
      }
      if (matchfix.contains('.ts')) {
        localM3u8 = localM3u8.replaceAll(
            matchfix,
            matchfix.substring(
                matchfix.lastIndexOf('/') + 1, matchfix.indexOf('.ts') + 3));
      }
      tsLists.add(matchfix);
    }
    return {'localM3u8': localM3u8, 'tsLists': tsLists};
  }

  // 初始化下载状态
  initStatus(int finishNum) {
    downloading = true;
    currentRemove = false;
    finishCount = finishNum;
  }

  // 开始下个任务
  startNext() async {
    if (downloadTasks.isNotEmpty) {
      // LogUtil.d("${downloadTasks[0]["taskInfo"]["title"]}");

      List tasks = await cache.readDownloadVideoTasks();
      downloadTasks[0]['taskInfo']['downloading'] = true;
      int taskNum = tasks
          .indexWhere((e) => e['id'] == downloadTasks[0]['taskInfo']['id']);
      // LogUtil.d("${tasks[taskNum]["title"]}");
      tasks[taskNum]['downloading'] = true;
      tasks[taskNum]['isWaiting'] = false;
      await cache.upsertDownloadVideoTasks(tasks: tasks);
      downloadContent(tasks[taskNum]);
    } else {
      downloading = false;
    }
  }

  // 请求权限
  Future<bool> getPermission() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      // Android 13 (API 33) 及以上版本
      return await requestPermissionsForAndroid13AndAbove();
    } else {
      // Android 13 以下版本
      return await getAndroid12Permission();
    }
  }

  Future<bool> requestPermissionsForAndroid13AndAbove() async {
    bool allPermissionsGranted = true;

    var statusVideos = await Permission.videos.status;
    if (statusVideos.isDenied) {
      var result = await Permission.videos.request();
      if (!result.isGranted) {
        allPermissionsGranted = false;
      }
    }

    var statusAudio = await Permission.audio.status;
    if (statusAudio.isDenied) {
      var result = await Permission.audio.request();
      if (!result.isGranted) {
        allPermissionsGranted = false;
      }
    }

    return allPermissionsGranted;
  }

  Future<bool> getAndroid12Permission() async {
    PermissionStatus storageStatus = await Permission.storage.status;
    if (storageStatus == PermissionStatus.denied) {
      storageStatus = await Permission.storage.request();
      if (storageStatus == PermissionStatus.denied ||
          storageStatus == PermissionStatus.permanentlyDenied) {
        return false;
      }
      return true;
    } else if (storageStatus == PermissionStatus.permanentlyDenied) {
      return false;
    }
    return true;
  }

  // 创建下载任务
  /*
   * taskInfo数据结构:
   * id              视频id
   * urlPath         下载地址（需解密）
   * title           视频标题
   * thumbCover      视频封面
   * tags            视频标签
   * contentType     视频类型
   * downloading     视频下载状态 bool
   * isWaiting       是否在下载队列中 bool
   * url             视频m3u8储存地址
   * tsLists         视频ts链接队列
   * localM3u8       本地m3u8文件 string
   * tsListsFinished 已下载完成的ts队列
   * progress        视频下载进度
   */
  createDownloadTask({
    required Map taskInfo,
  }) async {
    if (creating) {
      MyToast.showText(text: 'dtk'.tr());
      return;
    }
    bool havePermission = await getPermission();
    if (havePermission) {
      creating = true;
    } else {
      MyToast.showText(text: 'qdkqx'.tr());
      return;
    }
    try {
      List tasks = await cache.readDownloadVideoTasks();
      int existTaskIndex = tasks.indexWhere((e) => e['id'] == taskInfo['id']);
      int existDownloadTaskIndex = downloadTasks
          .indexWhere((e) => e['taskInfo']['id'] == taskInfo['id']);
      // 存在下载任务
      if (tasks.isNotEmpty && existTaskIndex != -1) {
        if (tasks[existTaskIndex]['downloading'] ||
            tasks[existTaskIndex]['progress'] == 1 ||
            existDownloadTaskIndex != -1) {
          MyToast.showText(text: 'yczxz'.tr());
        } else if (downloading) {
          MyToast.showText(text: 'ztjdl'.tr());
          downloadTasks.add({'taskInfo': tasks[existTaskIndex]});
          tasks[existTaskIndex]['isWaiting'] = true;
          await cache.upsertDownloadVideoTasks(tasks: tasks);
        } else {
          MyToast.showText(text: 'jxxz'.tr());
          downloadTasks.add({'taskInfo': tasks[existTaskIndex]});
          downloadContent(tasks[existTaskIndex]);
          tasks[existTaskIndex]['downloading'] = true;
          tasks[existTaskIndex]['isWaiting'] = false;
          await cache.upsertDownloadVideoTasks(tasks: tasks);
        }
        creating = false;
        return;
      }
      MyToast.showText(text: 'ytjzwck'.tr());
      // 生成本地m3u8和ts下载列表
      Map tsData = await getTsList(taskInfo['urlPath']);
      String localM3u8 = tsData['localM3u8'];
      List<String> tsLists = tsData['tsLists'];
      taskInfo['tsLists'] = tsLists;
      taskInfo['localM3u8'] = localM3u8;
      taskInfo['tsListsFinished'] = [];
      // 添加下载队列
      downloadTasks.add({'taskInfo': taskInfo});
      // 获取储存地址
      String saveDirectory =
          await getPath('${DateTime.now().millisecondsSinceEpoch}');
      // 存储本地m3u8文件
      String m3u8Name = taskInfo['urlPath'].substring(
          taskInfo['urlPath'].lastIndexOf('/') + 1,
          taskInfo['urlPath'].indexOf('m3u8') + 4);
      await File('$saveDirectory$m3u8Name').writeAsString(localM3u8);
      taskInfo['url'] = '$saveDirectory$m3u8Name';
      CommonUtils.log(taskInfo);
      if (!downloading) {
        taskInfo['downloading'] = true;
        taskInfo['isWaiting'] = false;
        downloadContent(taskInfo);
      }
      // 储存下载任务信息
      taskInfo['progress'] = 0;
      tasks.insert(0, taskInfo);
      await cache.upsertDownloadVideoTasks(tasks: tasks);

      creating = false;
    } catch (e) {
      MyToast.showText(text: 'xzcjsb'.tr());
      creating = false;
    }
  }

  Future<void> downloadContent(Map taskInfo) async {
    List tsListsFinished = taskInfo['tsListsFinished'];
    initStatus(tsListsFinished.length);
    List<String> tsLists = [];
    tsLists.addAll(taskInfo['tsLists']);
    String saveDirectory =
        taskInfo['url'].substring(0, taskInfo['url'].lastIndexOf('/'));
    // 提取未完成的下载任务队列
    // LogUtil.d("下载任务id---------${taskInfo["id"]}");
    if (tsListsFinished.isNotEmpty) {
      tsLists.removeWhere((e) {
        for (var i = 0; i < tsListsFinished.length; i++) {
          if (tsListsFinished[i] == e) {
            return true;
          }
        }
        return false;
      });
    }
    // // 建立下载任务列表
    // List<Future> taskList() {
    //   return tsLists.asMap().entries.map((e) {
    //     int index = e.key;
    //     String value = e.value;
    //     String savePath = saveDirectory +
    //         "/" +
    //         value.substring(
    //             value.lastIndexOf("/") + 1,
    //             value.indexOf(".ts") != -1
    //                 ? (value.indexOf(".ts") + 3)
    //                 : (value.indexOf(".key") + 4));
    //     return downloadItem(value, savePath, index, taskInfo["id"],
    //         taskInfo["tsLists"].length, box);
    //   }).toList();
    // }

    // // 开始批量下载
    // int taskNum;
    // List tasks;
    // Future.wait(taskList())
    //     .then((value) => {
    //           // 存储完成后的下载任务信息
    //           tasks = box.get('download_video_tasks') ?? [],
    //           taskNum = tasks.indexWhere((e) => e["id"] == taskInfo["id"]),
    //           tasks[taskNum]["progress"] = 1,
    //           tasks[taskNum]["downloading"] = false,
    //           box.put("download_video_tasks", tasks),
    //           // 下载完成，开始下一个任务
    //           downloadTasks.removeAt(0),
    //           startNext()
    //         })
    //     .catchError((err) {
    //   // 下载失败，开始下个任务
    //   tasks = box.get('download_video_tasks') ?? [];
    //   taskNum = tasks.indexWhere((e) => e["id"] == taskInfo["id"]);
    //   tasks[taskNum]["downloading"] = false;
    //   box.put("download_video_tasks", tasks);
    //   downloadTasks.removeAt(0);
    //   startNext();
    //   EventBus().emit('DOWNLOADVIDEO_PROGRESS',
    //       {"id": taskInfo["id"], "downloading": false, "downloadError": true});
    // });

    int index = 0;
    int taskNum;
    List tasks;
    Future start() async {
      // 删除任务中断下载
      if (currentRemove) {
        return;
      }
      try {
        String savePath =
            "$saveDirectory/${tsLists[index].substring(tsLists[index].lastIndexOf("/") + 1, tsLists[index].contains(".ts") ? (tsLists[index].indexOf(".ts") + 3) : (tsLists[index].indexOf(".key") + 4))}";
        index = await downloadItem(tsLists[index], savePath, index,
            taskInfo['id'], taskInfo['tsLists'].length);
        if (currentRemove) {
          return;
        }
        if (index >= tsLists.length - 1) {
          // 完成
          // 存储完成后的下载任务信息
          tasks = await cache.readDownloadVideoTasks();
          taskNum = tasks.indexWhere((e) => e['id'] == taskInfo['id']);
          tasks[taskNum]['progress'] = 1;
          tasks[taskNum]['downloading'] = false;
          await cache.upsertDownloadVideoTasks(tasks: tasks);
          // 下载完成，开始下一个任务
          downloadTasks.removeAt(0);
          startNext();
        } else {
          index++;
          start();
        }
      } catch (e) {
        // 下载失败，开始下个任务
        tasks = await cache.readDownloadVideoTasks();
        taskNum = tasks.indexWhere((e) => e['id'] == taskInfo['id']);
        tasks[taskNum]['downloading'] = false;
        await cache.upsertDownloadVideoTasks(tasks: tasks);
        downloadTasks.removeAt(0);
        startNext();

        final progressMap = downloadVideoProgress.value;
        final Map data = progressMap[taskInfo['id']] ?? {};
        data['downloading'] = false;
        data['downloadError'] = true;
        progressMap[taskInfo['id']] = {...data};
        downloadVideoProgress.value = {...progressMap};
      }
    }

    start();
  }

// 单个下载方法
  Future<int> downloadItem(String urlPath, String savePath, int index,
      String id, int tsTotal) async {
    Future<int> start() async {
      if (currentRemove) {
        return index;
      }
      try {
        await dio.download(urlPath, savePath,
            onReceiveProgress: (int count, int total) async {
          if (count >= total) {
            // 储存下载进度
            finishCount++;
            List tasks = await cache.readDownloadVideoTasks();
            int taskNum = tasks.indexWhere((e) => e['id'] == id);
            tasks[taskNum]['progress'] = finishCount / tsTotal;
            tasks[taskNum]['downloading'] = true;
            tasks[taskNum]['tsListsFinished'].add(urlPath);
            await cache.upsertDownloadVideoTasks(tasks: tasks);
            // LogUtil.d("完成单个任务id---------${id}");
            // 发送进度数据
            final progressMap = downloadVideoProgress.value;
            final Map data = progressMap[id] ?? {};
            data['progress'] = finishCount / tsTotal;
            data['downloading'] = true;
            data['downloadError'] = false;
            progressMap[id] = {...data};
            downloadVideoProgress.value = {...progressMap};
          }
        });
        return index;
      } catch (e) {
        return start();
      }
    }

    int a = await start();
    return a;
  }
}
