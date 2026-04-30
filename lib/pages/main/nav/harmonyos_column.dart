import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/base/base_state_page.dart';
import 'package:flutter_wanandroid_client/http/base_result.dart';
import 'package:flutter_wanandroid_client/model/harmony_column_info.dart';
import 'package:flutter_wanandroid_client/pages/main/controller/harmonyos_column_controller.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:flutter_wanandroid_client/routes/routes.dart';
import 'package:flutter_wanandroid_client/utils/string_util.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

/// 鸿蒙专栏导航界面
class HarmonyosColumnWidget extends BaseStatePage<BaseResult<HarmonyosColumn>, HarmonyosColumnController> {
  const HarmonyosColumnWidget({super.key});

  @override
  Widget buildSuccessContent(BaseResult<HarmonyosColumn> data) {
    return Obx(() {
      return SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // 标签栏
            _tabList(),
            const SizedBox(height: 12),
            // 文章列表
            Expanded(
              child: _articleList(controller.currentIndexValue, data.data!.tools, data.data!.links, data.data!.open_sources),
            ),
          ],
        ),
      );
    });
  }

  /// 封装标签栏
  Widget _tabList() {
    return Row(
      children: [
        for (int i = 0; i < controller.tabList.length; i++)
          GestureDetector(
            onTap: () {
              controller.currentIndexValue = i;
            },
            child: Container(
              margin: i == 0 ? const EdgeInsets.symmetric(horizontal: 10) : null,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: controller.currentIndexValue == i ? Color(0xFF0077f1) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                StringUtil.removeHarmonyosDevPrefix(controller.tabList[i]),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: controller.currentIndexValue == i ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// 文章列表
  Widget _articleList(
    int currentIndex,
    HarmonyosColumnTools tools,
    HarmonyosColumnLinks links,
    HarmonyosColumnOpenSources openSources,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        itemCount: currentIndex == 0
            ? tools.articleList.length
            : currentIndex == 1
            ? links.articleList.length
            : openSources.articleList.length,
        itemBuilder: (context, index) {
          return _articleItem(
            currentIndex == 0
                ? tools.articleList[index]
                : currentIndex == 1
                ? links.articleList[index]
                : openSources.articleList[index],
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
        RouteUtils.to(Routes.webview, arguments: {"link": article.link, "title": article.chapterName,"originId":article.id,"collect":article.collect});
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
  }
}
