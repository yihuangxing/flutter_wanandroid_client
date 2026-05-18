import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_wanandroid_client/api/api_service.dart';
import 'package:flutter_wanandroid_client/base/base_controller.dart';
import 'package:flutter_wanandroid_client/model/banner_info.dart';
import 'package:flutter_wanandroid_client/model/home_article.dart';
import 'package:flutter_wanandroid_client/utils/toast_util.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class HomeController extends BaseController {
  /// 滚动控制器
  final ScrollController scrollController = ScrollController();

  /// banner列表
  RxList<BannerInfo> bannerList = <BannerInfo>[].obs;

  /// 首页文章列表
  RxList<HomeArticleInfo> homeArticleList = <HomeArticleInfo>[].obs;

  /// 顶部栏透明度
  RxDouble opacity = 0.0.obs;

  /// 刷新控制器
  final EasyRefreshController easyRefreshController = EasyRefreshController(controlFinishLoad: true, controlFinishRefresh: true);

  //是否加载成功
  RxBool isLoading = true.obs;

  //文案内容
  RxString loadFailedText = "加载失败".obs;

  @override
  Future<void> loadData() async {
    await getBannerList();
  }

  /// 监听滚动事件
  void _scrollListener() {
    // 计算透明度，滚动距离超过100时完全不透明
    double newOpacity = scrollController.offset / 100;
    if (newOpacity > 1.0) newOpacity = 1.0;
    if (newOpacity < 0.0) newOpacity = 0.0;
    if (opacity.value != newOpacity) {
      opacity.value = newOpacity;
    }
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      _scrollListener();
    });
  }

  /// 获取banner列表
  Future<void> getBannerList() async {
    try {
      final result = await ApiService().getBannerList();
      if (result.isSuccess) {
        bannerList.value = result.data ?? [];
      }
    } catch (e) {
      // 显示toast
      ToastUtil.show(e.toString());
      // 刷新完成
      easyRefreshController.finishRefresh();
      // 加载完成
      easyRefreshController.finishLoad();
    }
  }

  /// 获取首页文章列表
  Future<void> getHomeArticleList() async {
    try {
      final result = await ApiService().getHomeArticleList();
      if (result.isSuccess) {
        homeArticleList.value = result.data?.datas ?? [];
        // 刷新完成
        easyRefreshController.finishRefresh();
        // 加载完成
        easyRefreshController.finishLoad();
        isLoading.value = true;
        loadFailedText.value = "加载成功";
      }
    } catch (e) {
      // 显示toast
      ToastUtil.show(e.toString());
      // 刷新完成
      easyRefreshController.finishRefresh();
      // 加载完成
      easyRefreshController.finishLoad();
      isLoading.value = false;
      loadFailedText.value = e.toString();
      rethrow;
    }
  }

  @override
  void onReady() async {
    await getHomeArticleList();
    await getBannerList();
  }
}
