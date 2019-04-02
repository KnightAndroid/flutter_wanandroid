import 'package:flutter/material.dart';


class ProjectPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState(){
    return new ProjectState();
  }
}



class ProjectState extends State<ProjectPage>{


  @override
  Widget build(BuildContext context){
    //设置home
    return new Scaffold(
      body: new Center(child: Text("项目",style: TextStyle(fontSize: 16.0),)),
    );
  }
}