import 'package:flutter_wanandroid_client/api/api_constant.dart';

/// 网络请求配置类
class NetworkConfig {
  /// 基础URL
  static const String baseUrl = ApiConstant.baseUrl;

  /// 连接超时时间（毫秒）

  static const int connectTimeout = 10000;
  /// 接收超时时间（毫秒）
  static const int receiveTimeout = 10000;

  /// 发送超时时间（毫秒）
  static const int sendTimeout = 10000;

  /// 是否启用日志
  static const bool enableLog = true;

  /// 默认请求头
  static Map<String, String> defaultHeaders() {
    return {
      'Content-Type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
      'User-Agent': 'Flutter-App',
    };
  }
}
