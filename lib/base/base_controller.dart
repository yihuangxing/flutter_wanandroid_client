import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

/// 基础控制器，状态自动管理 (StateMixin)
/// D: 数据类型
/// 该类是一个抽象类，用于定义基础的状态管理逻辑。
/// 它包含了加载数据、设置状态、重试方法等。
/// 子类需要实现 loadData 方法，根据数据类型加载数据。
/// 子类可以重写 setLoading、setSuccess、setError、setEmpty 方法，根据需要自定义状态管理逻辑。
abstract class BaseController<D> extends GetxController with StateMixin<D> {

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  /// 加载数据（子类必须实现）
  Future<void> loadData();

  /// 设置加载状态
  void setLoading() {
    change(null, status: RxStatus.loading());
  }

  /// 设置成功状态
  void setSuccess(D data) {
    change(data, status: RxStatus.success());
  }

  /// 设置错误状态
  void setError(String error) {
    change(null, status: RxStatus.error(error));
  }

  /// 设置空数据状态
  void setEmpty() {
    change(null, status: RxStatus.empty());
  }

  /// 重试方法（子类可以覆写）
  void retry() {
    loadData();
  }
}
