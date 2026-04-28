import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wanandroid_client/routes/routes.dart';
import 'package:flutter_wanandroid_client/utils/storage_util.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageUtil.init();

  // 启用边到边模式
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // 全局设置系统UI样式(但底部手势指示条区域还是白色，配合 AnnotatedRegion 组件可以解决)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

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
      showMessage: true,
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
      showMessage: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 使用 AnnotatedRegion 包装整个应用
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: GetMaterialApp(
        title: 'Wan安卓客户端',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          appBarTheme: const AppBarTheme(
            surfaceTintColor: Colors.white, 
            backgroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
          // 同时设置 scaffoldBackgroundColor 确保整个应用背景为白色
          scaffoldBackgroundColor: Colors.white,
        ),
        // 初始路由
        initialRoute: Routes.initial,
        // 配置路由
        getPages: Routes.pages,
        // 添加 builder 作为额外的保障
        builder: (context, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                systemNavigationBarColor: Colors.white,
                systemNavigationBarIconBrightness: Brightness.dark,
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
              ),
              child: child!,
            ),
          );
        },
      ),
    );
  }
}