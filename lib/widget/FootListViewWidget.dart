import 'package:flutter/material.dart';
import 'package:wanandroid/res/ResColors.dart';
/**
 * Describe : ListView尾部
 * Created by Knight on 2019/3/24
 * @Version : 0.0.1
 * 点滴之行,看世界
 */


//ListView尾部
class FootListViewWidget extends StatelessWidget{


  @override
  Widget build(BuildContext context){
    return new Container(
      padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 15.0),
      child:new Row(
        children: <Widget>[
          new Expanded(
              child: new Divider(
                height: 10.0,
              ),
              flex: 1,
          ),
          new Container(
            padding: EdgeInsets.only(left: 4.0,right: 4.0),
            child:new Text(
              "做人是要有底线的~",
              style: new TextStyle(color: ResColors.colorBlue),
            ),
          ),

          new Expanded(
              child: new Divider(height: 10.0,
              ),
            flex: 1,
          )
        ],
      ),
    );

  }


}



