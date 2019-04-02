import 'package:flutter/material.dart';
import 'package:wanandroid/ui/pages/search/SearchResultListPage.dart';
import 'package:wanandroid/ui/pages/search/SearchHotPage.dart';
import 'package:wanandroid/res/ResColors.dart';
import 'package:wanandroid/db/DataBaseHandle.dart';
/**
 * Describe :
 * Created by Knight on 2019/3/19
 * @Version :
 * 点滴之行,看世界
 */

class SearchPage extends StatefulWidget {

  String searchContent;
  SearchPage(this.searchContent);

  @override
  State<StatefulWidget> createState() {
    return new SearchPageState(searchContent);
  }
}

class SearchPageState extends State<SearchPage> {
  //编辑框文本输入
  TextEditingController _controller;
  //要搜索的关键字
  String searchContent;
  //搜索结果页
  SearchResultListPage searchResultListPage;
  SearchPageState(this.searchContent);


  @override
  void initState(){
     super.initState();
     _controller = new TextEditingController(text:searchContent);
     searchGoPage();
  }

  @override
  Widget build(BuildContext context) {
    bool isHotPage = (_controller.text == null || _controller.text.length == 0) ? true:false;
    return new Scaffold(
      appBar: new AppBar(
        title: initText(),
        actions: <Widget>[
          //搜索按钮
          new IconButton(
            icon:new Icon(Icons.search),
            onPressed: (){
              //点击事件
              searchGoPage();
              //插入数据
              insertHistoryDb(_controller.text);
            },
          ),
          //清除按钮
          new IconButton(
            icon:new Icon(Icons.close),
            onPressed: (){
              //把编辑文本输入清干净
              setState(() {
                _controller.clear();
              });
            },
          ),
        ],
      ),
      body: (isHotPage) ? new Center(child: new SearchHotPage()):searchResultListPage,
    );
  }




  //初始化搜索栏
  TextField initText(){
    return new TextField(
      autofocus: true,//自动获得焦点
      cursorColor: ResColors.colorWhite,//光标颜色
      style: new TextStyle(color: ResColors.colorWhite),
      decoration: new InputDecoration(
        border: InputBorder.none,
        fillColor: ResColors.colorWhite,
        hintText: "请输入要搜索的关键词",
        hintStyle: new TextStyle(color: ResColors.colorWhite),
      ),
      controller: _controller,//绑定控制器
    );
  }

  //本页改变
  void searchGoPage(){
    //查询结果以列表形式显示
    setState(() {
      String text = _controller.text;
      searchResultListPage = new SearchResultListPage(text);
    });

  }


  //插入历史记录
  void insertHistoryDb(String queryData) {
    DataBaseHandle.addHistoryData(queryData, () {


    }, () {
      print("插入数据库失败");
    });
  }

}
