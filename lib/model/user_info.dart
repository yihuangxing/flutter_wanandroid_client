//  用户信息模型
// {
//         "admin": false,
//         "coinCount": 208,
//         "email": "",
//         "icon": "",
//         "id": 99042,
//         "nickname": "zsan",
//         "password": "",
//         "publicName": "zsan",
//         "token": "",
//         "type": 0,
//         "username": "zsan"
//     }

class UserInfo {
  bool admin = false;
  int coinCount = 0;
  String email = '';
  String icon = '';
  int id = 0;
  String nickname = '';
  String password = '';
  String publicName = '';
  String token = '';
  int type = 0;
  String username = '';

  //默认构造函数
  UserInfo();

  //工厂方法
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo()
      ..admin = json['admin']
      ..coinCount = json['coinCount']
      ..email = json['email']
      ..icon = json['icon']
      ..id = json['id']
      ..nickname = json['nickname']
      ..password = json['password']
      ..publicName = json['publicName']
      ..token = json['token']
      ..type = json['type']
      ..username = json['username'];
  }
}
