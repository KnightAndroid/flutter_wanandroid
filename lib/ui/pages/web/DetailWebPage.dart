import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';
import 'package:wanandroid/res/ResColors.dart';

/**
 * Describe : 详细网页
 * Created by Knight on ${DATE}
 * @Version : 1.0.0
 * 点滴之行,看世界
 */

class DetailWebPage extends StatefulWidget {
  //网页标题
  String web_title;

  //网页的url链接
  String web_url;

  //其中标题和url是必须的
  DetailWebPage({Key key, @required this.web_title, @required this.web_url})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new DetailWebPageState(web_url, web_title);
  }
}

class DetailWebPageState extends State<DetailWebPage> {
  //链接url
  String web_url;

  //标题
  String web_title;

  //标记是否加载中
  bool isLoading = true;

  //标记当前页面是否是我们自定义的回调页面
  bool isLoadingCallbackPage = false;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  //URL变化监听器
  StreamSubscription<String> urlChanged;

  //WebView加载状态变化监听器
  StreamSubscription<WebViewStateChanged> onStateChanged;

  //这是插件，WebView的各种操作
  FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();

  DetailWebPageState(this.web_url, this.web_title);

  //初始化状态函数
  @override
  void initState() {
    super.initState();
    onStateChanged = flutterWebviewPlugin.onStateChanged.listen((state) {
      //state.type 是一个枚举类型
      //值:
      //1.WebViewState.shouldStart,准备加载
      //2.WebViewState.startLoad,开始加载
      //3.WebViewState.finishLoad,加载完成
      //做判断
      switch (state.type) {
        case WebViewState.shouldStart:
          setState(() {});
          break;
        case WebViewState.startLoad:
          break;
        case WebViewState.finishLoad:
          //加载完成
          setState(() {
            isLoading = false;
          });
          if (isLoadingCallbackPage) {
            //当前是回调页面，则调用js方法获取

          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> title_content = [];
    title_content.add(
      new Container(
        child:new Text(
          web_title,
          style: new TextStyle(color: ResColors.colorWhite),
          overflow: TextOverflow.ellipsis,
        ),
        width: 200.0,
      ),

    );
    //要判断是否还在加载
    if (isLoading) {
      //加载中，直接显示加载圈
      title_content.add(new CupertinoActivityIndicator());
    }

    title_content.add(new Container(width: 50.0));

    //返回一个WebViewScaffold 是插件提供的，就是在页面是直接显示一个WebView
    return new WebviewScaffold(
      key: scaffoldKey,
      url: web_url,
      appBar: new AppBar(
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: title_content,
        ),
        iconTheme: new IconThemeData(color: ResColors.colorWhite),
      ),

      //允许网页缩放
      withZoom: true,

      withLocalStorage: true,
      //允许本地存储
      withJavascript: true, //允许执行js代码
    );
  }

  @override
  void dispose() {
    super.dispose();
    //回收资源 所有的监听都应该会关掉

   // urlChanged.cancel();
    onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
  }
}
