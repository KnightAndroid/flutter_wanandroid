import 'package:flutter/material.dart';
import 'package:wanandroid/db/DataBaseHandle.dart';
import 'package:wanandroid/utils/NetUtils.dart';
import 'package:wanandroid/api/Api.dart';
import 'package:wanandroid/res/ResColors.dart';
import 'package:wanandroid/utils/ToastUtils.dart';
import 'package:wanandroid/ui/pages/search/SearchPage.dart';

/**
 * Describe :
 * Created by Knight on 2019/3/17
 * @Version :
 * 点滴之行,看世界
 */

class SearchHotPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SearchHotState();
  }
}

class SearchHotState extends State<SearchHotPage> {
  //历史记录
  List<Widget> historyWidgets = new List();

  //热门搜索
  List<Widget> hotSearchWidgets = new List();

  //如果有历史记录就显示记录 没有就隐藏
  bool haveHistory = true;

  @override
  void initState() {
    //获取热词
    getHotKeyWords();
    //获取历史记录
    getHistoryDb();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        //第一行：搜索记录
        new Offstage(
          offstage: haveHistory,
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Container(
                      padding: const EdgeInsets.fromLTRB(10.0, 16.0, 0.0, 0.0),
                      child: new Text(
                        "搜索记录",
                        style: new TextStyle(color: ResColors.colorGrey),
                      ),
                    ),
                  ),
                  new GestureDetector(
                    child: new Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 10.0, 0.0),
                      child: new Text(
                        "清空记录",
                        style: new TextStyle(color: ResColors.colorBlueAccent),
                      ),
                    ),
                    onTap: (){
                      clearHistoryDb();
                    },
                  ),
                ],
              ),
              //搜索历史的widget
              new Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 16.0, 0.0, 0.0),
                //需要用warp widget
                child: new Wrap(
                  spacing: 5.0, //主轴方向上的间隔，主轴默认水平
                  runSpacing: 5.0, //run间隔，run可以理解为新的行或者列
                  children: historyWidgets,
                ),
              ),
            ],
          ),
        ),
        //热门搜索
        new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.fromLTRB(10.0, 16.0, 10.0, 0.0),
              child: new Text(
                "热门搜索",
                style: new TextStyle(color: ResColors.colorGrey),
              ),
            ),
            new Container(
              padding: const EdgeInsets.fromLTRB(0.0, 16.0, 10.0, 0.0),
              child: new Image(
                image: new AssetImage('images/image_hotsearch.png'),
                width: 20.0,
                height: 20.0,
              ),
            ),
          ],
        ),
        //热门搜索图标
        new Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 16.0, 0.0, 0.0),
          //需要用Wrap
          child: new Center(
            child: new Wrap(
              spacing: 5.0, //主轴方向上的间隔，主轴默认水平
              runSpacing: 5.0, //run间隔，run可以理解为新的行或者列
              children: hotSearchWidgets,
            ),
          ),
        ),
      ],
    );
  }

  //获取历史记录
  void getHistoryDb() {
    DataBaseHandle.queryDetail((data) {
      if (data == null) {
      } else {
        List dataList = data;
        historyWidgets.clear();
        for (var value in dataList) {
          Widget actionChip = new ActionChip(
            avatar: CircleAvatar(
              backgroundColor: ResColors.blue[900],
              child: new Text(
                'WA',
                style: TextStyle(fontSize: 10.0),
              ),
            ),
            label: new Text(
              value['name'],
            ),
            onPressed: () {
              //点击事件
            },
          );
          historyWidgets.add(actionChip);
          haveHistory = false;
//          setState(() {
//
//          });
        }
      }
    }, () {
      //异常处理
      print("查询出错了");
    });
  }

  //获取热门关键字
  void getHotKeyWords() {
    NetUtils.get(Api.hotKeyWords, (data) {
      setState(() {
        //状态更新
        List hotKeydatas = data;
        hotSearchWidgets.clear();
        for (var HotDataItem in hotKeydatas) {
          Widget actionChip = new ActionChip(
              backgroundColor: ResColors.colorBlue,
              avatar: CircleAvatar(
                backgroundColor: ResColors.colorWhite,
                child: Text(
                  'WA',
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
              label: new Text(
                HotDataItem['name'],
                style: new TextStyle(color: ResColors.colorWhite),
              ),
              onPressed: () {
                //插入搜索历史
                insertHistoryDb(HotDataItem['name']);
                Navigator.of(context)
                    .pushReplacement(new MaterialPageRoute(builder: (context) {
                  return new SearchPage(HotDataItem['name']);
                }));
              });
          hotSearchWidgets.add(actionChip);
        }
      });
    }, errorCallBack: (msg) {
      //错误回调方法
      ToastUtils.showLongCenterToast(context, msg);
    });
  }

  //插入历史记录
  void insertHistoryDb(String queryData) {
    DataBaseHandle.addHistoryData(queryData, () {
      print("插入成功");
    }, () {
      print("插入数据库失败");
    });
  }

  //清空记录
  void clearHistoryDb(){
    DataBaseHandle.clearData((){
      haveHistory = true;
      setState(() {

      });
    }, (){
      print("失败");
    });
  }
}
