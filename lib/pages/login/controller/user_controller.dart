import 'package:flutter_wanandroid_client/api/api_service.dart';
import 'package:flutter_wanandroid_client/base/base_controller.dart';
import 'package:flutter_wanandroid_client/http/base_result.dart';
import 'package:flutter_wanandroid_client/model/user_info.dart';
import 'package:flutter_wanandroid_client/routes/route_utils.dart';
import 'package:flutter_wanandroid_client/utils/loading_dialog_util.dart';
import 'package:flutter_wanandroid_client/utils/storage_util.dart';
import 'package:flutter_wanandroid_client/utils/toast_util.dart';
import 'package:get/get.dart';

class UserController extends BaseController<UserInfo> {
  final Rx<UserInfo> _userInfo = UserInfo().obs;

  UserInfo get userInfo => _userInfo.value;

  // 更新用户信息
  set userInfo(UserInfo value) => _userInfo.value = value;

  // 是否登录
  bool get isLogin => _userInfo.value.username.isNotEmpty && _userInfo.value.id != 0;
  
  @override
  Future<void> loadData() async {
  }


  //登录
  Future<void> login(String username, String password) async {
    await LoadingDialogUtil.showDuring<BaseResult<UserInfo>>(Get.context!, () async {
        final currentUserInfo = await ApiService().login(params: {'username': username, 'password': password});
        if (currentUserInfo.isSuccess) {
          ToastUtil.show('登录成功,欢迎回来，$username！');
          // 记住密码
          StorageUtil.setString(StorageKey.loginUsername, username);
          StorageUtil.setString(StorageKey.loginPassword, password);
          // 更新用户信息
          userInfo = currentUserInfo.data!;
          RouteUtils.back();
        } else {
          ToastUtil.showError(currentUserInfo.errorMsg);
        }
        return currentUserInfo;
      });

  }
}
