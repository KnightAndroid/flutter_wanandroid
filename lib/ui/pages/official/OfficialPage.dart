import 'package:flutter/material.dart';
import 'package:wanandroid/res/ResColors.dart';
import 'package:wanandroid/ui/pages/web/DetailWebPage.dart';
import 'package:wanandroid/api/Api.dart';
import 'package:wanandroid/utils/NetUtils.dart';
import 'package:wanandroid/model/ArticleModel.dart';
import 'dart:math';
import 'package:wanandroid/ui/pages/official/OfficialDetailPage.dart';

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


//公众号模型
class Officical{
  //公众号介绍
  String intoduceOfficial;
  //个人名言
  String personalMotto;
  //构造函数
  Officical(this.intoduceOfficial,this.personalMotto);
}

//通过 SingleTickerProviderStateMixin 实现 Tab 的动画切换效果
class OfficialPageState extends State<OfficialPage>
    with SingleTickerProviderStateMixin {
  //每个公众号对应的颜色不一样
//  static final List<Color> colorsByPage = [
//    new Color(0xFF0018C8),
//    new Color(0xFFDD1829),
//    new Color(0xFF0018C5),
//    new Color(0xFF2196F3)
//  ];

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
  //标题
  List<TabTitle> tabList = [];

  //具体数据
  List<ArticleModel> articleModels = [];

  //公众号数据
  List<Officical> officialLists = [];

  @override
  void initState() {
    super.initState();
    print("公众号第一次进入");
    //初始化TabTitle
    initTabData();
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
    officialLists = [
      new Officical("欢迎关注鸿洋的公众号，每天为您推送高质量文章，让你每天都能涨知识。"
          "点击历史消息，查看所有已推送的文章，喜欢可以置顶本公众号。"
          "本公众号支持投稿，如果你有原创的文章，希望通过本公众号发布，欢迎投稿。",
          "生命不息，奋斗不止，万事起于忽微，量变引起质变"),

      new Officical("Android技术分享平台，每个工作日都有优质技术文章推送。"
          "你还可以向公众号投稿，将自己总结的技术心得分享给大家。",
          "每当你在感叹，如果有这样一个东西就好了的时候，请注意，其实这是你的机会..."),

      new Officical("Java、Android、大前端、程序员成长",
          "有创新精神的Android技术分享者"),

      new Officical("我是承香墨影，8 年技术老司机。在这里，主要分享我个人的原创内容，不仅限于技术，职场、产品、设计思想等等，统统都有。"
          "这里已经汇集了有很多小伙伴了，欢迎你加入！", ""),

      new Officical("本公众号是《Android群英传》及《Android群英传:神兵利器》的读者群，同时也是Android开发者交流、分享的地方，欢迎大家关注~",
          "路漫漫其修远兮 吾将上下而求索"),

      new Officical("2 年多的 Android 技术垂直号，深耕安卓技术，挖掘深度，以每天 8:40 的精准高质量推送赢得了同行的认可。随着量的积累，本公众号已开始投稿模式，"
          "欢迎将自己的原创技术文章分享给大家，让更多同行认识你，站在技术的前沿阵地！",
          ""),

      new Officical("Google中国官方账号。汇集 Android, Flutter, Chrome OS, AI 等开发技术，以及 Google Play 平台出海相关信息。", ""),

      new Officical("奇虎360移动端技术号，分享360手机卫士等技术团队在Android、IOS、大数据、AI等各个技术领域的实践经验，原创干货。",""),
      new Officical("10000+工程师，如何支撑中国领先的生活服务电子商务平台？3.2亿消费者、500万商户、2000多个行业、几千亿交易额背后是哪些技术？"
    "这里是美团、大众点评、美团外卖、美团大零售等技术团队的对外窗口，每周推送技术文章、活动及招聘信息等。",""),

      new Officical("GcsSloop，一名2.5次元魔法师。",""),

      new Officical("最懂你的程序员在这里，我们不仅聊技术，我们还聊情感，聊人生。",""),

      new Officical("个人技术文章、日常分享",""),

      new Officical("阿里巴巴-资深无线工程师，主攻 Android、偶尔分享些其他的，可能会是读书、大前端、思考、职场、认知，希望对你「进阶高级工程师」有所帮助。",""),

      new Officical("Android系统架构设计、内核技术实践以及工作心得分享，Gityuan匠心打造！","")

    ];
  }

  @override
  Widget build(BuildContext context) {
    //设置home
    return new Scaffold(
      //backgroundColor: backgroundColor,
      //让组件尽可能占用布局就ok
      body: tabList == null || tabList.length == 0
          ? new Center(
              child: new CircularProgressIndicator(),
            )
          : new SizedBox.expand(
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
                                        itemBuilder:
                                            (BuildContext context, int index) {
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
    //  return new SizedBox.expand(
//    return new GestureDetector(
//      onTap: (){
//
//      },
      return new InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder:(webPage){
            return new OfficialDetailPage(407);
          }),
          );
        },
        child:  new SingleChildScrollView(
          child: new Padding(
            padding: new EdgeInsets.only(
                left: 16.0, right: 16.0, top: 16.0, bottom: 20.0),
            child: new Material(
              color: Colors.white,
              elevation: 10.0,
              borderRadius: new BorderRadius.circular(8.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //  new Hero(tag: 'Image', child: new Image.asset('res/img1.png')),
                  //这里设置hero共享动画
                  new Hero(
                      tag: "Image",
                      child: new Container(
                        //设置内容居中
                        alignment: Alignment.center,
                        //设置内边距
                        padding: const EdgeInsets.all(10.0),
                        // height: 140.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("images/image_official.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        //color: colorsByPage[Random().nextInt(4)],
                        child: new Text(
                          officialLists[index].intoduceOfficial,
                          //文字对齐方式
                          textAlign: TextAlign.justify,
                          style: new TextStyle(color: ResColors.colorWhite),
                        ),
                      ),
                  ),


                  new Padding(
                    padding: new EdgeInsets.all(10.0),
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
                              child: new Text(officialLists[index].personalMotto,
                                  style: new TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600)),
                            ),
                            new Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 10.0, 0.0, 4.0)),
//                      new Text('鸿洋',
//                        style: new TextStyle(
//                            fontSize: 20.0,
//                            fontWeight: FontWeight.bold,
//                            color: ResColors.colorBlue),
//                      ),
                          ],
                        ),
//                  new Padding(
//                    padding: new EdgeInsets.only(top: 30.0),
//                    child: new Material(
//                      color: colorsByPage[0],
//                      borderRadius: new BorderRadius.circular(64.0),
//                      child: new InkWell(
//                        onTap: (){
////                            Navigator.of(context).push(
////                            new MaterialPageRoute(
////                              builder: (_) {
////                                return new DetailWebPage(web_title: "百度", web_url: "https://www.baidu.com");
////                              },
////                            ),
////                          );
//                          getArticle();
//                        },
//                        child: new Container(
//                          margin: new EdgeInsets.symmetric(
//                              vertical: 14.0, horizontal: 40.0),
//                          child: new Text('进入',
//                              style: new TextStyle(
//                                  fontWeight: FontWeight.w300,
//                                  color: Colors.white)),
//                        ),
//                      ),
//                    ),
//                  )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );










    //   );
  }

  //获取公众号数据
  void getArticle() {
    String wxArticle = Api.wxArticle;
    NetUtils().get(wxArticle, (data) {
      List temp = data;
      for (var i = 0; i < temp.length; i++) {
        var item = temp[i];
        ArticleModel articleModel = new ArticleModel(item);
        articleModels.add(articleModel);
        tabList.add(new TabTitle(articleModel.name, i + 1));
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
    }, errorCallBack: (data) {
      // 打印错误信息
      print(data);
    });
  }


  @override
  void dispose() {
    super.dispose();
    mPageController.dispose();
    tabController.dispose();
  }
}
