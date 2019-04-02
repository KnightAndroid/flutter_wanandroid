import 'package:flutter/material.dart';
import 'package:wanandroid/view/skip_downTime.dart';
import 'package:wanandroid/ui/pages/main/MainPage.dart';
import 'package:wanandroid/res/ResColors.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new WelcomePageState();
  }
}

class WelcomePageState extends State<WelcomePage>
    implements OnSkipClickListener {



  @override
  void initState() {
    super.initState();
    //玩Android图标 慢慢出现
    _changeOpacity();
    //当5秒后进入app
    _delayEntryHomePage();
  }
  //double opacityLevel为1.0为可见状态 0.0是不可见状态
  double opacityLevel = 0.0;
  _changeOpacity(){
    //调用setState（）  根据opacityLevel当前的值重绘ui
    // 当用户点击按钮时opacityLevel的值会（1.0=>0.0=>1.0=>0.0 ...）切换
    // 所以AnimatedOpacity 会根据opacity传入的值(opacityLevel)进行重绘 Widget

    //延迟一秒执行
    new Future.delayed(new Duration(seconds: 1),(){
      setState(
              () => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0
      );
    });

  }



  //当闪屏页进度跑完 自动进入首页
  _delayEntryHomePage(){
    Future.delayed(new Duration(seconds: 5),(){
       _goHomePage();
    });
  }

  //Navigator.of(context).pushNamedAndRemoveUntil(
  //PageConstance.HOME_PAGE, (Route<dynamic> route) => false);
  //pushAndRemoveUntil方式：跳转到下个页面，并且销毁当前页面
  //第一个参数理解为上下文环境，
  //第二个参数为静态注册的对应的页面名称，
  //第三个参数为跳转后的操作，route == null 为销毁当前页面
  _goHomePage() {
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) {
      return new MainPage();
    }), (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      //主体颜色为蓝色
      child: new Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.only(bottom: 80.0),
            color: ResColors.colorWhite,
            child: new AnimatedOpacity(
              opacity: opacityLevel,
              duration: new Duration(seconds: 3),
              child: new Image.asset(
                'images/image_splash_title.png',
              ),
            ),
            constraints: new BoxConstraints.expand(),
          ),
          new Container(
            padding: const EdgeInsets.only(bottom: 50.0),
            height: 150.0,
            width: 150.0,
            child: new FlutterLogo(),
          ),
          new Container(
            child: Align(
              alignment: Alignment.topRight,
              child: new Container(
                padding: const EdgeInsets.only(top: 30.0, right: 20.0),
                child: new SkipDownTimeProgress(
                  ResColors.colorBlue,
                  20.0,
                  new Duration(seconds: 5),
                  new Size(25.0, 25.0),
                  skipText: "跳过",
                  clickListener: this,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onSkipClick() {
    // TODO: implement onSkipClick
    _goHomePage();
  }
}
