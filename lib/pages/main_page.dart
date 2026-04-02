// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/widget/home_widget.dart';
import 'package:flutter_wanandroid_client/widget/mine_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  List<BottomNavigationBarItem> _items() {
    return [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
      // BottomNavigationBarItem(icon: Icon(Icons.category), label: '分类'),
      // BottomNavigationBarItem(icon: Icon(Icons.article), label: '文章'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        // 禁用页面切换动画
        physics: const NeverScrollableScrollPhysics(),
        children: [HomeWidget(), MineWidget()],
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
    );
  }
}
