import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/base/base_controller.dart';
import 'package:flutter_wanandroid_client/widget/loading_widget.dart';
import 'package:get/get.dart';

/// 基础状态页面
/// D: 数据类型
/// C: 控制器类型（必须是 BaseController 的子类）
abstract class BaseStatePage<D, C extends BaseController<D>> extends GetView<C> {
  const BaseStatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: controller.obx(
        (data) {
          // 确保 data 不为空 且 不是空列表
          if (data == null || data is List && data.isEmpty) {
            return buildEmpty();
          }
          return buildSuccessContent(data);
        },
        onLoading: buildLoading(),
        onError: (error) => buildError(error ?? '未知错误'),
        onEmpty: buildEmpty(),
      ),
    );
  }

  /// 自定义 AppBar（可选）
  PreferredSizeWidget? buildAppBar() => null;

  /// 构建成功界面（必须实现）
  Widget buildSuccessContent(D data);

  /// 构建加载界面（可选覆写）
  Widget buildLoading() => const Center(child: LoadingWidget(backgroundColor: Colors.transparent));

  /// 构建错误界面（可选覆写）
  Widget buildError(String error) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 48, color: Colors.grey),
        const SizedBox(height: 16),
        Text('加载失败：$error'),
        const SizedBox(height: 16),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),

            //去掉默认阴影
            shadowColor: Colors.transparent,
          ),
          // ✅ 直接使用 BaseController 的 retry
          onPressed: () => controller.retry(),
          child: const Text('重试'),
        ),
      ],
    ),
  );

  /// 构建空数据界面（可选覆写）
  Widget buildEmpty() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox, size: 48, color: Colors.grey),
        SizedBox(height: 16),
        Text('暂无数据'),
      ],
    ),
  );
}
