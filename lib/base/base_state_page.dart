import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/base/base_controller.dart';
import 'package:flutter_wanandroid_client/widget/loading_empty.dart';
import 'package:flutter_wanandroid_client/widget/loading_error_widget.dart';
import 'package:flutter_wanandroid_client/widget/loading_widget.dart';
import 'package:get/get.dart';

/// 基础状态页面
/// D: 数据类型
/// C: 控制器类型（必须是 BaseController 的子类）
///  GetView 进一步简化，它内部已经帮我们处理了 Get.find() 来查找控制器，我们只需要在 build 方法中使用 controller 即可。
/// 该类是一个抽象类，用于定义基础的状态页面结构。
/// 它包含了成功界面、加载界面、错误界面和空数据界面的构建方法。
/// 子类需要实现 buildSuccessContent 方法，根据数据类型构建成功界面。
abstract class BaseStatePage<D, C extends BaseController<D>> extends GetView<C> {
  const BaseStatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar(), body: _buildBody());
  }

  Widget _buildBody() {
    // 完整的状态管理
    return controller.obx(
      (data) => _buildContent(data),
      onLoading: buildLoading(),
      onError: (error) => buildError(error ?? '未知错误'),
      onEmpty: buildEmpty(),
    );
  }

  Widget _buildContent([D? data]) {
    if (data == null || (data is List && data.isEmpty)) {
      return buildEmpty();
    }
    return buildSuccessContent(data);
  }

  /// 自定义 AppBar（可选）
  PreferredSizeWidget? buildAppBar() => null;

  /// 构建成功界面（必须实现）
  Widget buildSuccessContent(D data);

  /// 构建加载界面（可选覆写）
  Widget buildLoading() => const Center(child: LoadingWidget(backgroundColor: Colors.transparent));

  /// 构建错误界面（可选覆写）
  Widget buildError(String error) => LoadingErrorWidget(error: error, retry: controller.retry);

  /// 构建空数据界面（可选覆写）
  Widget buildEmpty() => LoadingEmpty();
}
