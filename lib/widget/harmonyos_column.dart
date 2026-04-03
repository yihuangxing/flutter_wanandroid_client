import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/api/api_service.dart';
import 'package:flutter_wanandroid_client/http/base_result.dart';
import 'package:flutter_wanandroid_client/model/harmony_column_info.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:flutter_wanandroid_client/routes/routes.dart';
import 'package:flutter_wanandroid_client/utils/string_util.dart';
import 'package:flutter_wanandroid_client/widget/loading_widget.dart';

class HarmonyosColumnWidget extends StatefulWidget {
  const HarmonyosColumnWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HarmonyosColumnWidgetState createState() => _HarmonyosColumnWidgetState();
}

class _HarmonyosColumnWidgetState extends State<HarmonyosColumnWidget> with AutomaticKeepAliveClientMixin<HarmonyosColumnWidget> {
  @override
  bool get wantKeepAlive => true;

  //当前选中下标
  int _currentIndex = 0;

  // 缓存数据
  Future<BaseResult<HarmonyosColumn>>? _harmonyosColumnFuture;

  @override
  void initState() {
    super.initState();
    // 初始化数据
    _harmonyosColumnFuture = getHarmonyosColumnList();
  }

  /// 获取鸿蒙专栏列表
  Future<BaseResult<HarmonyosColumn>> getHarmonyosColumnList() async {
    try {
      final result = await ApiService().getHarmonyosColumnList();
      //延时1秒
      await Future.delayed(const Duration(seconds: 1));
      return result;
    } catch (e) {
      debugPrint("获取鸿蒙专栏列表失败=====: $e");
      return BaseResult(errorCode: -1, errorMsg: "获取失败", data: null);
    }
  }

  /// 文章列表
  Widget _articleList(HarmonyosColumnTools tools, HarmonyosColumnLinks links, HarmonyosColumnOpenSources open_sources) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        itemCount: _currentIndex == 0
            ? tools.articleList.length
            : _currentIndex == 1
            ? links.articleList.length
            : open_sources.articleList.length,
        itemBuilder: (context, index) {
          return _articleItem(
            _currentIndex == 0
                ? tools.articleList[index]
                : _currentIndex == 1
                ? links.articleList[index]
                : open_sources.articleList[index],
          );
        },
      ),
    );
  }

  /// 文章项
  Widget _articleItem(HarmonyosColumnArticle article) {
    return InkWell(
      onTap: () {
        // 跳转到webview页面
        RouteUtils.to(Routes.webview, arguments: {"link": article.link, "title": article.chapterName});
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 文章作者
              Text(
                StringUtil.removeMdash(article.author),
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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // 避开安全区
    return SafeArea(
      child: FutureBuilder<BaseResult<HarmonyosColumn>>(
        future: _harmonyosColumnFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 显示加载指示器
            return const Center(child: LoadingWidget(backgroundColor: Colors.transparent));
          } else if (snapshot.hasError || !snapshot.data!.isSuccess) {
            // 显示错误信息
            return const Center(child: Text('加载失败，请重试'));
          } else {
            // 数据加载成功
            final data = snapshot.data!.data!;
            final tools = data.tools;
            final links = data.links;
            final open_sources = data.open_sources;

            return Column(
              children: [
                const SizedBox(height: 12),
                // 标签栏
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: _currentIndex == 0 ? Colors.red : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          StringUtil.removeHarmonyosDevPrefix(tools.name),
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: _currentIndex == 0 ? Colors.white : Colors.black87),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = 1;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: _currentIndex == 1 ? Colors.red : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          StringUtil.removeHarmonyosDevPrefix(links.name),
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: _currentIndex == 1 ? Colors.white : Colors.black87),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = 2;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: _currentIndex == 2 ? Colors.red : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          StringUtil.removeHarmonyosDevPrefix(open_sources.name),
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: _currentIndex == 2 ? Colors.white : Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                // 文章列表
                Expanded(child: _articleList(tools, links, open_sources)),
              ],
            );
          }
        },
      ),
    );
  }
}
