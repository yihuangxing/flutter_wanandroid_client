import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/api/api_service.dart';
import 'package:flutter_wanandroid_client/http/base_result.dart';
import 'package:flutter_wanandroid_client/model/home_article.dart';
import 'package:flutter_wanandroid_client/model/system_tree_info.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:flutter_wanandroid_client/routes/routes.dart';
import 'package:flutter_wanandroid_client/utils/string_util.dart';
import 'package:flutter_wanandroid_client/widget/loading_widget.dart';

class SystemDetails extends StatefulWidget {
  const SystemDetails({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SystemDetailsState createState() => _SystemDetailsState();
}

class _SystemDetailsState extends State<SystemDetails> {
  late Future<BaseResult<HomeArticle>> _homeArticleFuture;
  List<HomeArticleInfo> articleList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 从路由参数中获取体系详情
    SystemTreeItem systemTreeItem = RouteUtils.getArgument() as SystemTreeItem;
    // 显示体系详情
    _homeArticleFuture = getSystemTreeItem(systemTreeItem.id);
    _homeArticleFuture.then((value) {
      if (value.isSuccess) {
        setState(() {
          articleList = value.data?.datas ?? [];
        });
      }
    });
  }

  // 获取体系详情 (对应获取首页文章列表接口)
  Future<BaseResult<HomeArticle>> getSystemTreeItem(int cid) async {
    final result = await ApiService().getHomeArticleList(params: {'cid': cid});
    if (result.isSuccess) {
      return result;
    } else {
      // 显示错误信息
      return BaseResult<HomeArticle>(errorCode: result.errorCode, errorMsg: result.errorMsg);
    }
  }

  /// 体系详情列表
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
                  Text('${article.superChapterName}/${article.chapterName}', style: const TextStyle(fontSize: 12, color: Colors.blue)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('体系详情')),
      body: FutureBuilder<BaseResult<HomeArticle>>(
        future: _homeArticleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LoadingWidget(backgroundColor: Colors.transparent));
          }
          if (snapshot.hasError) {
            return Center(child: Text('获取体系详情失败'));
          }
          return Container(
            child: ListView.builder(
              itemCount: articleList.length,
              itemBuilder: (context, index) {
                return _articleItem(articleList[index]);
              },
            ),
          );
        },
      ),
    );
  }
  
}
