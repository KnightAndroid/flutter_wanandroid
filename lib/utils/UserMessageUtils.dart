import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';






class UserMessageUtils {
  static final String isLogin = "isLogin";
  static final String userName = "userName";

  //保存用户登录信息，只保存用户信息
  static Future saveUserInfo(String loginUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //存用户名
    await prefs.setString(userName, loginUserName);
    //存登录状态
    await prefs.setBool(isLogin, true);
  }

  //清楚用户登录信息
  static Future clearLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }


  //判断是否登录
  static Future<bool> whetherLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loginTrue = prefs.getBool(isLogin);
    if(loginTrue == true){
      return true;
    }else{
      return false;
    }
  }


  //获取用户名
  static Future<String> getUserName() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    return pres.getString(userName);
  }


}