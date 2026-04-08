import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'network_config.dart';

/// 响应拦截器
class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _onResponse(response);
    handler.next(response);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    _onError(error);
    handler.next(error);
  }

  /// 响应拦截处理
  void _onResponse(Response response) {
    if (NetworkConfig.enableLog) {
      debugPrint('\n=========================== 🔥🔥🔥响应开始🔥🔥🔥 ===========================');
      debugPrint('URL: ${response.requestOptions.uri}');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Data: ${response.data}');
      debugPrint('=========================== 🔥🔥🔥响应结束🔥🔥🔥 ===========================\n');
    }
  }

  /// 错误拦截处理
  void _onError(DioException error) {
    if (NetworkConfig.enableLog) {
      debugPrint('\n===== 🔥🔥🔥错误开始🔥🔥🔥 =====');
      debugPrint('URL: ${error.requestOptions.uri}');
      debugPrint('Error: ${error.message}');
      if (error.response != null) {
        debugPrint('Status Code: ${error.response?.statusCode}');
        debugPrint('Response: ${error.response?.data}');
      }
      debugPrint('===== 🔥🔥🔥错误结束🔥🔥🔥 =====\n');
    }
  }
}
