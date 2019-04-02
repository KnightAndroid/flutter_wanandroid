import 'package:flutter/material.dart';
import 'package:wanandroid/ui/pages/login/LoginPage.dart';
import 'package:wanandroid/utils/UserMessageUtils.dart';
import 'package:wanandroid/res/ResColors.dart';




class MePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState(){
    return new MePageState();
  }
}



class MePageState extends State<MePage>{
  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;

  var titles = ["我的消息","阅读记录","我的博客","我的活动","我的团队","邀请好友"];
  var imagePaths = [Icons.message,Icons.receipt,Icons.book,Icons.notifications_active,Icons.add,Icons.share];

  var icons = [];

  MePageState(){
    for(int i = 0;i < imagePaths.length;i++){
      icons.add(getIconImage(imagePaths[i]));
    }
  }

  //头像
  String userAvator = "https://user-gold-cdn.xitu.io/2018/11/16/1671c652ceb8a58a?imageView2/1/w/64/h/64/q/85/interlace/1";
  //用户名
  String userName;


  @override
  void initState(){
    super.initState();
    //获取登录信息
    getUserInfo();

  }






  //设置Icons的资源 宽高
  Widget getIconImage(path){
    return new Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 0),
    child: Icon(path,color: ResColors.colorGrey,),
    );
  }

  //右图标
  Widget rightArrowIcon = new Icon(Icons.chevron_right,color: ResColors.colorGrey,);


  @override
  Widget build(BuildContext context){
    return ListView.builder(
        itemCount: titles.length * 2,
        itemBuilder: (context,index){
           return ListItem(index);
        });

  }


  ListItem(index){
       if(index == 0){
         var avatarContainer = new Container(
           color:ResColors.colorBlue,
           height:200.0,
           child:new Column(
             mainAxisAlignment:MainAxisAlignment.center,
             children: <Widget>[
               userAvator == null ?
                  new Image.asset("images/image_avator_default.png",width: 60.0,):
                  new Container(
                    width:60.0,
                    height:60.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color:Colors.transparent,
                      image:new DecorationImage(
                         image:new NetworkImage(userAvator),
                         fit:BoxFit.cover,
                      ),
                      border: new Border.all(
                         color: ResColors.colorWhite,
                         width: 2.0,
                      ),
                    ),
                  ),
               new Container(
                 margin: const EdgeInsets.only(top:10.0),
                 child:new Text(
                   userName == null ? "点击头像登录" : userName,
                   style: new TextStyle(color:ResColors.colorWhite,fontSize: 16.0),
                 ),
               ),

             ],
           ),
         );
         return new GestureDetector(
           onTap: (){
               if(userName == null){
                 //注意push系列的方法返回值是一个Future,可以用来接收参数
                 Navigator.push<String>(context,new MaterialPageRoute(builder: (BuildContext context){
                   return new LoginPage();
                 })).then((String result){
                   userName = result;
                   setState(() {

                   });
                 });
               }
           },
           child: avatarContainer,
         );

       }
       --index;
       if(index.isOdd){
         return new Divider(
           height: 1.0,
         );
       }
       index = index ~/2;
       String title = titles[index];
       var listItemContent = new Padding(
         padding: const EdgeInsets.fromLTRB(10.0,15.0,10.0,15.0),
         child: new Row(
           children: <Widget>[
             icons[index],
             new Expanded(
                 child: new Text(
                     title,
                     style: TextStyle(fontSize: 16.0),
                 ),
             ),
             rightArrowIcon,
           ],
         ),
       );
       return new InkWell(
         child: listItemContent,
         onTap: (){

         },
       );


  }

  //获取用户信息
  void getUserInfo() {
    UserMessageUtils.whetherLogin().then((isLogin){
      if(isLogin){
        //如果已经登录
        UserMessageUtils.getUserName().then((saveUserName){
          //更新状态
          userName = saveUserName;
          setState(() {

          });

        });
      }


    });


  }


}