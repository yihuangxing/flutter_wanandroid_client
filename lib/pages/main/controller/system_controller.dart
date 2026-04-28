import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/api/api_service.dart';
import 'package:flutter_wanandroid_client/base/base_controller.dart';
import 'package:flutter_wanandroid_client/http/base_result.dart';
import 'package:flutter_wanandroid_client/model/system_tree_info.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

/// 体系导航界面控制器
class SystemController extends BaseController<BaseResult<List<SystemTreeInfo>>> {
  //   /// 滚动控制器
  final ScrollController scrollController = ScrollController();

  /// 顶部栏透明度
  RxDouble opacity = 0.0.obs;
  //   /// 颜色缓存，用于存储每个子项的颜色
  RxMap<dynamic, dynamic> colorCache = {}.obs;

  /// 获取颜色（缓存机制）
  Color getColor(String key) {
    if (!colorCache.containsKey(key)) {
      // 生成随机颜色并缓存
      colorCache[key] = Color(0xFF000000 + Random().nextInt(0xFFFFFF));
    }
    return colorCache[key]!;
  }

  /// 监听滚动事件
  void _scrollListener() {
    // 计算透明度，滚动距离超过100时完全不透明
    double newOpacity = scrollController.offset / 100;
    if (newOpacity > 1.0) newOpacity = 1.0;
    if (newOpacity < 0.0) newOpacity = 0.0;
    if (opacity.value != newOpacity) {
      opacity.value = newOpacity;
    }
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      _scrollListener();
    });
  }

  @override
  Future<void> loadData() async {
    await getSystemTreeList();
  }

  /// 获取体系列表
  Future<void> getSystemTreeList() async {
    try {
      final result = await ApiService().getSystemTreeList();
      if (result.isSuccess) {
        setSuccess(result);
      }
    } catch (e) {
      setError(e.toString());
    }
  }
}
