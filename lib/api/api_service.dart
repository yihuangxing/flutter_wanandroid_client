import 'package:flutter_wanandroid_client/api/api_constant.dart';
import 'package:flutter_wanandroid_client/http/base_result.dart';
import 'package:flutter_wanandroid_client/http/network_manager.dart';
import 'package:flutter_wanandroid_client/model/banner_info.dart';
import 'package:flutter_wanandroid_client/model/harmony_column_info.dart';
import 'package:flutter_wanandroid_client/model/home_article.dart';

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
  /// [params] 请求参数
  /// [bannerList] banner列表
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
  /// [params] 请求参数
  /// [homeArticle] 首页文章列表
  /// [curPage] 当前页码
  /// [pageSize] 每页数量

  Future<BaseResult<HomeArticle>> getHomeArticleList({Map<String, dynamic>? params}) async {
    final result = await _networkManager.get(ApiConstant.homeArticleList, queryParameters: params);
    return BaseResult(errorCode: result.errorCode, errorMsg: result.errorMsg, data: HomeArticle.fromJson(result.data as Map<String, dynamic>));
  }

  /// 获取鸿蒙专栏列表
  /// [params] 请求参数
  /// [harmonyosColumnList] 鸿蒙专栏列表
  Future<BaseResult<HarmonyosColumn>> getHarmonyosColumnList({Map<String, dynamic>? params}) async {
    final result = await _networkManager.get(ApiConstant.harmonyosColumnList, queryParameters: params);
    return BaseResult(errorCode: result.errorCode, errorMsg: result.errorMsg, data: HarmonyosColumn.fromJson(result.data as Map<String, dynamic>));
  }
}
