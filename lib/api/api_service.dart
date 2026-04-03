import 'package:dio/dio.dart';
import 'package:flutter_wanandroid_client/api/api_constant.dart';
import 'package:flutter_wanandroid_client/http/base_result.dart';
import 'package:flutter_wanandroid_client/http/network_manager.dart';
import 'package:flutter_wanandroid_client/model/banner_info.dart';
import 'package:flutter_wanandroid_client/model/harmony_column_info.dart';
import 'package:flutter_wanandroid_client/model/home_article.dart';
import 'package:flutter_wanandroid_client/model/project_list_info.dart';
import 'package:flutter_wanandroid_client/model/project_menu_info.dart';
import 'package:flutter_wanandroid_client/model/user_info.dart';

/// API服务类
class ApiService {
  /// 单例实例
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  /// 网络管理器
  final NetworkManager _networkManager = NetworkManager();

  /// 内部构造函数
  ApiService._internal();

  ///获取banner列表
  /// [params] 被花括号 {} 括起来，这表示它是命名参数，必须使用 params: value 的方式传递。
  Future<BaseResult<List<BannerInfo>>> getBannerList({Map<String, dynamic>? params}) async {
    final result = await _networkManager.get(ApiConstant.bannerList, queryParameters: params);

    //转换数据类型 result.data 是<BannerInfo> 可能是List<BannerInfo> 或者 null
    // 所以需要判断是否是List
    if (result.data is List) {
      List<BannerInfo> bannerList = (result.data as List).map((e) => BannerInfo.fromJson(e as Map<String, dynamic>)).toList();
      return BaseResult(errorCode: result.errorCode, errorMsg: result.errorMsg, data: bannerList);
    }
    return BaseResult(errorCode: result.errorCode, errorMsg: result.errorMsg, data: []);
  }

  /// 获取首页文章列表
  /// [params] 被花括号 {} 括起来，这表示它是命名参数，必须使用 params: value 的方式传递。
  Future<BaseResult<HomeArticle>> getHomeArticleList({Map<String, dynamic>? params}) async {
    final result = await _networkManager.get(ApiConstant.homeArticleList, queryParameters: params);
    return BaseResult(errorCode: result.errorCode, errorMsg: result.errorMsg, data: HomeArticle.fromJson(result.data as Map<String, dynamic>));
  }

  /// 获取鸿蒙专栏列表
  /// [params] 被花括号 {} 括起来，这表示它是命名参数，必须使用 params: value 的方式传递。
  /// [harmonyosColumnList] 鸿蒙专栏列表
  Future<BaseResult<HarmonyosColumn>> getHarmonyosColumnList({Map<String, dynamic>? params}) async {
    final result = await _networkManager.get(ApiConstant.harmonyosColumnList, queryParameters: params);
    return BaseResult(errorCode: result.errorCode, errorMsg: result.errorMsg, data: HarmonyosColumn.fromJson(result.data as Map<String, dynamic>));
  }

  //项目分类
  /// [params] 被花括号 {} 括起来，这表示它是命名参数，必须使用 params: value 的方式传递。
  /// [projectMenuList] 项目分类列表
  Future<BaseResult<List<ProductMenuInfo>>> getProjectMenuList({Map<String, dynamic>? params}) async {
    final result = await _networkManager.get(ApiConstant.projectMenuList, queryParameters: params);
    return BaseResult(
      errorCode: result.errorCode,
      errorMsg: result.errorMsg,
      data: (result.data as List).map((e) => ProductMenuInfo.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  // 项目列表
  /// [params] 被花括号 {} 括起来，这表示它是命名参数，必须使用 params: value 的方式传递。
  Future<BaseResult<ProjectListInfo>> getProjectList({Map<String, dynamic>? params}) async {
    final result = await _networkManager.get(ApiConstant.projectList, queryParameters: params);
    return BaseResult(errorCode: result.errorCode, errorMsg: result.errorMsg, data: ProjectListInfo.fromJson(result.data as Map<String, dynamic>));
  }

  ///用户注册
  /// [params] 被花括号 {} 括起来，这表示它是命名参数，必须使用 params: value 的方式传递。
  /// [userInfo] 用户信息
  Future<BaseResult<UserInfo>> register({Map<String, dynamic>? params}) async {
    final result = await _networkManager.post(ApiConstant.register, data: params, contentType: Headers.formUrlEncodedContentType);
    //这里要做判空处理 因为result.data 可能是null
    if (result.data == null) {
      return BaseResult(errorCode: result.errorCode, errorMsg: result.errorMsg, data: null);
    }
    return BaseResult(errorCode: result.errorCode, errorMsg: result.errorMsg, data: UserInfo.fromJson(result.data as Map<String, dynamic>));
  }



  /// 用户登录
  /// [params] 被花括号 {} 括起来，这表示它是命名参数，必须使用 params: value 的方式传递。
  /// [userInfo] 用户信息
  Future<BaseResult<UserInfo>> login({Map<String, dynamic>? params}) async {
    final result = await _networkManager.post(ApiConstant.login, data: params, contentType: Headers.formUrlEncodedContentType);
    //这里要做判空处理 因为result.data 可能是null
    if (result.data == null) {
      return BaseResult(errorCode: result.errorCode, errorMsg: result.errorMsg, data: null);
    }
    return BaseResult(errorCode: result.errorCode, errorMsg: result.errorMsg, data: UserInfo.fromJson(result.data as Map<String, dynamic>));
  }
}
