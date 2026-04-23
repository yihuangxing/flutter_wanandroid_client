import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wanandroid_client/routes/routes.dart';
import 'package:flutter_wanandroid_client/utils/storage_util.dart';
import 'package:get/get.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized() 是 Flutter 中一个非常重要的初始化方法
  // 简单来说，这句话的作用是：确保 Flutter 框架已经准备好与原生平台进行通信。
  WidgetsFlutterBinding.ensureInitialized();
  await StorageUtil.init();

  // 在 runApp 之前设置状态栏样式
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // 核心：设置状态栏背景为透明
      statusBarColor: Colors.transparent,
      // 可选：根据背景色调整状态栏图标亮度（dark: 深色图标， light: 浅色图标）
      statusBarIconBrightness: Brightness.dark,
      // Android 部分版本可能需要此属性配合
      statusBarBrightness: Brightness.light,
    ),
  );

  //完成这一步后，应用内容就会绘制到状态栏下方。为了让布局内容不被状态栏遮挡，我们需要利用 SafeArea 组件包裹应用内容
  // 这样，应用内容就会自动调整到状态栏下方，避免被遮挡。

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    EasyRefresh.defaultHeaderBuilder = () => ClassicHeader(
      dragText: '下拉刷新',
      armedText: '释放立即刷新',
      readyText: '刷新中...',
      processingText: '刷新中...',
      processedText: '刷新成功',
      noMoreText: '没有更多数据',
      failedText: '刷新失败',
      messageText: '上次更新于 %T',
      showMessage: true, // 显示消息文本
    );
    EasyRefresh.defaultFooterBuilder = () => ClassicFooter(
      dragText: '上拉加载更多',
      armedText: '释放立即加载',
      readyText: '加载中...',
      processingText: '加载中...',
      processedText: '加载成功',
      noMoreText: '没有更多数据',
      failedText: '加载失败',
      messageText: '上次更新于 %T',
      showMessage: true, // 显示消息文本
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Wan安卓客户端',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.white)),
      // 初始路由
      initialRoute: Routes.initial,
      // 配置路由
      getPages: Routes.pages,
    );
  }
}
