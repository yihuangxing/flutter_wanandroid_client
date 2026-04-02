import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RouteUtils {
 // 构造方法私有化
  RouteUtils._();

  // 跳转页面（带返回值）
  static Future<T?> to<T>(
    String route, {
    dynamic arguments,
    Map<String, String>? parameters,
    bool preventDuplicates = true,
    Transition? transition,
    Duration? duration,
  }) async {
    try {
      return await Get.toNamed<T>(route, arguments: arguments, parameters: parameters, preventDuplicates: preventDuplicates);
    } catch (e) {
      debugPrint('RouteUtils.to error: $e');
      return null;
    }
  }

  // 跳转并替换当前页面
  static Future<T?> off<T>(String route, {dynamic arguments, Map<String, String>? parameters, bool preventDuplicates = true}) async {
    try {
      return await Get.offNamed<T>(route, arguments: arguments, parameters: parameters, preventDuplicates: preventDuplicates);
    } catch (e) {
      debugPrint('RouteUtils.off error: $e');
      return null;
    }
  }

  // 跳转并清除所有页面
  static Future<T?> offAll<T>(String route, {dynamic arguments, Map<String, String>? parameters}) async {
    try {
      return await Get.offAllNamed<T>(route, arguments: arguments, parameters: parameters);
    } catch (e) {
      debugPrint('RouteUtils.offAll error: $e');
      return null;
    }
  }

  // 返回上一页
  static void back<T>({T? result}) {
    try {
      // 检查是否可以返回
      bool canPop = Get.key.currentState?.canPop() ?? false;
      if (canPop) {
        Get.back<T>(result: result);
      } else {
        debugPrint('RouteUtils.back: Cannot pop, no previous route');
      }
    } catch (e) {
      debugPrint('RouteUtils.back error: $e');
    }
  }

  // 返回到指定页面
  static void backUntil(String routeName) {
    try {
      Get.until((route) => route.settings.name == routeName);
    } catch (e) {
      debugPrint('RouteUtils.backUntil error: $e');
    }
  }

  // 返回到根页面
  static void backToRoot() {
    try {
      Get.until((route) => route.isFirst);
    } catch (e) {
      debugPrint('RouteUtils.backToRoot error: $e');
    }
  }

  // 弹出当前页面并跳转到新页面
  static Future<T?> popAndPush<T>(String route, {dynamic arguments, Map<String, String>? parameters}) async {
    try {
      return await Get.offNamed<T>(route, arguments: arguments, parameters: parameters);
    } catch (e) {
      debugPrint('RouteUtils.popAndPush error: $e');
      return null;
    }
  }

  // 获取路由参数
  static T? getArgument<T>() {
    try {
      return Get.arguments as T?;
    } catch (e) {
      debugPrint('RouteUtils.getArgument error: $e');
      return null;
    }
  }

  // 获取路由参数（带类型安全）
  static T? getParameter<T>(String key) {
    try {
      return Get.parameters[key] as T?;
    } catch (e) {
      debugPrint('RouteUtils.getParameter error: $e');
      return null;
    }
  }

  // 获取当前路由名称
  static String? getCurrentRoute() {
    try {
      return Get.currentRoute;
    } catch (e) {
      debugPrint('RouteUtils.getCurrentRoute error: $e');
      return null;
    }
  }

  // 获取当前路由堆栈长度
  static int getStackLength() {
    try {
      // 简化实现，返回 1 表示至少有一个页面
      return 1;
    } catch (e) {
      debugPrint('RouteUtils.getStackLength error: $e');
      return 0;
    }
  }

  // 检查是否可以返回
  static bool canPop() {
    try {
      return Get.key.currentState?.canPop() ?? false;
    } catch (e) {
      debugPrint('RouteUtils.canPop error: $e');
      return false;
    }
  }
}