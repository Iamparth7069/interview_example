import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class PrefManagser {
  static const String IS_LOGIN = "isLogin";
  static const String IS_VISITED = "isVisited";
  static const String emails1 = "Emails";
  static const String uids = "uid";
  static late SharedPreferences _preferences;

  static Future<SharedPreferences?> init() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  static void updateLoginStatus(bool status) async {
    await _preferences.setBool(IS_LOGIN, status);
  }

  static bool getLoginStatus() {
    return _preferences.getBool(IS_LOGIN) ?? false;
  }

  static Future<void> updateuid(int uid) async {
    await _preferences.setInt(uids, uid);
  }
  static int getuid() {
    return _preferences.getInt(uids) ?? -1;
  }
}
