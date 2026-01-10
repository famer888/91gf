import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:jygf/domain/remote_domain/domains/ai.dart';
import 'package:jygf/domain/remote_domain/domains/asmr.dart';
import 'package:jygf/domain/remote_domain/domains/live.dart';
import 'package:jygf/domain/remote_domain/domains/rank.dart';
import 'package:jygf/domain/remote_domain/domains/ainovel.dart';
import 'package:jygf/domain/remote_domain/domains/aiaudio.dart';

import '../enum.dart';
import '../type_def.dart';
import 'domains/account.dart';
import 'domains/community.dart';
import 'domains/dynamic.dart';
import 'domains/element.dart';
import 'domains/home.dart';
import 'domains/message.dart';
import 'domains/mv.dart';
import 'domains/order.dart';
import 'domains/privilege.dart';
import 'domains/proxy.dart';
import 'domains/search.dart';
import 'domains/seed.dart';
import 'domains/sign.dart';
import 'domains/user.dart';
import 'domains/withdraw.dart';
import 'domains/original.dart';
import 'domains/aimagic.dart';
import 'domains/aidraw.dart';

abstract class RemoteDomain
    implements
        AccountDomain,
        CommunityDomain,
        DynamicDomain,
        ElementDomain,
        HomeDomain,
        OrderDomain,
        ProxyDomain,
        SeedDomain,
        SignDomain,
        UserDomain,
        WithdrawDomain,
        SearchDomain,
        MvDomain,
        MessageDomain,
        PrivilegeDomain,
        OriginalDomain,
        LiveDomain,
        AIDomain,
        AIMagicDomain,
        AIDrawDomain,
        AIAudioDomain,
        AINovelDomain,
        RankDomain,
        ASMRDomain {
  Stream<MyTokenStatus?> get tokenStatusStream;
  void initLine({
    Function? success,
    Function? failed,
    Function(List<String>)? lines,
  });
  void setBaseURL(String url);
  void setReportTraceId(String id);

  String getOAuthId();
  String getOAuthType();

  AsyncJson uploadImageBytes({
    required String baseUrl,
    required String key,
    required Uint8List bytes,
    String position = 'head',
    String? id,
    CancelToken? cancelToken,
    ProgressCallback? progressCallback,
  });

  AsyncJson uploadImage({
    required String baseUrl,
    required String key,
    required XFile xFile,
    String? id,
    String position = 'head',
    CancelToken? cancelToken,
    ProgressCallback? progressCallback,
  });

  /// 视频上传
  AsyncJson uploadVideo({
    required BuildContext context,
    required XFile xFile,
    CancelToken? cancelToken,
    ProgressCallback? progressCallback,
  });

  /// 下载apk
  Future<Response> downloadApk({
    required String urlPath,
    required String savePath,
    ProgressCallback? onReceiveProgress,
  });
}
