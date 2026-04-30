import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/model/user_info.dart';
import 'package:flutter_wanandroid_client/pages/login/controller/user_controller.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:flutter_wanandroid_client/utils/storage_util.dart';
import 'package:flutter_wanandroid_client/utils/toast_util.dart';
import 'package:get/get.dart';

/// 退出登录弹窗组件
///
/// 功能特性：
/// 1. 使用 Get 框架自带的对话框功能
/// 2. 支持自定义提示信息
/// 3. 完整的退出登录逻辑处理
/// 4. 适配不同屏幕尺寸
/// 5. 与应用整体 UI 风格一致
class LoginOutDialog {
  /// 显示退出登录确认弹窗
  ///
  /// [title] - 弹窗标题，默认为 '退出登录'
  /// [content] - 提示内容，默认为 '确定要退出登录吗？'
  /// [confirmText] - 确认按钮文本，默认为 '确认退出'
  /// [cancelText] - 取消按钮文本，默认为 '取消'
  /// [onConfirm] - 确认后的回调，默认为执行退出登录逻辑
  static Future<void> show({
    String title = '退出登录',
    String content = '确定要退出登录吗？',
    String confirmText = '确认退出',
    String cancelText = '取消',
    Function()? onConfirm,
  }) async {
    await Get.dialog(
      _buildDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm ?? _defaultLogout,
      ),
      barrierDismissible: false,
    );
  }

  /// 构建对话框
  static Widget _buildDialog({
    required String title,
    required String content,
    required String confirmText,
    required String cancelText,
    required Function() onConfirm,
  }) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            // 提示内容
            Text(
              content,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 按钮区域
            Row(
              children: [
                // 取消按钮
                Expanded(
                  child: _buildButton(
                    text: cancelText,
                    isPrimary: false,
                    onTap: () {
                      RouteUtils.back();
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // 确认按钮
                Expanded(
                  child: _buildButton(
                    text: confirmText,
                    isPrimary: true,
                    onTap: () {
                      RouteUtils.back();
                      onConfirm();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建按钮
  static Widget _buildButton({required String text, required bool isPrimary, required Function() onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.red : Colors.grey.shade100,
        foregroundColor: isPrimary ? Colors.white : Colors.black87,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        minimumSize: const Size(double.infinity, 44),
        elevation: 0,
        side: isPrimary ? null : BorderSide(color: Colors.grey.shade300),
      ),
      child: Text(text, style: TextStyle(fontSize: 16, fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal)),
    );
  }

  /// 默认的退出登录逻辑
  static Future<void> _defaultLogout() async {
    try {
      // 获取 UserController 实例
      final userController = Get.find<UserController>();

      // 清空用户信息
      userController.userInfo = UserInfo();

      // 清空本地存储
      await StorageUtil.clear();

      // 显示退出成功提示
      ToastUtil.show('退出登录成功');
    } catch (e) {
      // 处理错误
      ToastUtil.show('退出登录失败：${e.toString()}');
    }
  }
}
