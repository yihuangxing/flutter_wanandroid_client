import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/api/api_service.dart';
import 'package:flutter_wanandroid_client/pages/login/controller/user_controller.dart';
import 'package:flutter_wanandroid_client/http/base_result.dart';
import 'package:flutter_wanandroid_client/model/collect_article_info.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:flutter_wanandroid_client/routes/routes.dart';
import 'package:flutter_wanandroid_client/utils/loading_dialog_util.dart';
import 'package:flutter_wanandroid_client/utils/toast_util.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
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
  var originId = 0;

  /// webview控制器
  late WebViewController controller;
  //当前进度条
  var _progress = 0;

  var isCollect = false;

  late UserController _userController;

  @override
  void initState() {
    super.initState();
    // 获取 UserController 实例
    _userController = Get.find<UserController>();
    // 从路由参数中获取文章信息
    final articleInfo = RouteUtils.getArgument() as Map<String, dynamic>;
    title = articleInfo['title'] ?? '';
    link = articleInfo['link'] ?? '';
    originId = articleInfo['originId'] ?? 0;
    isCollect =articleInfo['collect'] ?? false;

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

  // 顶部返回按钮
  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            RouteUtils.back();
          },
          icon: const Icon(Icons.arrow_back, size: 24, color: Colors.black87),
        ),
        Text(
          "文章详情",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const Expanded(child: SizedBox()),
        IconButton(
          onPressed: () async {
            // 先判断是否登录
            if (_userController.isLogin) {
              // 已登录，继续执行收藏操作
              // 收藏功能
              LoadingDialogUtil.showDuring<BaseResult<CollectArticleInfo>>(context, () async {
                final result = await ApiService().addCollectArticle(originId);
                if (result.isSuccess) {
                  // 收藏成功
                  ToastUtil.show('收藏成功');
                  setState(() {
                    isCollect = true;
                  });
                } else {
                  // 收藏失败
                  ToastUtil.show(result.errorMsg);
                }
                return result;
              });
            } else {
              // 未登录，跳转到登录页
              RouteUtils.to(Routes.login);
              return;
            }
          },
          icon: Icon(isCollect ? Icons.favorite : Icons.favorite_outline, size: 24, color: Colors.red),
        ),
        IconButton(
          onPressed: () {
            // 更多功能
          },
          icon: const Icon(Icons.share, size: 24, color: Colors.black87),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
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
      ),
    );
  }
}
