
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' as fd;
import '../../crypto.dart';

class AutoEncryptAndDecryptInterceptor extends Interceptor {
  const AutoEncryptAndDecryptInterceptor(this._appInfo);

  final Map _appInfo;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final Map data = {..._appInfo};

    if (options.data != null) {
      data.addAll(options.data);
    }
    options.data = PlatformAwareCrypto.encryptReqParams(data);

    return super.onRequest(options, handler);
  }

  @override
  onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.data case final Map data when data['data'] != null) {
      response.data =
          await fd.compute(PlatformAwareCrypto.decryptResData, response.data);
      // response.data = await PlatformAwareCrypto.decryptResData(response.data);
    }

    // logger.i(response.data);

    return super.onResponse(response, handler);
  }
}
