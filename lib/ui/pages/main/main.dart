import 'package:flutter/material.dart';
import 'package:wanandroid/ui/pages/splash/WelcomePage.dart';
import 'package:wanandroid/res/ResColors.dart';

//app入口
void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        //主体颜色为蓝色
        primaryColor: ResColors.blue,
        primarySwatch: ResColors.blue,
      ),
      home: WelcomePage(),
      //routes: PageConstance.getRoutes(),
    );
  }
}


