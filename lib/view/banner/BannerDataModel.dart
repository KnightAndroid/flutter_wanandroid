import 'package:wanandroid/view/banner/BannerModel.dart';


class BannerDataModel extends Object with BannerModel{
  //图片url
  final String url;
  //banner描述
  final String title;
  //banner对应链接
  final String banner_url;

  BannerDataModel({this.url,this.title,this.banner_url});


  @override
  get imagePath => url;

  @override
  get desc => title;

  @override
  get bannerUrl => banner_url;




}