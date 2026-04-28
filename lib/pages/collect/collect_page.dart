import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/base/base_state_page.dart';
import 'package:flutter_wanandroid_client/model/home_article.dart';
import 'package:flutter_wanandroid_client/pages/collect/controller/collect_controller.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:flutter_wanandroid_client/routes/routes.dart';
import 'package:flutter_wanandroid_client/utils/bottom_sheet_util.dart';
import 'package:flutter_wanandroid_client/utils/string_util.dart';

class CollectPage extends BaseStatePage<List<HomeArticleInfo>, CollectController> {
  const CollectPage({super.key});

  @override
  PreferredSizeWidget? buildAppBar() {
    return AppBar(title: const Text("我的收藏"));
  }

  @override
  Widget buildSuccessContent(List<HomeArticleInfo> articleList) {
    return EasyRefresh.builder(
      controller: controller.easyRefreshController,
      onRefresh: () async {
        await controller.getCollectArticleList();
      },
      childBuilder: (context, physics) => _homeArticleList(articleList, physics, controller),
    );
  }
}

/// 首页文章列表
Widget _homeArticleList(List<HomeArticleInfo> articleList, ScrollPhysics physics, CollectController controller) {
  return ListView.builder(
    // 移除默认的ListView padding
    padding: EdgeInsets.zero,
    itemCount: articleList.length,
    shrinkWrap: false,
    physics: physics,
    itemBuilder: (context, index) {
      final article = articleList[index];
      return InkWell(
        onTap: () {
          // 跳转到webview页面
          RouteUtils.to(
            Routes.webview,
            arguments: {"link": article.link, "title": article.title, "originId": article.id, "collect": article.collect},
          );
        },

        onLongPress: () {
          //长按弹出底部菜单
          BottomSheetUtil.showByGet(
            items: [
              BottomSheetItem(title: '取消收藏', color: Colors.red.shade600),
              BottomSheetItem(title: '取消', color: Colors.grey.shade600),
            ],
            onItemTap: (idx) {
              if (idx == 0) {
                // 取消收藏
                Map<String,dynamic> prams ={};
                prams["originId"] = article.originId;
                controller.cancelCollect(article.id, prams);
              }
            },
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
  );
}
