import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/api/api_service.dart';
import 'package:flutter_wanandroid_client/http/base_result.dart';
import 'package:flutter_wanandroid_client/model/system_tree_info.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:flutter_wanandroid_client/routes/routes.dart';
import 'package:flutter_wanandroid_client/utils/toast_util.dart';
import 'package:flutter_wanandroid_client/widget/loading_widget.dart';

class SystemWidget extends StatefulWidget {
  const SystemWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SystemWidgetState createState() => _SystemWidgetState();
}

class _SystemWidgetState extends State<SystemWidget> {
  /// 体系列表
  Future<BaseResult<List<SystemTreeInfo>>>? _systemTreeListFuture;

  /// 滚动控制器
  final ScrollController _scrollController = ScrollController();

  /// 顶部栏透明度
  double _opacity = 0.0;

  /// 颜色缓存，用于存储每个子项的颜色
  final Map<String, Color> _colorCache = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _systemTreeListFuture = getSystemTreeList();
    // 监听滚动事件
    _scrollController.addListener(() {
      // 计算透明度，滚动距离超过100时完全不透明
      double newOpacity = _scrollController.offset / 100;
      if (newOpacity > 1.0) newOpacity = 1.0;
      if (newOpacity < 0.0) newOpacity = 0.0;

      if (_opacity != newOpacity) {
        setState(() {
          _opacity = newOpacity;
        });
      }
    });
  }

  /// 获取体系列表
  Future<BaseResult<List<SystemTreeInfo>>> getSystemTreeList() async {
    final result = await ApiService().getSystemTreeList();
    if (result.isSuccess) {
      return result;
    }
    return BaseResult(errorCode: result.errorCode, errorMsg: result.errorMsg, data: null);
  }

  /// 获取颜色（缓存机制）
  Color getColor(String key) {
    if (!_colorCache.containsKey(key)) {
      // 生成随机颜色并缓存
      _colorCache[key] = Color(0xFF000000 + Random().nextInt(0xFFFFFF));
    }
    return _colorCache[key]!;
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
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
                      label: Text(e.name, style: TextStyle(fontSize: 14, color: getColor(e.id.toString()))),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _systemTreeListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingWidget(backgroundColor: Colors.transparent));
        } else if (snapshot.hasError || !snapshot.data!.isSuccess) {
          return const Center(child: Text('加载失败，请重试'));
        } else {
          return Stack(
            children: [
              ListView.builder(
                controller: _scrollController,
                itemCount: snapshot.data!.data!.length,
                itemBuilder: (context, index) {
                  return _systemItem(snapshot.data!.data![index]);
                },
              ),

              // 顶部栏区域 实现滑动渐变，从透明到不透明
              Container(
                padding: const EdgeInsets.only(top: 24, left: 16),
                width: double.infinity,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: _opacity),
                  boxShadow: _opacity > 0.5 ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 5, offset: const Offset(0, 2))] : [],
                ),
                child: Text(
                  '体系',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87.withValues(alpha: _opacity),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
