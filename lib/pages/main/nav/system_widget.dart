import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/base/base_state_page.dart';
import 'package:flutter_wanandroid_client/http/base_result.dart';
import 'package:flutter_wanandroid_client/model/system_tree_info.dart';
import 'package:flutter_wanandroid_client/pages/main/controller/system_controller.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:flutter_wanandroid_client/routes/routes.dart';
import 'package:get/get.dart';

/// 体系导航界面
class SystemWidget extends BaseStatePage<BaseResult<List<SystemTreeInfo>>, SystemController> {
  const SystemWidget({super.key});

  @override
  Widget buildSuccessContent(BaseResult<List<SystemTreeInfo>> data) {
    return Stack(
      children: [
        ListView.builder(
          controller: controller.scrollController,
          itemCount: data.data?.length ?? 0,
          itemBuilder: (context, index) {
            return _systemItem(data.data![index]);
          },
        ),

        // 顶部栏区域 实现滑动渐变，从透明到不透明
        Obx(() {
          return Container(
            padding: const EdgeInsets.only(top: 45, left: 16),
            width: double.infinity,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: controller.opacity.value),
              boxShadow: controller.opacity.value > 0.5
                  ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 5, offset: const Offset(0, 2))]
                  : [],
            ),
            child: Text(
              '知识体系',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87.withValues(alpha: controller.opacity.value),
              ),
            ),
          );
        }),
      ],
    );
  }

  /// 体系项
  Widget _systemItem(SystemTreeInfo item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Container(
          margin: EdgeInsets.only(left: 12),
          child: Row(
            children: [
              //随机颜色
              Text(
                item.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ),
        //使用wrap布局子项
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Wrap(
            textDirection: TextDirection.ltr,
            spacing: 10,
            children: item.children
                .map(
                  (e) => InkWell(
                    onTap: () {
                      // 跳转体系详情页面
                      RouteUtils.to(Routes.systemDetails, arguments: e);
                    },
                    child: Chip(
                      label: Text(e.name, style: TextStyle(fontSize: 14, color: controller.getColor(e.id.toString()))),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
