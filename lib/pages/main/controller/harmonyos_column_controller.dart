import 'package:flutter_wanandroid_client/api/api_service.dart';
import 'package:flutter_wanandroid_client/base/base_controller.dart';
import 'package:flutter_wanandroid_client/http/base_result.dart';
import 'package:flutter_wanandroid_client/model/harmony_column_info.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';


/// 鸿蒙专栏导航界面控制器
class HarmonyosColumnController extends BaseController<BaseResult<HarmonyosColumn>> {
  /// 当前选中的标签
  /// 0：鸿蒙常用工具
  /// 1：鸿蒙常用链接
  /// 2：鸿蒙必备开源源码
  RxInt currentIndex = 0.obs;
  //get方法
  int get currentIndexValue => currentIndex.value;
  //set方法
  set currentIndexValue(int value) => currentIndex.value = value;

  //标签栏
  RxList<String> tabList = <String>[].obs;

  @override
  Future<void> loadData() async {
    await getHarmonyosColumnList();
  }

  /// 获取鸿蒙专栏列表
  Future<void> getHarmonyosColumnList() async {
    try {
      final result = await ApiService().getHarmonyosColumnList();
      tabList.add(result.data?.tools.name ?? "");
      tabList.add(result.data?.links.name ?? "");
      tabList.add(result.data?.open_sources.name ?? "");
      //延时1秒
      await Future.delayed(const Duration(seconds: 1));
      setSuccess(result);
    } catch (e) {
      setError("获取失败");
    }
  }
}
