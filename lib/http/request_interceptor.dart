import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'network_config.dart';

/// 请求拦截器
class RequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 添加默认请求头
    options.headers.addAll(NetworkConfig.defaultHeaders());
    _onRequest(options);
    handler.next(options);
  }

  /// 请求拦截处理
  void _onRequest(RequestOptions options) {
    if (NetworkConfig.enableLog) {
      debugPrint('\n=========================== 🔥🔥🔥请求开始🔥🔥🔥 ===========================');
      debugPrint('URL: ${options.uri}');
      debugPrint('Method: ${options.method}');
      debugPrint('Headers: ${options.headers}');
      if (options.data != null) {
        debugPrint('Data: ${options.data}');
      }
      if (options.queryParameters.isNotEmpty) {
        debugPrint('Params: ${options.queryParameters}');
      }
      debugPrint('=========================== 🔥🔥🔥请求结束🔥🔥🔥 ===========================\n');
    }
  }
}
