import 'package:flutter/material.dart';
import 'package:wanandroid/api/Api.dart';
import 'package:wanandroid/utils/NetUtils.dart';
import 'package:wanandroid/utils/ToastUtils.dart';
import 'package:wanandroid/widget/FootListViewWidget.dart';
import 'package:wanandroid/res/StyleTheme.dart';
import 'package:wanandroid/res/ResColors.dart';
import 'package:wanandroid/widget/HtmlWidget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OfficialDetailPage extends StatefulWidget {
  //公众号id
  int wxArticleId;

  OfficialDetailPage(this.wxArticleId);

  State<StatefulWidget> createState() {
    return new OfficialDetailPageState(wxArticleId);
  }
}

class OfficialDetailPageState extends State<OfficialDetailPage>
    with SingleTickerProviderStateMixin {
  //当前页
  var currentPage = 0;

  //公众号对应的id
  int wxArticleId;

  //构造函数
  OfficialDetailPageState(this.wxArticleId);

  //得到的公众号数据
  List officialListData = new List();

  //总页数
  int totalSize = 0;

  //数据总条数
  int listTotalSize = 0;

  //先默认false
  bool isCollect = false;

  AnimationController animationController;
  ScrollController scrollController;
  Animation<Color> colorTween1;
  Animation<Color> colorTween2;

  final double statusBarSize = 24.0;
  final double imageSize = 264.0;

  double readPerc = 0.0;

  @override
  void initState() {
    super.initState();
    //获取公众号数据
    //getWxArticleHistroy();

    // Create the appbar colors animations
    animationController = new AnimationController(
        duration: new Duration(milliseconds: 500), vsync: this);
    animationController.addListener(() => setState(() {}));

    colorTween1 =
        new ColorTween(begin: Colors.black12, end: new Color(0xFF0018C8))
            .animate(new CurvedAnimation(
                parent: animationController, curve: Curves.easeIn));
    colorTween2 =
        new ColorTween(begin: Colors.transparent, end: new Color(0xFF001880))
            .animate(new CurvedAnimation(
                parent: animationController, curve: Curves.easeIn));

    scrollController = new ScrollController();
    scrollController.addListener(() {
      setState(() => readPerc =
          scrollController.offset / scrollController.position.maxScrollExtent);

      // 改变状态栏颜色
      if (scrollController.offset > imageSize - statusBarSize) {
        if (animationController.status == AnimationStatus.dismissed)
          animationController.forward();
      } else if (animationController.status == AnimationStatus.completed)
        animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//        appBar: new AppBar(
//          backgroundColor: ResColors.colorRed,
//          title: new Text(
//              "鸿洋",
//            style: TextStyle(
//            color:ResColors.colorWhite,
//            fontSize: 16.0,
//            fontWeight: FontWeight.bold,
//          ),
//          ),
//        ),

      body: new Material(
        child: new Stack(
          children: <Widget>[
//            new ListView.builder(
//                //把状态栏顶上去
//                padding: new EdgeInsets.all(0.0),
//                itemCount: 10,
//                controller: scrollController,
//                itemBuilder: (context, i) {
//                  return getListViewItemWidget(i);
//                }),
            new OrientationBuilder(
              builder: (context, orientation) => _buildList(
                  context,
                  orientation == Orientation.portrait
                      ? Axis.vertical
                      : Axis.horizontal),
            ),
            new Align(
              alignment: Alignment.topCenter,
              child: new SizedBox.fromSize(
                size: new Size.fromHeight(90.0),
                child: new Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    new SizedBox.expand // If the user scrolled over the image
                        (
                      child: new Material(
                        color: colorTween1.value,
                      ),
                    ),
                    new SizedBox.fromSize // TODO: Animate the reveal
                        (
                      size: new Size.fromWidth(
                          MediaQuery.of(context).size.width * readPerc),
                      child: new Material(
                        color: colorTween2.value,
                      ),
                    ),
                    new Align(
                        alignment: Alignment.center,
                        child: new SizedBox.expand(
                          child:
                              new Material // So we see the ripple when clicked on the iconbutton
                                  (
                            color: Colors.transparent,
                            child: new Container(
                                margin: new EdgeInsets.only(top: 24.0),
                                // For the status bar
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new IconButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      icon: new Icon(Icons.arrow_back,
                                          color: Colors.white),
                                    ),
//                                  new Hero
//                                    (
//                                      tag: 'Logo',
//                                      child: new Icon(Icons.account_circle, color: Colors.white, size: 48.0)
//                                  ),
                                    new IconButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      icon: new Icon(Icons.format_align_right,
                                          color: Colors.white),
                                    ),
                                  ],
                                )),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //获取文章历史
  void getWxArticleHistroy() {
    String wxDetailArticleUrl = Api.histroyWxArticle;
    //下面要拼接url
    wxDetailArticleUrl =
        wxDetailArticleUrl + "$wxArticleId" + "/" + "$currentPage";
    NetUtils().get(wxDetailArticleUrl, (data) {
      //返回的数据
      if (data != null) {
        Map<String, dynamic> map = data;
        //下面只取datas部分
        //详细信息
        List _tempListData = map['datas'];
        //获取总页数
        listTotalSize = map['total'];
        setState(() {
          //最后的结果
          List wxHistroyLists = new List();
          if (currentPage == 0) {
            officialListData.clear();
          }
          currentPage++;
          //把之前的加上
          wxHistroyLists.addAll(officialListData);
          //再加上新的
          wxHistroyLists.addAll(_tempListData);
          //要判断List总数是否大于等于实际数据
          if (wxHistroyLists.length >= listTotalSize) {
            //这里添加标识没有数据
            wxHistroyLists.add("notData");
          }
          //officialListData是最终的结果
          officialListData = wxHistroyLists;
        });
      }
    }, errorCallBack: (msg) {
      //错误回调
      ToastUtils.showLongCenterToast(context, msg);
    });
  }

  //构建ListView列表项
  Widget _buildList(BuildContext context, Axis direction) {
    return new ListView.builder(
        //把状态栏顶上去
        padding: new EdgeInsets.all(0.0),
        //设置排列方式
        scrollDirection: direction,
        itemCount: 10,
        controller: scrollController,
        itemBuilder: (context, i) {
          final Axis slidableDirection =
              direction == Axis.horizontal ? Axis.vertical : Axis.horizontal;
          //这里要做判断
          if (i == 0) {
            return getHeadWidget();
          } else {
            return _getSlidableWithDelefates(context, i, slidableDirection);
          }
          //  return getListViewItemWidget(i);
        });
  }

  //构建ListView列表项
  Widget _getSlidableWithDelefates(
      BuildContext context, int index, Axis direction) {
    // var _item = officialListData[index];

    return new Slidable.builder(
      //key是必须的
      key: new Key("111"),
      direction: direction,
      slideToDismissDelegate: new SlideToDismissDrawerDelegate(
          closeOnCanceled: false,
          onDismissed: (actionType) {
            _showSnackBar(
                context,
                actionType == SlideActionType.primary
                    ? 'Dismiss Archive'
                    : 'Dismiss Delete');
            //更新状态
            setState(() {});
          }),
      //孩子布局
      child: getNormalItemWidget(index),
      delegate: _getDelegate(index),
      actionExtentRatio: 0.25,
      actionDelegate: new SlideActionBuilderDelegate(
        actionCount: 2,
        builder: (context, index, animation, renderingMode) {
          //左边第一个 从0开始
          if (index == 0) {
            return new Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: new IconSlideAction(
                caption: 'Archive',
                color: renderingMode == SlidableRenderingMode.slide
                    ? Colors.blue.withOpacity(animation.value)
                    : (renderingMode == SlidableRenderingMode.dismiss
                        ? Colors.blue
                        : Colors.green),
                icon: Icons.archive,
                onTap: () async {
                  var state = Slidable.of(context);
                  //弹窗对话框
                  var dismiss = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return new AlertDialog(
                          title: new Text("删除"),
                          content: new Text("此项将被删除"),
                          actions: <Widget>[
                            new FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: new Text('删除'),
                            ),
                            new FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: new Text("确定"),
                            ),
                          ],
                        );
                      });

                  if (dismiss) {
                    state.dismiss();
                  }
                },
              ),
            );
          } else {
            return new Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: new IconSlideAction(
                caption: '分享',
                color: renderingMode == SlidableRenderingMode.slide
                    ? Colors.indigo.withOpacity(animation.value)
                    : Colors.indigo,
                icon: Icons.share,
                onTap: () => _showSnackBar(context, 'Share'),
              ),
            );
          }
        },
      ),
      secondaryActionDelegate: new SlideActionBuilderDelegate(
        actionCount: 2,
        builder: (context, index, animation, renderingMode) {
          if (index == 0) {
            return new Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: new IconSlideAction(
                caption: "更多",
                color: renderingMode == SlidableRenderingMode.slide
                    ? Colors.grey.shade200.withOpacity(animation.value)
                    : Colors.grey.shade200,
                icon: Icons.more_horiz,
                onTap: () => _showSnackBar(context, '更多'),
                closeOnTap: false,
              ),
            );
          } else {
            return new Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: new IconSlideAction(
                caption: '删除',
                icon: Icons.delete,
                color: renderingMode == SlidableRenderingMode.slide
                    ? Colors.red.withOpacity(animation.value)
                    : Colors.red,
                onTap: () => _showSnackBar(context, '删除'),
              ),
            );
          }
        },
      ),
    );
  }

  //底部弹出框
  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: new Text(text)));
  }

  static SlidableDelegate _getDelegate(int index) {
    return new SlidableDrawerDelegate();
  }

