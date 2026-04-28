import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid_client/api/api_service.dart';
import 'package:flutter_wanandroid_client/http/base_result.dart';
import 'package:flutter_wanandroid_client/model/project_list_info.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:flutter_wanandroid_client/routes/routes.dart';
import 'package:flutter_wanandroid_client/utils/string_util.dart';
import 'package:flutter_wanandroid_client/widget/loading_empty.dart';
import 'package:flutter_wanandroid_client/widget/loading_error_widget.dart';
import 'package:flutter_wanandroid_client/widget/loading_widget.dart';

/// 项目列表组件
class ProjectListWidget extends StatefulWidget {
  final int cid;
  const ProjectListWidget({super.key, required this.cid});

  @override
  // ignore: library_private_types_in_public_api
  _ProjectListWidgetState createState() => _ProjectListWidgetState();
}

class _ProjectListWidgetState extends State<ProjectListWidget> with AutomaticKeepAliveClientMixin<ProjectListWidget> {
  @override
  bool get wantKeepAlive => true;

  // 项目列表数据
  List<ProjectInfo> projectList = [];
  late Future<BaseResult<ProjectListInfo>> _futureProjectList;
  // 刷新控制器
  final EasyRefreshController _refreshController = EasyRefreshController(controlFinishRefresh: true, controlFinishLoad: true);

  @override
  void initState() {
    super.initState();
    // 初始化获取项目列表
    _futureProjectList = getProjectList();
    _futureProjectList.then((value) {
      setState(() {
        projectList = value.data?.datas ?? [];
      });
    });
  }

  //获取 项目列表
  Future<BaseResult<ProjectListInfo>> getProjectList() async {
    try {
      // 调用项目列表接口
      final response = await ApiService().getProjectList(params: {'cid': widget.cid});
      setState(() {
        projectList = response.data?.datas ?? [];
        _refreshController.finishRefresh();
      });
      return response;
    } catch (e) {
      _refreshController.finishRefresh();
      _refreshController.finishLoad();
      debugPrint("获取项目列表失败: $e");
      setState(() {});
      return BaseResult(errorCode: -1, errorMsg: "网络错误，请检查网络连接", data: null);
    }
  }

  // 项目项
  Widget _projectItem(ProjectInfo project) {
    return InkWell(
      onTap: () {
        // 跳转到webview页面
        RouteUtils.to(Routes.webview, arguments: {"link": project.link, "title": project.chapterName, "originId": project.id, "collect": project.collect});
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 项目标题
              Text(
                StringUtil.removeMdash(project.title),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              // 作者标签
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue, width: 1),
                ),
                child: Text(
                  "作者：${project.author}",
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              // 项目描述
              if (project.desc.isNotEmpty)
                Text(
                  StringUtil.removeMdash(project.desc),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              if (project.desc.isNotEmpty) const SizedBox(height: 12),
              // 项目信息：分类和时间
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 分类信息
                  Text(
                    '${project.superChapterName}/${project.chapterName}',
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                  // 发布时间
                  Text(project.niceShareDate, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh(
      refreshOnStart: true,
      controller: _refreshController,
      onRefresh: () async {
        await getProjectList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: FutureBuilder<BaseResult<ProjectListInfo>>(
          future: _futureProjectList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(height: 90, child: LoadingWidget(backgroundColor: Colors.transparent, width: 90, height: 90));
            }

            //这里注意 getProjectList 方法在捕获异常后返回了一个错误的 BaseResult 对象
            //而不是抛出异常，导致 FutureBuilder 的 snapshot.hasError 为 false
            if (snapshot.hasError) {
              return LoadingErrorWidget(
                error: snapshot.data?.errorMsg ?? "获取失败",
                retry: () async {
                  setState(() {
                    _futureProjectList = getProjectList();
                  });
                },
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data?.errorCode != 0) {
                return LoadingErrorWidget(
                  error: snapshot.data?.errorMsg ?? "获取失败",
                  retry: () async {
                    setState(() {
                      _futureProjectList = getProjectList();
                    });
                  },
                );
              }
              return ListView.builder(
                itemCount: projectList.length,
                itemBuilder: (context, index) {
                  return _projectItem(projectList[index]);
                },
              );
            }
            return LoadingEmpty();
          },
        ),
      ),
    );
  }
}
