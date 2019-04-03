import 'package:flutter/material.dart';
import 'package:wanandroid/api/Api.dart';
import 'package:wanandroid/utils/NetUtils.dart';
import 'package:wanandroid/utils/ToastUtils.dart';
import 'package:wanandroid/widget/FootListViewWidget.dart';
import 'package:wanandroid/res/StyleTheme.dart';
import 'package:wanandroid/res/ResColors.dart';
import 'package:wanandroid/widget/HtmlWidget.dart';
import 'package:wanandroid/ui/pages/web/DetailWebPage.dart';

/**
 * Describe :
 * Created by Knight on 2019/3/17
 * @Version :
 * 点滴之行,看世界
 */

class SearchResultListPage extends StatefulWidget {
  //从热门搜索页传递过来
  String searchContent;

  SearchResultListPage(this.searchContent);

  @override
  State<StatefulWidget> createState() {
    return new SearchResultListPageState(searchContent);
  }
}

class SearchResultListPageState extends State<SearchResultListPage> {
  //搜索关键字
  String searchContent;

  //当前页
  int currentPage = 0;

  //因为搜索是post请求，所依用map形式
  Map<String, String> map = new Map();

  //得到的数据
  List resultData = new List();


  int listTotalSize = 0;

  SearchResultListPageState(this.searchContent);

  //滚动监听
  ScrollController _scrollController;

  //先默认false
  bool isCollect = false;

  @override
  void initState() {
    super.initState();


    addListener();
    searchQuery();
  }

  @override
  Widget build(BuildContext context) {
    //如果数据为空 则显示加载圈
    if (resultData == null || resultData.isEmpty) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      //如果不为空
      return new RefreshIndicator(
          child: new ListView.builder(
              itemCount: resultData.length, //数据长度
              controller: _scrollController,
              itemBuilder: (context, i) {
                return getItemWidget(i);
              }),
          onRefresh: onRefreshData);
    }
    //如果不为空
  }

  //普通列表部分
  Widget leftTimelineBuilder(int i) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //顶部圆形
        new Container(
          padding: EdgeInsets.only(left: 20.0),
          child: new SizedBox(
            width: 32.0,
            height: 32.0,
            child: new CircleAvatar(
              backgroundColor: ResColors.colorWhite,
              backgroundImage:
                  ExactAssetImage("images/image_time_progress.png"), //圆形图像
            ),
          ),
        ),

        //下面部分
        new Row(
          children: <Widget>[
            //线段
            new Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 5.0, 16.0, 5.0),
                  child: new Container(
                    color: ResColors.colorBlue,
                    width: 2,
                    height: 40,
                  ),
                ),
                new Container(
                  width: 75.0,
                  //  padding: EdgeInsets.only(left: 4.0,right: 4.0),
                  child: new Center(
                    child: new Text(
                      resultData[i]['niceDate'],
                      style: StyleTheme.getInstance(context).getTimeStyle(),
                    ),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 5.0, 16.0, 5.0),
                  child: new Container(
                    color: ResColors.colorBlue,
                    width: 2,
                    height: 40,
                  ),
                ),
              ],
            ),

            //card部分
            new Expanded(
              child: new Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 14.0, 0.0),
                //Card开始
                child: new Card(
                  elevation: 2.0,
                  child: new InkWell(
                    onTap: () {
                      _onItemClick(i);
                    },
                    child: new Container(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                      child: new Stack(
                        children: <Widget>[
                          new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Row(
                                textBaseline: TextBaseline.alphabetic,
                                textDirection: TextDirection.ltr,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
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
                                  new Expanded(
                                    child: new Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 5.0, 0.0, 0.0),
                                      child: new Text(
                                        resultData[i]['author'],
                                        style: StyleTheme.getInstance(context)
                                            .getSpeakNameStyle(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              //主体内容
                              new DefaultTextStyle(
                                style: StyleTheme.getInstance(context)
                                    .getDescriptStyle(),
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                child: Padding(
                                  child: new HtmlWidget(
                                    html: resultData[i]['desc'] == ""
                                        ? resultData[i]['title']
                                        : resultData[i]['desc'],
                                    isTitle: 1,
                                  ),
                                  padding: const EdgeInsets.only(
                                      top: 12.0, bottom: 8.0),
                                ),
                              ),
                              //右下角的图标
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Expanded(
                                    child:
                                    new HtmlWidget(
                                      html:resultData[i]['chapterName'] +
                                          "/" +
                                          resultData[i]['superChapterName'],
                                      isTitle: 2,
                                    ),



//                                    new Text(
//                                      resultData[i]['chapterName'] +
//                                          "/" +
//                                          resultData[i]['superChapterName'],
//                                      style: StyleTheme.getInstance(context)
//                                          .getTopicStyle(),
//                                    ),
                                  ),
                                  new Icon(
                                    Icons.share,
                                    color: Colors.grey,
                                  ),
                                  new Container(
                                    padding: const EdgeInsets.only(right: 8.0),
                                  ),
                                  new Icon(
                                      isCollect
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color:
                                          isCollect ? Colors.red : Colors.grey),
                                ],
                              ),
                            ],
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
      ],
    );
  }

  //ListView itemView
  Widget getItemWidget(int i) {
    //得到本项数据
    var _itemData = resultData[i];
    if (i == resultData.length - 1 && _itemData.toString() == "notData") {
      //如果是最后一项 返回数据已经加载完
      return new FootListViewWidget();
    }
    //普通布局
    return leftTimelineBuilder(i);
  }


  //设置监听
  void addListener() {
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      var maxScroll = _scrollController.position.maxScrollExtent;
      var pixels = _scrollController.position.pixels;
      print(maxScroll);
      print(pixels);
      if (maxScroll == pixels && resultData.length < listTotalSize) {
        //这里是滚动到底 并且数据页数没有达到总页数
        searchQuery();
      }
    });


  }

  //下拉刷新
  Future<Null> onRefreshData() async {
    //重置当前页数
    currentPage = 0;
    searchQuery();
  }

  //获得搜索数据
  void searchQuery() {
    print("请求了");
    String url = Api.searchQuery;
    //因为格式是：https://www.wanandroid.com/article/query/0/json
    //所以要加上/0/json
    url = url + "$currentPage/json";
    print(url);
    //带上搜索参数
    map['k'] = searchContent;
    //post请求
    NetUtils.post(
        url,
        (data) {
          //如果数据不为空
          if (data != null) {
            //这里为了取具体数据datas和总页数
            Map<String, dynamic> map = data;
            //取总页数
            listTotalSize = map['total'];
            //取具体数值
            var _datas = map['datas'];
            setState(() {
              //中间数据
              List tempList = new List();
              if (currentPage == 0) {
                resultData.clear();
              }
              //当页面数据获取成功后，当前页要加一
              currentPage++;
              tempList.addAll(resultData);
              tempList.addAll(_datas);
              //这里要判断集合的总数是否大于数据的总数
              if (tempList.length >= listTotalSize) {
                //如果是
                tempList.add("notData");
              }
              //resultData是最终数据
              resultData = tempList;
            });
          }
        },
        params: map,
        errorCallBack: (msg) {
          //错误回调方法
          print(msg);
          ToastUtils.showLongCenterToast(context, msg);
        });
  }


  //点击事件
  //item点击触发
  _onItemClick(int pos) {
    Navigator.push(context, MaterialPageRoute(builder:(webPage){
      return new DetailWebPage(web_title: resultData[pos]['title'], web_url: resultData[pos]['link']);
    }),
    );
  }


  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
