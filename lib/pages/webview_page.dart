import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/model/home_article.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  const WebviewPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  /// 文章信息
  var title = '';
  var link = '';
  /// webview控制器
  late WebViewController controller;
  //当前进度条
  var _progress = 0;

  @override
  void initState() {
    super.initState();
    // 从路由参数中获取文章信息
    final articleInfo = RouteUtils.getArgument() as Map<String, dynamic>;
    title = articleInfo['title'] ?? '';
    link = articleInfo['link'] ?? '';
    // 初始化webview控制器
    controller = WebViewController()
      // 启用JS，必须设置为unrestricted模式
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              _progress = progress;
            });
          },
          onPageStarted: (url) {
            setState(() {
              _progress = 0;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _progress = 100;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(link));
    // 加载文章内容
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          if (_progress < 100)
            LinearProgressIndicator(
              // 进度条高度
              minHeight: 1,
              // 进度条颜色
              valueColor: AlwaysStoppedAnimation(Colors.red),
              // 进度条背景颜色
              backgroundColor: Colors.grey.shade200,
              value: _progress / 100,
            ),
          Expanded(child: WebViewWidget(controller: controller)),
        ],
      ),
    );
  }
}
