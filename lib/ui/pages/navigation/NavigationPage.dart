import 'package:flutter/material.dart';
class NavaigationPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState(){
    return new NavaigationState();
  }
}

class NavaigationState extends State<NavaigationPage>{
  @override
  Widget build(BuildContext context){
    //设置home
    return new Scaffold(
      body: new Center(child: Text("导航",style: TextStyle(fontSize: 16.0),)),
    );
  }
}