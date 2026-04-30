import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/base/base_state_page.dart';
import 'package:flutter_wanandroid_client/model/project_menu_info.dart';
import 'package:flutter_wanandroid_client/pages/main/controller/project_menu_controller.dart';
import 'package:flutter_wanandroid_client/pages/main/widget/project_list_widget.dart';


/// 项目分类列表页面状态管理
class ProjectMenuWidget extends BaseStatePage<List<ProductMenuInfo>, ProjectMenuController> {
  const ProjectMenuWidget({super.key});

  @override
  Widget buildSuccessContent(List<ProductMenuInfo> data) {
    return SafeArea(
      child: Column(
        children: [
          TabBar(
            controller: controller.tabController,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicatorColor: Color(0xFF0077f1),
            labelColor: Color(0xFF0077f1),
            dividerHeight: 0,
            unselectedLabelColor: Colors.grey,
            indicatorWeight: 4, // 指示器的粗细/高度，默认2个逻辑像素
            indicatorPadding: EdgeInsets.only(bottom: 6),
            labelPadding: EdgeInsets.symmetric(horizontal: 12),
            tabs: data.map((e) => Tab(text: e.name)).toList(),
          ),

          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: data.map((e) => ProjectListWidget(cid: e.id)).toList(),
            ),
          ),
        ],
      )
    );
  }

}
