import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/api/api_service.dart';
import 'package:flutter_wanandroid_client/model/project_menu_info.dart';
import 'package:flutter_wanandroid_client/widget/loading_widget.dart';
import 'package:flutter_wanandroid_client/widget/project_list_widget.dart';

class ProjectMenuWidget extends StatefulWidget {
  const ProjectMenuWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProjectMenuWidgetState createState() => _ProjectMenuWidgetState();
}

class _ProjectMenuWidgetState extends State<ProjectMenuWidget> with TickerProviderStateMixin {
  late TabController _tabController;

  late Future<List<ProductMenuInfo>> _futureCategories;

  /// 获取项目分类列表
  List<ProductMenuInfo> projectMenuList = [];

  @override
  void initState() {
    super.initState();
    // 获取项目分类列表
    _futureCategories = getProjectMenuList();
    _futureCategories.then((value) {
      setState(() {
        //延时2s
        projectMenuList = value;
        _tabController = TabController(vsync: this, length: value.length, initialIndex: 0);
      });
    });
  }

  Future<List<ProductMenuInfo>> getProjectMenuList() async {
    final result = await ApiService().getProjectMenuList();
    return result.data ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<ProductMenuInfo>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(height: 50, child: LoadingWidget());
          }
          return Column(
            children: [
              TabBar(
                controller: _tabController,
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                indicatorColor: Colors.red,
                labelColor: Colors.red,
                dividerHeight: 0,
                unselectedLabelColor: Colors.grey,
                indicatorWeight: 4, // 指示器的粗细/高度，默认2个逻辑像素
                indicatorPadding: EdgeInsets.only(bottom: 6),
                labelPadding: EdgeInsets.symmetric(horizontal: 12),
                tabs: projectMenuList.map((e) => Tab(text: e.name)).toList(),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: projectMenuList.map((e) => ProjectListWidget(cid: e.id)).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
