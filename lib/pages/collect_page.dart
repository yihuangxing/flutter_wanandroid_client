import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/api/api_service.dart';
import 'package:flutter_wanandroid_client/http/base_result.dart';
import 'package:flutter_wanandroid_client/model/home_article.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:flutter_wanandroid_client/routes/routes.dart';
import 'package:flutter_wanandroid_client/utils/string_util.dart';
import 'package:flutter_wanandroid_client/widget/loading_widget.dart';

class CollectPage extends StatefulWidget {
  const CollectPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CollectPageState createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  final EasyRefreshController _refreshController = EasyRefreshController(controlFinishRefresh: true, controlFinishLoad: true);
  List<HomeArticleInfo> articleList = [];

  late Future<BaseResult<HomeArticle>> _collectListFuture;

  @override
  void initState() {
    super.initState();
    _collectListFuture = getCollectList();
    _collectListFuture.then((value) {
      if (value.isSuccess) {
        articleList = value.data?.datas ?? [];
        _refreshController.finishRefresh();
        _refreshController.finishLoad();
        setState(() {});
      }
    });
  }

  ///我的收藏列表
  ///
  Future<BaseResult<HomeArticle>> getCollectList() async {
    final result = await ApiService().getCollectArticleList();
    return result;
  }

  /// 首页文章列表
  Widget _homeArticleList(ScrollPhysics physics) {
    return ListView.builder(
      // 移除默认的ListView padding
      padding: EdgeInsets.zero,
      itemCount: articleList.length,
      shrinkWrap: true,
      physics: physics,
      itemBuilder: (context, index) {
        final article = articleList[index];
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("我的收藏")),
      body: EasyRefresh.builder(
        controller: _refreshController,
        onRefresh: () async {
          await getCollectList();
        },
        childBuilder: (context, physics) {
          return FutureBuilder(
            future: _collectListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: LoadingWidget(backgroundColor: Colors.transparent));
              }
              if (snapshot.hasError) {
                return Center(child: Text('加载失败：${snapshot.error}'));
              }
              return _homeArticleList(physics);
            },
          );
        },
      ),
    );
  }
}
