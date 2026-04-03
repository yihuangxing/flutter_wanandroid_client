import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:flutter_wanandroid_client/routes/routes.dart';

class MineWidget extends StatefulWidget {
  const MineWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MineWidgetState createState() => _MineWidgetState();
}

class _MineWidgetState extends State<MineWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // 模拟用户数据
  final String _userName = '用户名';
  final String _userBio = '这个人很懒，什么都没留下';
  final String _avatarUrl = '';
  final int _followers = 128;
  final int _following = 45;
  final int _articles = 32;

  // 功能菜单列表 - 第一组
  final List<MenuItem> _menuItemsGroup1 = [
    MenuItem(icon: Icons.favorite_outlined, title: '收藏夹', badge: '12', onTap: () {}),
    MenuItem(icon: Icons.history_outlined, title: '浏览历史', onTap: () {}),
    MenuItem(icon: Icons.star_outlined, title: '积分', badge: '256', onTap: () {}),
  ];

  // 功能菜单列表 - 第二组
  final List<MenuItem> _menuItemsGroup2 = [
    MenuItem(
      icon: Icons.settings_outlined,
      title: '设置',
      onTap: () {
        // 跳转到设置页面
        RouteUtils.to(Routes.webview, arguments: {"link": "", "title": "设置"});
      },
    ),
    MenuItem(
      icon: Icons.help_outline,
      title: '帮助与反馈',
      onTap: () {
        // 跳转到帮助与反馈页面
        RouteUtils.to(Routes.webview, arguments: {"link": "", "title": "帮助与反馈"});
      },
    ),
    MenuItem(
      icon: Icons.info_outline,
      title: '关于我们',
      onTap: () {
        // 跳转到关于我们页面
        RouteUtils.to(Routes.webview, arguments: {"link": "", "title": "关于我们"});
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true, //滑动到顶端时会固定住
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(vertical: 10),
              background: Image.network(
                'https://img2.baidu.com/it/u=2354404472,4757673&fm=253&fmt=auto&app=138&f=PNG?w=500&h=212',
                fit: BoxFit.cover,
                height: 160,
              ),
              title: GestureDetector(
                onTap: () {
                  // 跳转到登录页面
                  RouteUtils.to(Routes.login);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 16),
                  child: Row(
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.asset('assets/images/ic_logo.jpg', height: 40, width: 40)),
                      SizedBox(width: 8),
                      Text(
                        _userName,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // background: _buildUserInfoSection(),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildStatsSection(),
                _buildMenuSection(_menuItemsGroup1),
                const SizedBox(height: 16),
                _buildMenuSection(_menuItemsGroup2),
                const SizedBox(height: 26),
                _buildLogoutButton(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建统计信息区域
  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('关注', _following),
          const VerticalDivider(width: 1, color: Color(0xFFF0F0F0)),
          _buildStatItem('粉丝', _followers),
          const VerticalDivider(width: 1, color: Color(0xFFF0F0F0)),
          _buildStatItem('文章', _articles),
        ],
      ),
    );
  }

  // 构建统计项
  Widget _buildStatItem(String title, int value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  // 构建功能菜单区域
  Widget _buildMenuSection(List<MenuItem> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          int index = entry.key;
          MenuItem item = entry.value;
          return Column(
            children: [
              GestureDetector(
                onTap: item.onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Icon(item.icon, size: 24, color: const Color(0xFF667eea)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(item.title, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                      ),
                      if (item.badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: const BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: Text(item.badge!, style: const TextStyle(fontSize: 12, color: Colors.white)),
                        ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right, size: 24, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              if (index < items.length - 1) const Divider(height: 1, indent: 60, color: Color(0xFFF0F0F0)),
            ],
          );
        }).toList(),
      ),
    );
  }

  // 构建退出登录按钮
  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () {
          // 显示退出登录确认对话框
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('退出登录'),
              content: const Text('确定要退出登录吗？'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    // 执行退出登录操作
                    Navigator.of(context).pop();
                    // 跳转到登录页面
                    // RouteUtils.off(Routes.login);
                  },
                  child: const Text('确定'),
                ),
              ],
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size(double.infinity, 50),
          elevation: 0,
          side: const BorderSide(color: Colors.red, width: 1),
        ),
        child: const Text('退出登录', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

// 菜单项模型
class MenuItem {
  final IconData icon;
  final String title;
  final String? badge;
  final Function() onTap;

  MenuItem({required this.icon, required this.title, this.badge, required this.onTap});
}
