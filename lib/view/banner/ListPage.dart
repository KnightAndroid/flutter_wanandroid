import 'package:flutter/material.dart';

typedef HeaderWidgetBuild = Widget Function(BuildContext context, int position);
typedef ItemWidgetBuild = Widget Function(BuildContext context, int position);

class ListPage extends StatefulWidget{
  //头部
  List headerList;
  //平常数据
  List listData;

  ScrollController mController;



  ItemWidgetBuild itemWidgetBuild;
  HeaderWidgetBuild headerWidgetBuild;



  ListPage(List this.listData,{Key key,List this.headerList,ItemWidgetBuild this.itemWidgetBuild,HeaderWidgetBuild this.headerWidgetBuild, ScrollController this.mController}) : super(key:key);

  @override
  ListPageState createState(){
    return new ListPageState(mController);
  }

}



class ListPageState extends State<ListPage>{
  ScrollController mController;
  ListPageState(this.mController);

   @override
   Widget build(BuildContext context){
      return Container(
        child: new ListView.builder(
          controller: mController,
          itemBuilder: (BuildContext context,int position){
            return buildItemWidget(context,position);
          },
          itemCount: _getListCount(),
        ),
      );
   }


   //返回列表条数
   int _getListCount(){
     int itemCount = widget.listData.length;
     return getHeaderCount() + itemCount;
   }


   //返回头部数据
   int getHeaderCount(){
     int headCount = widget.headerList != null ? widget.headerList.length : 0;
     return headCount;
   }


   //banner点击事件
   Widget _headerItemWidget(BuildContext context,int index){
     if(widget.headerWidgetBuild != null){
       return widget.headerWidgetBuild(context,index);
     } else {
       return new GestureDetector(
         child: new Padding(
           padding: new EdgeInsets.all(10.0),
           child: new Text("Header Row $index"),
         ),
         onTap: (){
           print("header click $index-------------");
         },
       );

     }

   }


   //构建头部还是身体列表
   Widget buildItemWidget(BuildContext context,int index){
     if(index < getHeaderCount()){
        return _headerItemWidget(context, index);
     }else{
       int pos = index - getHeaderCount();
       return _itemBuildWidget(context,pos);
     }

   }



   //listVIew 列表
   Widget _itemBuildWidget(BuildContext context,int index){
     if(widget.itemWidgetBuild != null){
       return widget.itemWidgetBuild(context,index);
     }else{
       return new GestureDetector(
         child: new Padding(
           padding: new EdgeInsets.all(10.0),child: new Text("Row $index"),
         ),
         onTap: (){
           print('click $index--------');
         },
       );
     }
   }


   @override
   void dispose(){
     super.dispose();
     mController.dispose();
   }






}