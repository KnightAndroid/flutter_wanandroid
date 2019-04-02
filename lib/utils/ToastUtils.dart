import 'package:toast/toast.dart';
import 'package:flutter/widgets.dart';

class ToastUtils{
  //中间弹出短显示吐司
  static showShortCenterToast(BuildContext context,String mContent){
    Toast.show(mContent, context,duration:Toast.LENGTH_SHORT,gravity: Toast.CENTER);
  }
  //顶部弹出短显示吐司
  static showShortTopToast(BuildContext context,String mContent){
    Toast.show(mContent, context,duration:Toast.LENGTH_SHORT,gravity: Toast.TOP);
  }

  //底部弹出短显示吐司
  static showShortBottomToast(BuildContext context,String mContent){
    Toast.show(mContent, context,duration:Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
  }

  //中间弹出长显示吐司
  static showLongCenterToast(BuildContext context,String mContent){
    Toast.show(mContent, context,duration:Toast.LENGTH_LONG,gravity: Toast.CENTER);
  }

  //顶部弹出长显示吐司
  static showLongTopToast(BuildContext context,String mContent){
    Toast.show(mContent, context,duration:Toast.LENGTH_LONG,gravity: Toast.TOP);
  }
  //底部弹出长显示吐司
  static showLongBottomToast(BuildContext context,String mContent){
    Toast.show(mContent, context,duration:Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
  }

}