import 'package:flutter/material.dart';
import 'package:wanandroid/ui/pages/me/MePage.dart';
import 'package:wanandroid/ui/pages/home/HomePage.dart';
import 'package:wanandroid/ui/pages/project/ProjectPage.dart';
import 'package:wanandroid/ui/pages/official/OfficialPage.dart';
import 'package:wanandroid/ui/pages/navigation/NavigationPage.dart';
import 'package:wanandroid/ui/pages/search/SearchPage.dart';
import 'package:wanandroid/db/DataBaseHandle.dart';
import 'package:wanandroid/res/ResColors.dart';




class MainPage extends StatefulWidget{


  @override
  State<StatefulWidget> createState(){
     return new MainPageState();
  }


}



class MainPageState extends State<MainPage> with TickerProviderStateMixin{

  //appbar标题显示
  List mainTitles = ['首页','项目','公众号','导航','我的'];
  //索引
  int indexPosition = 0;
  //那一页
  var indexStack;
  //导航栏的图标显示
  final Map bottomMap = {
    "首页":Icon(Icons.home),
    "项目":Icon(Icons.pie_chart),
    "公众号":Icon(Icons.mms),
    "导航":Icon(Icons.navigation),
    "我的":Icon(Icons.perm_identity),
  };

  void _onTapBottom(int position){
     indexPosition = position;
     setState(() {

     });

  }
  @override
  void initState(){
    super.initState();
    //创建数据库表
    DataBaseHandle.cratedb_table((data){
      print("创建数据库成功");
    },(){
      print("创建数据库失败");
    });

  }
  //底部导航栏
  Widget bottomNavigationBar(Map bottomMaps,int _currentIndex){
    return BottomNavigationBar(
        items:(){
          var items = <BottomNavigationBarItem>[];
          bottomMaps.forEach((k,v){
            items.add(BottomNavigationBarItem(
              //文字显示
              title: Text(k),
              //图标
              icon: v,
              backgroundColor: ResColors.colorBlue,
            )
            );
          });
          return items;
        }(),
        currentIndex: _currentIndex,
        onTap:_onTapBottom


    );

  }
  //侧滑菜单
  Widget drawerLayout = Drawer(
     child: ListView(
       //加上这句 解决侧滑拉出白色状态栏
       padding: EdgeInsets.all(0.0),
       children: <Widget>[
         UserAccountsDrawerHeader(
           accountName: Text("真·深红骑士"),
           accountEmail: Text("novaknight@gmail.com"),
           currentAccountPicture: new GestureDetector(
             child: CircleAvatar(
               backgroundImage: new ExactAssetImage("images/image_user.jpeg"),
             ),
           ),
           decoration: new BoxDecoration(
             image: new DecorationImage(
                   fit:BoxFit.fill,
                   image: new ExactAssetImage("images/drawLayout_top.jpg"),
             )
           ),

         ),
         new ListTile(
           title: Text("收藏"),
           leading: Icon(Icons.favorite),
         ),

         new ListTile(
           title: Text("设置"),
           leading: Icon(Icons.settings),
         ),

         new ListTile(
           title: Text("关于"),
           leading: Icon(Icons.perm_identity),
         ),
         //添加分割线
         new Divider(),
         new ListTile(
           title: Text("退出"),
           leading: Icon(Icons.exit_to_app),
         ),
       ],
     ),
  );



  @override
  Widget build(BuildContext context){
      initData();
      //设置home
      return new Scaffold(
        //设置appBar
        appBar: new AppBar(
          title: new Text(
            //当导航栏点击到哪一项，appbar标题对应显示什么内容
            mainTitles[indexPosition],
            //字体样式
            style: TextStyle(
              color:ResColors.colorWhite,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          //appBar添加搜索按钮
          actions: <Widget>[
            IconButton(
              //图标
              icon:Icon(Icons.search,
               color: ResColors.colorWhite,
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder:(webPage){
                  return new SearchPage(null);
                }),
                );
              },
            ),
          ],
        ),
        //底部导航栏
        bottomNavigationBar: bottomNavigationBar(bottomMap, indexPosition),
        //侧滑菜单栏
        drawer: drawerLayout,
        body: indexStack,
      );

  }

  initData(){
    indexStack = new IndexedStack(
      children: <Widget>[new HomePage(),new ProjectPage(),new OfficialPage(),new NavaigationPage(),new MePage()],
      index: indexPosition,
    );
  }



}






