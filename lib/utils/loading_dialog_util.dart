import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/widget/loading_widget.dart';

/// 网络请求加载对话框工具类
class LoadingDialogUtil {
  /// 显示加载对话框
  /// [context] 上下文
  /// [backgroundColor] 背景颜色，默认为白色
  /// [barrierDismissible] 点击背景是否可以关闭，默认为false
  static void show(BuildContext context, {Color backgroundColor = Colors.white, bool barrierDismissible = false}) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black54,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => barrierDismissible,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: LoadingWidget(backgroundColor: backgroundColor)),
          ),
        );
      },
    );
  }

  /// 隐藏加载对话框
  /// [context] 上下文
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// 执行异步任务并显示加载对话框
  /// [context] 上下文
  /// [task] 异步任务
  /// [backgroundColor] 背景颜色，默认为白色
  /// [barrierDismissible] 点击背景是否可以关闭，默认为false
  /// 返回异步任务的结果
  static Future<T?> showDuring<T>(
    BuildContext context,
    Future<T> Function() task, {
    Color backgroundColor = Colors.white,
    bool barrierDismissible = false,
  }) async {
    show(context, backgroundColor: backgroundColor, barrierDismissible: barrierDismissible);
    try {
      final result = await task();
      return result;
    } finally {
      hide(context);
    }
  }
}
