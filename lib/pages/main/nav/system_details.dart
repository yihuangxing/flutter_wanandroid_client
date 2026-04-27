import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/base/base_state_page.dart';
import 'package:flutter_wanandroid_client/model/home_article.dart';
import 'package:flutter_wanandroid_client/pages/main/controller/system_details_controller.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:flutter_wanandroid_client/routes/routes.dart';
import 'package:flutter_wanandroid_client/utils/string_util.dart';

/// 体系详情列表
class SystemDetails extends BaseStatePage<List<HomeArticleInfo>, SystemDetailsController> {
  const SystemDetails({super.key});

  @override
  PreferredSizeWidget? buildAppBar() {
    return AppBar(title: Text('体系详情'));
  }

  @override
  Widget buildSuccessContent(List<HomeArticleInfo> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _articleItem(data[index]);
      },
    );
  }
}

Widget _articleItem(HomeArticleInfo article) {
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 分类信息
                Text(
                  '${article.superChapterName}/${article.chapterName}',
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                ),
                const SizedBox(height: 10),
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
