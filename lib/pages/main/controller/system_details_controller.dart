import 'package:flutter_wanandroid_client/api/api_service.dart';
import 'package:flutter_wanandroid_client/base/base_controller.dart';
import 'package:flutter_wanandroid_client/model/home_article.dart';
import 'package:flutter_wanandroid_client/model/system_tree_info.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

/// 体系详情控制器
class SystemDetailsController extends BaseController<List<HomeArticleInfo>> {



  @override
  Future<void> loadData() async {
    // 从路由参数中获取体系详情
    SystemTreeItem systemTreeItem = RouteUtils.getArgument() as SystemTreeItem;
    // 调用接口获取体系详情
    await getSystemTreeItem(systemTreeItem.id);
  }

  // 获取体系详情 (对应获取首页文章列表接口)
  Future<void> getSystemTreeItem(int cid) async {
    try {
      final result = await ApiService().getHomeArticleList(params: {'cid': cid});
      if (result.isSuccess) {
        setSuccess((result.data?.datas ?? []));
      }
    } catch (e) {
      setError(e.toString());
    }
  }
}

//绑定
class SystemDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SystemDetailsController());
  }
}
