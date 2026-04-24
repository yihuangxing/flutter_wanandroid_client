import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/api/api_service.dart';
import 'package:flutter_wanandroid_client/base/base_controller.dart';
import 'package:flutter_wanandroid_client/model/project_menu_info.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';

/// 项目分类控制器
class ProjectMenuController extends BaseController<List<ProductMenuInfo>> with GetTickerProviderStateMixin {


  TabController? tabController;



  @override
  Future<void> loadData() async {
    await getProjectMenuList();
  }

  /// 获取项目分类列表
  Future<void> getProjectMenuList() async {
    try {
      final result = await ApiService().getProjectMenuList();
      if (result.isSuccess) {
        // 初始化tabController
        tabController = TabController(vsync: this, length: result.data?.length ?? 0);
        setSuccess(result.data ?? []);
      }
    } catch (e) {
      setError(e.toString());
    }
  }
}
