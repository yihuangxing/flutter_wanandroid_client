import 'dart:core';

import 'package:flutter_wanandroid_client/http/base_result.dart';

/// 缓存项
class CacheItem {
  final dynamic data;
  final int timestamp;
  final String key;

  CacheItem(this.key, this.data, this.timestamp);
}

/// 网络缓存管理器
class NetworkCache {
  /// 单例实例
  static final NetworkCache _instance = NetworkCache._internal();
  factory NetworkCache() => _instance;

  /// 缓存存储
  final Map<String, CacheItem> _cache = {};

  /// 缓存键列表（用于维护缓存顺序）
  final List<String> _cacheKeys = [];

  /// 最大缓存数量
  int maxCacheCount = 100;

  /// 缓存过期时间（毫秒）
  int cacheExpiryTime = 5 * 60 * 1000; // 默认5分钟

  /// 内部构造函数
  NetworkCache._internal();

  /// 生成缓存键
  String generateCacheKey(String path, Map<String, dynamic>? queryParameters) {
    String key = path;
    if (queryParameters != null && queryParameters.isNotEmpty) {
      final sortedKeys = queryParameters.keys.toList()..sort();
      final paramsString = sortedKeys.map((k) => '$k=${queryParameters[k]}').join('&');
      key = '$path?$paramsString';
    }
    return key;
  }

  /// 检查缓存是否有效
  bool isCacheValid(CacheItem item) {
    return DateTime.now().millisecondsSinceEpoch - item.timestamp < cacheExpiryTime;
  }

  /// 获取缓存
  BaseResult<dynamic>? getCache(String key) {
    final item = _cache[key];
    if (item == null) return null;

    if (!isCacheValid(item)) {
      removeCache(key);
      return null;
    }

    // 将缓存项移到列表末尾（最近使用）
    _cacheKeys.remove(key);
    _cacheKeys.add(key);

    return item.data;
  }

  /// 设置缓存
  void setCache(String key, BaseResult<dynamic> data) {
    // 检查缓存数量是否超过限制
    if (_cache.length >= maxCacheCount) {
      // 移除最早的缓存
      final oldestKey = _cacheKeys.first;
      removeCache(oldestKey);
    }

    // 添加新缓存
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _cache[key] = CacheItem(key, data, timestamp);

    // 更新缓存键顺序
    _cacheKeys.remove(key);
    _cacheKeys.add(key);
  }

  /// 移除缓存
  void removeCache(String key) {
    _cache.remove(key);
    _cacheKeys.remove(key);
  }

  /// 清空所有缓存
  void clearCache() {
    _cache.clear();
    _cacheKeys.clear();
  }

  /// 获取缓存数量
  int get cacheCount => _cache.length;
}
