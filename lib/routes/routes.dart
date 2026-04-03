import 'package:flutter_wanandroid_client/pages/login_page.dart';
import 'package:flutter_wanandroid_client/pages/main_page.dart';
import 'package:flutter_wanandroid_client/pages/register_page.dart';
import 'package:flutter_wanandroid_client/pages/splash_page.dart';
import 'package:flutter_wanandroid_client/pages/webview_page.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

class Routes {
  static const String initial = '/';
  static const String main = '/main';
  static const String webview = '/webview';
  static const String login = '/login';
  static const String register = '/register';

  static final List<GetPage> pages = [
    //启动页
    GetPage(name: Routes.initial, page: () => const Splashpage(), transition: Transition.fadeIn),
    //主页面
    GetPage(name: Routes.main, page: () => const MainPage(), transition: Transition.fadeIn),
    //webview页面
    GetPage(name: Routes.webview, page: () => const WebviewPage(), transition: Transition.fadeIn),

    //登录页面
    GetPage(name: Routes.login, page: () => const LoginPage(), transition: Transition.fadeIn),

    //注册页面
    GetPage(name: Routes.register, page: () => const RegisterPage(), transition: Transition.fadeIn),
  ];
}
