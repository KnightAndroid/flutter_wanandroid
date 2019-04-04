import 'package:flutter/material.dart';
import 'package:wanandroid/api/Api.dart';
import 'package:wanandroid/utils/NetUtils.dart';
import 'package:wanandroid/utils/ToastUtils.dart';
import 'package:wanandroid/view/banner/BannerDataModel.dart';
import 'package:wanandroid/view/banner/ListPage.dart';
import 'package:wanandroid/view/banner/BannerWidget.dart';
import 'package:wanandroid/ui/pages/web/DetailWebPage.dart';
import 'package:wanandroid/res/ResColors.dart';
import 'package:wanandroid/widget/FootListViewWidget.dart';
import 'package:wanandroid/res/StyleTheme.dart';
import 'package:wanandroid/widget/HtmlWidget.dart';


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  //获取banner数据
  List bannerList = [];
  List<BannerDataModel> banner = [];

  //ListView 普通数据
  List normalList = new List();

  BannerWidget bannerWidget;
  bool isCollect = false;

  //滑动底部控制
  ScrollController _scrollController;
  //当前页数
  int currentPage = 0;
  //总条数
  int listTotalSize = 0;

  //是否显示回到顶部的按钮图标
  bool isShowGoTop = false;

  //初始化操作
  @override
  void initState() {
    super.initState();
    print("第一次进入首页");
    _scrollController = new ScrollController();
    //添加滚动监听事件
    _scrollController.addListener(() {
      var maxScroll = _scrollController.position.maxScrollExtent;
      var pixels = _scrollController.position.pixels;
      if (maxScroll == pixels && normalList.length < listTotalSize) {
         getHomeItem();
      }

      //如果滚动位置
      if(_scrollController.offset < 180 && isShowGoTop){
         setState(() {
           isShowGoTop = false;
         });
      } else if(_scrollController.offset >= 180 && !isShowGoTop){
        setState(() {
          isShowGoTop = true;
        });
      }



    });
    //获取轮播图
    getBanner();
    //获取首页文章列表信息
    getHomeItem();
  }

  //获取banner轮播图
  void getBanner() {
    String bannerUrl = Api.bannerUrl;

    //请求接口 获取数据
    NetUtils().get(bannerUrl, (data) {
      if (data != null) {
        bannerList = data;
        banner.clear();
        for (var i = 0; i < bannerList.length; i++) {
          var item = bannerList[i];
          BannerDataModel bannerDataModel =
          new BannerDataModel(url: item['imagePath'], title: item['title'],banner_url: item['url']);
          banner.add(bannerDataModel);
        }
        bannerWidget = new BannerWidget(bannerModel: banner);
        setState(() {


        });
      }
    }, errorCallBack: (msg) {
      //错误回调方法
      ToastUtils.showLongCenterToast(context, msg);
    });
  }

  void getHomeItem() {
    String article_list = Api.articleList;
    article_list = article_list + "$currentPage/json";
    print(article_list);
    NetUtils().get(article_list, (data) {
      //获取首页列表信息
      if (data != null) {
        Map<String, dynamic> map = data;
        //详细信息
        List _tempListData = map['datas'];
        //总条数
        listTotalSize = map['total'];
        setState(() {
          //最后的结果List
          List resultList = new List();
          if (currentPage == 0) {
            //先把之前的数据清掉
            normalList.clear();
          }
          currentPage++;
          //把之前的加上
          resultList.addAll(normalList);
          //再把新请求的加上
          resultList.addAll(_tempListData);
          //这里要判断是否大于总数
          if (resultList.length >= listTotalSize) {
            resultList.add("notData");
          }
          normalList = resultList;
        });
      }
    }, errorCallBack: (msg) {
      //错误回调方法
      ToastUtils.showLongCenterToast(context, msg);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (normalList == null || normalList.length == 0) {
      return Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      //设置home
      return new Scaffold(
        body: RefreshIndicator(
            child: new ListPage(
              normalList,
              headerList: [1],
              mController: _scrollController,
              itemWidgetBuild: getItemWidget,
              headerWidgetBuild: (BuildContext context, int position) {
                if (position == 0) {
                  return bannerWidget;
                } else {
                  //第二个头部
                  return new Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('$position -----header------- '),
                  );
                }
              },
            ),
            onRefresh: onRefresh),
        floatingActionButton:
          !isShowGoTop
          ? null
          : FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor.withAlpha(180),
            child: Icon(Icons.arrow_upward),
            onPressed: () {
              _scrollController.animateTo(0,
                  duration: Duration(milliseconds: 300), curve: Curves.linear);
            }),
      );
    }
  }

  //列表样式
  Widget getItemWidget(BuildContext context, int pos) {
    var _itemData = normalList[pos];
    //如果是最后的数据底部 那就返回添加底部
    if(_itemData is String && _itemData == "notData"){
      return new FootListViewWidget();
    }
    final ThemeData theme = Theme.of(context);
    //时间样式
//    final TextStyle timeStyle = theme.textTheme.caption.merge(
//      const TextStyle(
//        fontWeight: FontWeight.bold,
//      ),
//    );

    final TextStyle timeStyle = StyleTheme.getInstance(context).getTimeStyle();
    //标题样式
    final TextStyle titleStyle = StyleTheme.getInstance(context).getTitleStyle();

    //描述样式
    final TextStyle descriptionStyle = StyleTheme.getInstance(context).getDescriptStyle();
    //主题样式
    final TextStyle topicStyle = StyleTheme.getInstance(context).getTopicStyle();
    //作者名字样式
    final TextStyle speakerNameStyle = StyleTheme.getInstance(context).getSpeakNameStyle();
    // TODO: implement build
    return new Card(
      elevation: 2.0,
      child: new InkWell(
        onTap: () {
          _onItemClick(pos);
        },
        child: new Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
          child: new Stack(
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Text(
                          normalList[pos]['niceDate'],
                          style: timeStyle,
                        ),
                      ),
                      new Text(
                        normalList[pos]['chapterName'] + "/" + normalList[pos]['superChapterName'],
                        style: topicStyle,),
                    ],
                  ),

                  new Container(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: new HtmlWidget(
                      html:normalList[pos]['title'],
                      isTitle: 0,
                       // style: titleStyle,

                    )
                  ),
                  new DefaultTextStyle(
                    style: descriptionStyle,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    child: Padding(
                        child: new HtmlWidget(
                          html: normalList[pos]['desc'] == ""
                              ? normalList[pos]['title']
                              : normalList[pos]['desc'],
                          isTitle: 1,
                        ),
                      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                    ),
                  ),
//                  new Row(
//                    children: <Widget>[
//                      new Container(
//                        width: 24.0,
//                        height: 24.0,
//                        margin: const EdgeInsets.only(right: 8.0),
//                        decoration: new BoxDecoration(
//                          image: new DecorationImage(
//                            image:
//                                new AssetImage("images/image_author_logo.png"),
//                            fit: BoxFit.cover,
//                          ),
//                        ),
//                      ),
//                      new Expanded(
//                        child: new Text(
//                          "This is one",
//                          style: topicStyle,
//                        ),
//                      ),
//                    ],
//                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: new Column(
                      children: <Widget>[
                        new Container(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: new Row(
                            children: <Widget>[
                              new SizedBox(
                                width: 32.0,
                                height: 32.0,
                                child: new CircleAvatar(
                                  backgroundColor: ResColors.colorWhite,
                                  backgroundImage: ExactAssetImage(
                                      "images/image_author_logo.png"),
                                ),
                              ),
                              new Container(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: new Text(
                                  normalList[pos]['author'],
                                  style: speakerNameStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              new Positioned(
                bottom: 1.0,
                right: 2.0,
                child: new Icon(
                    isCollect ? Icons.favorite : Icons.favorite_border,
                    color: isCollect ? Colors.red : Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //item点击触发
  _onItemClick(int pos) {
    Navigator.push(context, MaterialPageRoute(builder:(webPage){
      return new DetailWebPage(web_title: normalList[pos]['title'], web_url: normalList[pos]['link']);
    }),
    );
  }

  //刷新控件
  Future<Null> onRefresh() async {
    currentPage = 0;
//    banner.clear();
    getBanner();
    getHomeItem();
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
