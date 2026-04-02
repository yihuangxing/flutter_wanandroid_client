import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/model/home_article.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';

class WebviewPage extends StatefulWidget {
  const WebviewPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  /// 文章信息
  HomeArticleInfo? articleInfo;

  @override
  void initState() {
    super.initState();
    // 从路由参数中获取文章信息
    articleInfo = RouteUtils.getArgument() as HomeArticleInfo?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(articleInfo?.title ?? ''),
      ),
    );
  }
}
