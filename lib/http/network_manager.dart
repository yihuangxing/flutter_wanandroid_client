import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'network_config.dart';
import 'base_result.dart';
import 'request_interceptor.dart';
import 'response_interceptor.dart';
import 'network_cache.dart';

/// 网络请求管理器
class NetworkManager {
  /// 单例实例
  static final NetworkManager _instance = NetworkManager._internal();
  factory NetworkManager() => _instance;

  /// Dio实例
  late Dio _dio;

  /// 缓存管理器
  final NetworkCache _cacheManager = NetworkCache();

  /// 请求队列
  final List<CancelToken> _cancelTokens = [];

  /// 内部构造函数
  NetworkManager._internal() {
    _initDio();
  }

  /// 初始化Dio
  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: NetworkConfig.baseUrl,
        connectTimeout: Duration(milliseconds: NetworkConfig.connectTimeout),
        receiveTimeout: Duration(milliseconds: NetworkConfig.receiveTimeout),
        sendTimeout: Duration(milliseconds: NetworkConfig.sendTimeout),
        headers: NetworkConfig.defaultHeaders(),
      ),
    );

    // 添加请求拦截器
    _dio.interceptors.add(RequestInterceptor());

    // 添加响应拦截器
    _dio.interceptors.add(ResponseInterceptor());

    //日志格式化工具类
    // _dio.interceptors.add(PrettyDioLogger(
    //     requestHeader: true,
    //     requestBody: true,
    //     responseBody: true,
    //     responseHeader: false,
    //     error: true,
    //     compact: true,
    // ));
  }

  /// 通用请求方法
  Future<BaseResult<dynamic>> _request(
    String path, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    String? contentType,
    bool useCache = true, // 是否使用缓存
    bool refreshCache = true, // 是否在后台刷新缓存
  }) async {
    try {
      // 生成缓存键
      final cacheKey = _cacheManager.generateCacheKey(path, queryParameters);

      // 检查缓存
      BaseResult<dynamic>? cachedResult;
      if (useCache) {
        cachedResult = _cacheManager.getCache(cacheKey);
        if (cachedResult != null) {
          debugPrint('使用缓存数据: $cacheKey');

          // 如果需要在后台刷新缓存，启动异步请求
          if (refreshCache) {
            _refreshCacheInBackground(path, method: method, data: data, queryParameters: queryParameters, headers: headers, cacheKey: cacheKey);
          }

          return cachedResult;
        }
      }

      // 缓存不存在或禁用缓存，直接请求网络
      return await _fetchFromNetwork(
        path,
        method: method,
        data: data,
        queryParameters: queryParameters,
        headers: headers,
        cancelToken: cancelToken,
        contentType: contentType,
        useCache: useCache,
        cacheKey: cacheKey,
      );
    } on DioException catch (e) {
      // 从队列中移除已完成的令牌
      _cancelTokens.removeWhere((token) => token.isCancelled);
      throw _handleError(e);
    }
  }

  /// 从网络获取数据
  Future<BaseResult<dynamic>> _fetchFromNetwork(
    String path, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    String? contentType,
    bool useCache = true,
    required String cacheKey,
  }) async {
    final options = Options(method: method, headers: headers, contentType: contentType);

    // 创建取消令牌
    final token = cancelToken ?? CancelToken();
    _cancelTokens.add(token);

    final response = await _dio.request(path, data: data, queryParameters: queryParameters, options: options, cancelToken: token);

    // 从队列中移除已完成的令牌
    _cancelTokens.remove(token);

    // 包装响应数据
    final result = BaseResult.fromMap(response.data);

    // 检查业务状态码
    // 更新缓存
    if (useCache && result.isSuccess) {
      _cacheManager.setCache(cacheKey, result);
      debugPrint('更新缓存: $cacheKey');
    }

    return result;
  }

  /// 在后台刷新缓存
  void _refreshCacheInBackground(
    String path, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required String cacheKey,
  }) async {
    try {
      debugPrint('后台刷新缓存: $cacheKey');
      final result = await _fetchFromNetwork(
        path,
        method: method,
        data: data,
        queryParameters: queryParameters,
        headers: headers,
        useCache: true,
        cacheKey: cacheKey,
      );
      debugPrint('后台刷新缓存完成: $cacheKey');
    } catch (e) {
      debugPrint('后台刷新缓存失败: $e');
    }
  }

  /// 处理错误
  dynamic _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkError('连接超时，请检查网络');
      case DioExceptionType.sendTimeout:
        return NetworkError('发送超时，请检查网络');
      case DioExceptionType.receiveTimeout:
        return NetworkError('接收超时，请检查网络');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 400:
            return NetworkError('请求参数错误');
          case 401:
            return NetworkError('未授权，请重新登录');
          case 403:
            return NetworkError('拒绝访问');
          case 404:
            return NetworkError('请求地址不存在');
          case 500:
            return NetworkError('服务器内部错误');
          default:
            return NetworkError('服务器错误，状态码: $statusCode');
        }
      case DioExceptionType.cancel:
        return NetworkError('请求已取消');
      case DioExceptionType.connectionError:
        return NetworkError('网络错误，请检查网络连接');
      default:
        return NetworkError('未知错误');
    }
  }

  /// GET请求
  Future<BaseResult<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    bool useCache = true, // 是否使用缓存
    bool refreshCache = true, // 是否在后台刷新缓存
  }) async {
    return _request(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      headers: headers,
      cancelToken: cancelToken,
      useCache: useCache,
      refreshCache: refreshCache,
    );
  }

  /// POST请求
  Future<BaseResult<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    String? contentType,
    bool useCache = false, // POST请求默认不使用缓存
    bool refreshCache = false, // POST请求默认不刷新缓存
  }) async {
    return _request(
      path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      cancelToken: cancelToken,
      contentType: contentType,
      useCache: useCache,
      refreshCache: refreshCache,
    );
  }

  /// PUT请求
  Future<BaseResult<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    bool useCache = false, // PUT请求默认不使用缓存
    bool refreshCache = false, // PUT请求默认不刷新缓存
  }) async {
    return _request(
      path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      cancelToken: cancelToken,
      useCache: useCache,
      refreshCache: refreshCache,
    );
  }

  /// DELETE请求
  Future<BaseResult<dynamic>> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    bool useCache = false, // DELETE请求默认不使用缓存
    bool refreshCache = false, // DELETE请求默认不刷新缓存
  }) async {
    return _request(
      path,
      method: 'DELETE',
      queryParameters: queryParameters,
      headers: headers,
      cancelToken: cancelToken,
      useCache: useCache,
      refreshCache: refreshCache,
    );
  }

  /// 上传文件
  Future<BaseResult<dynamic>> upload(
    String path, {
    required FormData data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final options = Options(method: 'POST', headers: headers);

      final token = cancelToken ?? CancelToken();
      _cancelTokens.add(token);

      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: token,
        onSendProgress: onSendProgress,
      );

      _cancelTokens.remove(token);

      // 包装响应数据
      final result = BaseResult.fromMap(response.data);

      // 检查业务状态码 - 不再抛出异常，由调用方处理
      return result;
    } on DioException catch (e) {
      _cancelTokens.removeWhere((token) => token.isCancelled);
      throw _handleError(e);
    }
  }

  /// 下载文件
  Future<dynamic> download(
    String url,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final options = Options(headers: headers);

      final token = cancelToken ?? CancelToken();
      _cancelTokens.add(token);

      final response = await _dio.download(
        url,
        savePath,
        queryParameters: queryParameters,
        options: options,
        cancelToken: token,
        onReceiveProgress: onReceiveProgress,
      );

      _cancelTokens.remove(token);
      return response.data;
    } on DioException catch (e) {
      _cancelTokens.removeWhere((token) => token.isCancelled);
      throw _handleError(e);
    }
  }

  /// 取消所有请求
  void cancelAll() {
    for (final token in _cancelTokens) {
      if (!token.isCancelled) {
        token.cancel('Canceled by user');
      }
    }
    _cancelTokens.clear();
  }

  /// 取消指定请求
  void cancel(CancelToken token) {
    if (!token.isCancelled) {
      token.cancel('Canceled by user');
    }
    _cancelTokens.remove(token);
  }

  /// 清空缓存
  void clearCache() {
    _cacheManager.clearCache();
    debugPrint('缓存已清空'); 
  }

  /// 获取缓存数量
  int get cacheCount => _cacheManager.cacheCount;

  /// 获取Dio实例（用于扩展）
  Dio get dio => _dio;
}

/// 网络错误类
class NetworkError implements Exception {
  final String message;
  NetworkError(this.message);
  @override
  String toString() => message;
}