//  //返回List列表数据
//  Widget getListViewItemWidget(int index) {
//    //这里要做判断
//    //得到本项数据
////    var _itemData = officialListData[index];
////    if (index == officialListData.length - 1 &&
////        _itemData.toString() == "notData") {
////      //如果是最后一项 返回数据已经加载完
////      return new FootListViewWidget();
////    }
//    return getNormalItemWidget(index);
//  }

  //返回普通列表数据
  Widget getNormalItemWidget(int index) {
    //如果第一项就返回
//    if (index == 0) {
//      return getHeadWidget();
//    }

    return getNormalWidget(index);
  }

  //首项(也可称为头部)
  Widget getHeadWidget() {
    return SizedBox.fromSize(
      size: new Size.fromHeight(260.0),
      child: new Hero(
        tag: "Image",
        child: new Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: new Image.asset(
            "images/image_official.jpg",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  //非首项
  Widget getNormalWidget(int index) {
    //波浪线点击效果
    return new InkWell(
      onTap: () {},
      child: new Padding(
        //左8 上16 右8 下16
        padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                //安卓头像
                new Image.asset(
                  "images/image_android_circle",
                ),
                //与左边头像距离
                new Expanded(
                  child: new Text(
                    "真·深红骑士",
                    style: StyleTheme.getInstance(context).getTopicStyle(),
                  ),
                ),

                new Text(
                  "开源项目/完整项目",
                  style: StyleTheme.getInstance(context).getBelongStyle(),
                ),
              ],
            ),
            new DefaultTextStyle(
              style: StyleTheme.getInstance(context).getTitleStyle(),
//              softWrap: false,
//              overflow: TextOverflow.ellipsis,
//              maxLines: 3,
              child: Padding(
                child: new HtmlWidget(
                  html: "打造一款极致体验wanandroid",
                  isTitle: 0,
                ),
                padding: const EdgeInsets.only(top: 10.0),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: new Row(
                children: <Widget>[
                  new Icon(isCollect ? Icons.favorite : Icons.favorite_border,
                      color: isCollect ? Colors.red : Colors.grey),
                  new Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: new Icon(
                      Icons.access_time,
                      color: Colors.grey,
                    ),
                  ),
                  new Expanded(
                    child: new Text(
                      "2019-4-10",
                      style: StyleTheme.getInstance(context).getTimeStyle(),
                    ),
                  ),
                  new Container(
                    //设置内容居中
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                      border: new Border.all(
                        color: ResColors.colorRed,
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                    child: new Text(
                      "新",
                      style: new TextStyle(color: ResColors.colorRed),
                    ),
                  ),
                ],
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: new Divider(
                height: 0.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
