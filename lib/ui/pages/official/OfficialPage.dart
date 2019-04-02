import 'package:flutter/material.dart';
import 'package:wanandroid/res/ResColors.dart';
import 'package:wanandroid/ui/pages/web/DetailWebPage.dart';
import 'package:wanandroid/api/Api.dart';
import 'package:wanandroid/utils/NetUtils.dart';
import 'package:wanandroid/model/ArticleModel.dart';
import 'dart:math';

//公众号开始
class OfficialPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new OfficialPageState();
  }
}

//TabTitle模型
class TabTitle {
  String title;
  int id;

  TabTitle(this.title, this.id);
}

//通过 SingleTickerProviderStateMixin 实现 Tab 的动画切换效果
class OfficialPageState extends State<OfficialPage>
    with SingleTickerProviderStateMixin {
  //每个公众号对应的颜色不一样
  static final List<Color> colorsByPage = [
    new Color(0xFF0018C8),
    new Color(0xFFDD1829),
    new Color(0xFF0018C5),
    new Color(0xFF2196F3)
  ];

  //默认是第一个集合存放的颜色
  Color backgroundColor = new Color(0xFF2196F3);

  //本页面是tab + pageView 所以需要两者的控制器
  PageController mPageController;

  //当前页
  var currentPage = 0;

  //当前页是否能改变
  var isPageCanChanged = true;

  //TabBar
  TabController tabController;
  List<TabTitle> tabList = [];
  //具体数据
  List<ArticleModel> articleModels = [];

  @override
  void initState() {
    super.initState();
    //初始化TabTitle
    initTabData();
    print("第一次走这方法");




  }

  //当page变化时回调
  onPageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {
      isPageCanChanged = false;
      await mPageController.animateToPage(index,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease); //等待pageview切换完毕,再释放pageivew监听
      //切换动画完成 页面又可以改变
      isPageCanChanged = true;
    } else {
      tabController.animateTo(index);
    }
  }

  //初始化数据
  initTabData() {
    //获取数据
    getArticle();
//    tabList = [
//      new TabTitle('BOOKS', 1),
//      new TabTitle('PODCAST', 2),
//      new TabTitle('WORKSHOPS', 3),
//      new TabTitle('BOOKS', 4),
//      new TabTitle('PODCAST', 5),
//      new TabTitle('WORKSHOPS', 6),
//      new TabTitle('BOOKS', 7),
//      new TabTitle('PODCAST', 8),
//      new TabTitle('WORKSHOPS', 9),
//      new TabTitle('BOOKS', 10),
//    ];
  }

  @override
  Widget build(BuildContext context) {
    //设置home
    return new Scaffold(
      //backgroundColor: backgroundColor,
      //让组件尽可能占用布局就ok
      body:tabList == null || tabList.length == 0 ?  new Center(
        child: new CircularProgressIndicator(),
    ):

      new SizedBox.expand(
        //列排列
        child: new Column(
          //填充父竖屏 这个属性需要搭配MainAxisAlignment
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          //交叉轴中央
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              child: new SizedBox.expand(
                child: new Hero(
                  tag: 'Materiall',
                  child: new Material(
                    color: Colors.white,
                    elevation: 24.0,
                    child: new Container(
                      margin: new EdgeInsets.only(
                       // top: 12.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      //列
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new TabBar(
                            indicatorWeight: 3.0,
                            isScrollable: true,
                            controller: tabController,
                            labelColor: ResColors.colorBlue,
                            unselectedLabelColor: ResColors.colorBack,
                            tabs: tabList.map((item) {
                              return Tab(
                                text: item.title,
                              );
                            }).toList(),
                          ),

                          //pageView
                          new Expanded(
                            child: new Hero(
                              tag: 'Material',
                              child: PageView.builder(
                                  itemCount: tabList.length,
                                  onPageChanged: (index) {
                                    //由于pageview切换是会回调这个方法,会触发切换tarbar的操作，所以定义一个flag，控制pageview的回调
                                    if (isPageCanChanged) {
                                      onPageChange(index);
//                                      setState(() {
//                                        //backgroundColor = colorsByPage[index];
//                                      });
                                    }
                                  },
                                  controller: mPageController,
                                  itemBuilder: (BuildContext context, int index) {
                                    return getPageItem(index);
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //item布局
  Widget getPageItem(int index) {
    return new SizedBox.expand(
      child: new Padding(
        padding: new EdgeInsets.only(
            left: 16.0, right: 16.0, top: 16.0, bottom: 32.0),
        child: new Material(
          color: Colors.white,
          elevation: 10.0,
          borderRadius: new BorderRadius.circular(8.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            //  new Hero(tag: 'Image', child: new Image.asset('res/img1.png')),
              new Container(
                height: 140.0,
                color: colorsByPage[Random().nextInt(4)],
              ),
              new Padding(
                padding: new EdgeInsets.all(16.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Hero(
                          tag: 'Title',
                          child: new Text('生命不息，奋斗不止，万事起于忽微，量变引起质变',
                              style: new TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                        ),
                        new Text('鸿洋',
                            style: new TextStyle(fontSize: 16.0)),
                      ],
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 8.0),
                      child: new Material(
                        color: colorsByPage[0],
                        borderRadius: new BorderRadius.circular(64.0),
                        child: new InkWell(
                          onTap: (){
//                            Navigator.of(context).push(
//                            new MaterialPageRoute(
//                              builder: (_) {
//                                return new DetailWebPage(web_title: "百度", web_url: "https://www.baidu.com");
//                              },
//                            ),
//                          );
                          getArticle();
                          },
                          child: new Container(
                            margin: new EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 40.0),
                            child: new Text('进入',
                                style: new TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  //获取公众号数据
  void getArticle(){
    String wxArticle = Api.wxArticle;
    NetUtils.get(wxArticle, (data){
      List temp = data;
      for (var i = 0; i < temp.length; i++) {
        var item = temp[i];
        ArticleModel articleModel = new ArticleModel(item);
        articleModels.add(articleModel);
        tabList.add(new TabTitle(articleModel.name, i+1));
      }
      setState(() {
        mPageController = new PageController(initialPage: 0);
        //tabController 长度 接口获取
        tabController = TabController(
          length: tabList.length,
          vsync: this,
        );
        //添加监听
        tabController.addListener(() {
          if (tabController.indexIsChanging) {
            //判断TabBar是否切换
            onPageChange(tabController.index, p: mPageController);
          }
        });
      });
    },errorCallBack: (data){
       print(data);
    });
  }
}
