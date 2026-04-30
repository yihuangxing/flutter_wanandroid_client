import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/pages/main/controller/home_controller.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:flutter_wanandroid_client/utils/string_util.dart';
import 'package:flutter_wanandroid_client/widget/loading_error_widget.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../routes/routes.dart';

/// 首页组件
class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with AutomaticKeepAliveClientMixin<HomeWidget> {
  /// 首页控制器
  final HomeController _homeController = Get.find<HomeController>();

  /// 当前选中的banner索引
  int currentIndex = 0;

  @override
  bool get wantKeepAlive => true;

  /// 指示器列表
  Widget _indicatorList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _homeController.bannerList.length,
        (index) => Container(
          width: 20,
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: currentIndex == index ? Color(0xFF0077f1) : Colors.black.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  /// banner列表
  Widget _bannerList() {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          CarouselSlider(
            items: _homeController.bannerList
                .map(
                  (e) => Image.network(
                    e.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Text('加载失败'),
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: 210,
              autoPlay: true,
              aspectRatio: 2.0,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
          Positioned(bottom: 10, left: 0, right: 0, child: _indicatorList()),
        ],
      ),
    );
  }

  /// 首页文章列表
  Widget _homeArticleList() {
    return SliverToBoxAdapter(
      child: ListView.builder(
        // 移除默认的ListView padding
        padding: EdgeInsets.zero,
        itemCount: _homeController.homeArticleList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final article = _homeController.homeArticleList[index];
          return InkWell(
            onTap: () {
              // 跳转到webview页面
              RouteUtils.to(
                Routes.webview,
                arguments: {"link": article.link, "title": article.title, "originId": article.id, "collect": article.collect},
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 文章标题
                    Text(
                      StringUtil.removeMdash(article.title),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // 文章描述
                    if (article.desc.isNotEmpty)
                      Text(
                        StringUtil.removeMdash(article.desc),
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (article.desc.isNotEmpty) const SizedBox(height: 12),
                    // 文章信息：分类和时间
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 分类信息
                        Text(
                          '${article.superChapterName}/${article.chapterName}',
                          style: const TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                        // 发布时间
                        Text(article.niceDate, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 加载失败
  Widget _loadFailed() {
    return Obx(() {
      return LoadingErrorWidget(
        error: _homeController.loadFailedText.value,
        retry: () async {
          _homeController.onReady();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      if (_homeController.isLoading.value) {
        return EasyRefresh.builder(
          controller: _homeController.easyRefreshController,
          refreshOnStart: true,
          onRefresh: () async {
            await _homeController.getHomeArticleList();
          },
          childBuilder: (context, physics) {
            return Stack(
              children: [
                CustomScrollView(
                  controller: _homeController.scrollController,
                  physics: physics,
                  slivers: [
                    // banner列表
                    _bannerList(),
                    SliverToBoxAdapter(child: const SizedBox(height: 12)),
                    // 首页文章列表
                    _homeArticleList(),

                    // 底部文案：“我是有底线的~"
                    if (_homeController.homeArticleList.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Center(
                            child: Text('我是有底线的~', style: TextStyle(fontSize: 14, color: Colors.grey)),
                          ),
                        ),
                      ),
                  ],
                ),

                // 顶部栏区域 实现滑动渐变，从透明到不透明
                Obx(() {
                  return Container(
                    padding: const EdgeInsets.only(top: 45, left: 16),
                    width: double.infinity,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: _homeController.opacity.value),
                      boxShadow: _homeController.opacity.value > 0.5
                          ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 5, offset: const Offset(0, 2))]
                          : [],
                    ),
                    child: Text(
                      'WanAndroid',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87.withValues(alpha: _homeController.opacity.value),
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        );
      } else {
        return _loadFailed();
      }
    });
  }
}
