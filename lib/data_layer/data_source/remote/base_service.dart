import 'package:dio/dio.dart';

import '../../../domain/exception.dart';
import '../../../domain/type_def.dart';
import 'dart:developer' as developer;

abstract class BaseService {
  BaseService(this._dio);

  final Dio _dio;

  String get service;

  AsyncJson post(String path, {Object? data}) async {
    final result = (await _dio.post('/api/$service$path', data: data)).data;
    if (result == null) {
      throw ResponseNullException();
    }
    //打印返回数据
    developer.log('RequstPath: ${_dio.options.baseUrl}/api/$service$path, params: $data, \nResult: $result');
    return result;  }
}
