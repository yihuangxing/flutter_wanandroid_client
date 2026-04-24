// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wanandroid_client/pages/login/controller/user_controller.dart';
import 'package:flutter_wanandroid_client/pages/main/controller/harmonyos_column_controller.dart';
import 'package:flutter_wanandroid_client/pages/main/controller/project_menu_controller.dart';
import 'package:flutter_wanandroid_client/pages/main/controller/system_controller.dart';
import 'package:flutter_wanandroid_client/utils/toast_util.dart';
import 'package:flutter_wanandroid_client/widget/double_back_exit_widget.dart';
import 'package:flutter_wanandroid_client/pages/main/nav/harmonyos_column.dart';
import 'package:flutter_wanandroid_client/pages/main/nav/home_widget.dart';
import 'package:flutter_wanandroid_client/pages/main/nav/mine_widget.dart';
import 'package:flutter_wanandroid_client/pages/main/nav/project_menu_widget.dart';
import 'package:flutter_wanandroid_client/pages/main/nav/system_widget.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  List<BottomNavigationBarItem> _items() {
    return [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
      BottomNavigationBarItem(icon: Icon(Icons.article), label: '鸿蒙'),
      BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: '体系'),
      BottomNavigationBarItem(icon: Icon(Icons.menu), label: '项目'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DoubleBackExitWidget(
      onDoubleBack: () {
        // 处理双击返回逻辑
        SystemNavigator.pop();
      },
      onSingleBack: () {
        // 处理单击返回逻辑
        ToastUtil.show('再按一次退出');
      },

      child: Scaffold(
        body: PageView(
          controller: _pageController,
          // 禁用页面切换动画
          physics: const NeverScrollableScrollPhysics(),
          children: [HomeWidget(), HarmonyosColumnWidget(), SystemWidget(), ProjectMenuWidget(), MineWidget()],
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),

        bottomNavigationBar: BottomNavigationBar(
          items: _items(),
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            _pageController.jumpToPage(_currentIndex);
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/// 绑定UserController和HarmonyosColumnController
class MainPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController());
    Get.lazyPut(() => HarmonyosColumnController());
    Get.lazyPut(() => SystemController());
    Get.lazyPut(() => ProjectMenuController());
  } 
}
