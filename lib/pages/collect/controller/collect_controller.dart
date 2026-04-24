import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_wanandroid_client/api/api_service.dart';
import 'package:flutter_wanandroid_client/base/base_controller.dart';
import 'package:flutter_wanandroid_client/model/home_article.dart';
import 'package:get/get.dart';

/// 收藏文章列表控制器
class CollectController extends BaseController<List<HomeArticleInfo>> {

  final EasyRefreshController easyRefreshController = EasyRefreshController(controlFinishRefresh: true, controlFinishLoad: true);

  @override
  Future<void> loadData() async {
    await getCollectArticleList();
  }

  /// 获取收藏文章列表
  Future<void> getCollectArticleList() async {
    try {
      final result = await ApiService().getCollectArticleList();
      if (result.isSuccess) {
        final data = result.data?.datas ?? [];
        if (data.isEmpty) {
          setEmpty(); // 数据为空
        } else {
          setSuccess(data); // 数据加载成功
        }
        easyRefreshController.finishRefresh(); // 刷新完成
        easyRefreshController.finishLoad(); // 加载完成
      }
    } catch (e) {
      // 设置错误状态
      setError(e.toString());
    }
  }

  @override
  void retry() {
    getCollectArticleList();
  }
}

class CollectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CollectController());
  }
}
