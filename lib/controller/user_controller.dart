import 'package:flutter_wanandroid_client/model/user_info.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class UserController extends GetxController {
  final Rx<UserInfo> _userInfo = UserInfo().obs;

  UserInfo get userInfo => _userInfo.value;


// 更新用户信息
  set userInfo(UserInfo value) => _userInfo.value = value;

  // 是否登录
  bool get isLogin => _userInfo.value.username.isNotEmpty && _userInfo.value.id != 0;
}
