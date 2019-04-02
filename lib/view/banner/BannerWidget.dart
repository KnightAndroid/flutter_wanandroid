import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wanandroid/view/banner/BannerModel.dart';
import 'package:meta/meta.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wanandroid/ui/pages/web/DetailWebPage.dart';
import 'package:wanandroid/res/ResColors.dart';


const CountMax = 0x7fffffff;

typedef void OnBannerPress(int position, BannerModel bannerModel);
typedef Widget Build(int position, BannerModel bannerModel);


class BannerWidget extends StatefulWidget{
  final OnBannerPress bannerPress;
  final Build build;
  final List<BannerModel> bannerModel;
  final int height;//高度
  final int delayTime;//时间(毫秒)
  final int duration;//切换速度(毫秒)


  BannerWidget(
  {Key key,@required this.bannerModel,this.height = 180,this.delayTime = 1500,this.duration = 1500,this.bannerPress,this.build}
      ) :super(key:key);


  @override
  State<StatefulWidget> createState(){
    return new BannerState();
  }


}


class BannerState extends State<BannerWidget> {
  Timer timer;

  int selectIndex = 0;

  PageController controller;

  @override
  void initState() {
    double current = (CountMax / 2) - ((CountMax / 2) % widget.bannerModel.length);
    controller = PageController(initialPage: current.toInt());
    start();
    super.initState();
  }

  start() {
    stop();
    timer = Timer.periodic(Duration(milliseconds: widget.delayTime), (timer) {
      controller.animateToPage(controller.page.toInt() + 1,
          duration: Duration(milliseconds: widget.duration),
          curve: Curves.linear);
    });
  }

  stop() {
    timer?.cancel();
    timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height.toDouble(),
        color: Colors.black12,
        child: Stack(
          children: <Widget>[
            viewPager(),
            tips(),
          ],
        ));
  }

  Widget viewPager() {
    return PageView.builder(
      itemCount: CountMax,
      controller: controller,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              if (widget.bannerPress != null)
                widget.bannerPress(selectIndex, widget.bannerModel[selectIndex]);
                Navigator.push(context, MaterialPageRoute(builder:(webPage){
                  return new DetailWebPage(web_title: widget.bannerModel[selectIndex].desc, web_url: widget.bannerModel[selectIndex].bannerUrl);
                }),
                );

            },
            child: widget.build == null
                ? FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image:
                widget.bannerModel[index % widget.bannerModel.length].imagePath,
                fit: BoxFit.cover)
                : widget.build(
                index, widget.bannerModel[index % widget.bannerModel.length]));

      },

    );
  }

  Widget tips() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 32.0,
          padding: EdgeInsets.all(6.0),
          color: Colors.black45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              Text(widget.bannerModel[selectIndex].desc,
                  style: new TextStyle(color: ResColors.colorWhite)),
              Row(children: circle())
            ],
          ),
        ));
  }

  List<Widget> circle() {
    List<Widget> circle = [];
    for (var i = 0; i < widget.bannerModel.length; i++) {
      circle.add(Container(
        margin: EdgeInsets.all(2.0),
        width: 8.0,
        height: 8.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: selectIndex == i ? ResColors.colorBlue : ResColors.colorWhite,
        ),
      ));
    }
    return circle;
  }

  onPageChanged(index) {

    selectIndex = index % widget.bannerModel.length;
    setState(() {});
  }

  @override
  void dispose() {
    stop();
    controller?.dispose();
    super.dispose();
  }
}



