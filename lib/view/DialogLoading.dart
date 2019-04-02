import 'package:flutter/material.dart';

class DialogLoading extends StatelessWidget{

  BuildContext context;

  String text;

  DialogLoading({Key key,@required this.text,this.context}) : super(key:key);


  void dimissLoading(){
    Navigator.pop(context);
  }




  @override
  Widget build(BuildContext context){
     return new Material(//创建透明层
       type:MaterialType.transparency,//透明类型
       child: new Center(
         child: new SizedBox(
           width:120.0,
           height:120.0,
           child:new Container(
             decoration: ShapeDecoration(
                 color: Color(0xffffffff),
                 shape:RoundedRectangleBorder(
                   borderRadius: BorderRadius.all(
                     Radius.circular(6.0),
                   ),
                 ),
             ),
             child: new Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: <Widget>[
                 new CircularProgressIndicator(),
                 new Padding(
                     padding: const EdgeInsets.only(
                       top:20.0,
                     ),
                     child:new Text(
                       text,
                       style: new TextStyle(fontSize: 12.0),
                     ),
                 ),

               ],
             ),
           ),
         ),
       ),
     );
  }











}
