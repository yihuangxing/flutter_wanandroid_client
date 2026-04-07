// ignore_for_file: library_private_types_in_public_api
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/api/api_service.dart';
import 'package:flutter_wanandroid_client/model/banner_info.dart';
import 'package:flutter_wanandroid_client/model/home_article.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:flutter_wanandroid_client/utils/string_util.dart';

import '../routes/routes.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with AutomaticKeepAliveClientMixin<HomeWidget> {
  /// 刷新控制器
  final EasyRefreshController _easyRefreshController = EasyRefreshController(controlFinishLoad: true, controlFinishRefresh: true);

  /// 滚动控制器
  final ScrollController _scrollController = ScrollController();

  /// 顶部栏透明度
  double _opacity = 0.0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // 初始化banner列表
    getBannerList();
    // 初始化首页文章列表
    getHomeArticleList();
    // 监听滚动事件
    _scrollController.addListener(() {
      // 计算透明度，滚动距离超过100时完全不透明
      double newOpacity = _scrollController.offset / 100;
      if (newOpacity > 1.0) newOpacity = 1.0;
      if (newOpacity < 0.0) newOpacity = 0.0;

      if (_opacity != newOpacity) {
        setState(() {
          _opacity = newOpacity;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// banner列表
  List<BannerInfo> bannerList = [];

  /// 当前选中的banner索引
  int currentIndex = 0;

  /// 获取banner列表
  Future<void> getBannerList() async {
    try {
      final result = await ApiService().getBannerList();
      if (result.isSuccess) {
        setState(() {
          bannerList = result.data ?? [];
        });
      }
    } catch (e) {
      // 显示toast
      debugPrint("banner列表获取失败: $e");
    }
  }

  /// 首页文章列表
  List<HomeArticleInfo> homeArticleList = [];

  /// 获取首页文章列表
  Future<void> getHomeArticleList() async {
    try {
      final result = await ApiService().getHomeArticleList();
      if (result.isSuccess) {
        setState(() {
          homeArticleList = result.data?.datas ?? [];
        });
        // 刷新完成
        _easyRefreshController.finishRefresh();
        // 加载完成
        _easyRefreshController.finishLoad();
      }
    } catch (e) {
      // 显示toast
      debugPrint("首页文章列表获取失败: $e");
    }
  }

  /// 指示器列表
  Widget _indicatorList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        bannerList.length,
        (index) => Container(
          width: 20,
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: currentIndex == index ? Colors.red : Colors.black.withValues(alpha: 0.5),
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
            items: bannerList
                .map((e) => Image.network(e.imagePath, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Text('加载失败')))
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
        itemCount: homeArticleList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final article = homeArticleList[index];
          return InkWell(
            onTap: () {
              // 跳转到webview页面
              RouteUtils.to(Routes.webview, arguments: {"link": article.link, "title": article.title});
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
                        Text('${article.superChapterName}/${article.chapterName}', style: const TextStyle(fontSize: 12, color: Colors.blue)),
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh.builder(
      controller: _easyRefreshController,
      refreshOnStart: true,
      onRefresh: () async {
        await getHomeArticleList();
      },
      childBuilder: (context, physics) {
        return Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              physics: physics,
              slivers: [
                // banner列表
                _bannerList(),
                SliverToBoxAdapter(child: const SizedBox(height: 12)),
                // 首页文章列表
                _homeArticleList(),

                // 底部文案：“我是有底线的~"
                if (homeArticleList.isNotEmpty)
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
            Container(
              padding: const EdgeInsets.only(top: 45, left: 16),
              width: double.infinity,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: _opacity),
                boxShadow: _opacity > 0.5 ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 5, offset: const Offset(0, 2))] : [],
              ),
              child: Text(
                'WanAndroid',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87.withValues(alpha: _opacity),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
