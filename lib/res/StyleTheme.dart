import 'package:flutter/material.dart';
import 'package:wanandroid/res/ResColors.dart';
/**
 * Describe :
 * Created by Knight on 2019/3/30
 * @Version :
 * 点滴之行,看世界
 */

class StyleTheme {
  ThemeData theme;

  static StyleTheme instance;

  BuildContext context;
  StyleTheme(BuildContext context){
    this.context = context;
    theme = Theme.of(context);

  }


  static StyleTheme getInstance(BuildContext context){
    if(instance == null){
      instance = new StyleTheme(context);
    }
    return instance;
  }


  //时间样式
   TextStyle getTimeStyle(){
    //时间样式
     TextStyle timeStyle = theme.textTheme.caption.merge(
      const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
     return timeStyle;
  }

  //标题样式
  TextStyle getTitleStyle(){
    TextStyle titleStyle = theme.textTheme.title;
    return titleStyle;
  }

  //描述样式
  TextStyle getDescriptStyle(){
    TextStyle descriptionStyle = theme.textTheme.caption.merge(
      const TextStyle(color: ResColors.colorBack),
    );

    return descriptionStyle;
  }

  //主体样式
  TextStyle getTopicStyle(){
    //主题样式
    TextStyle topicStyle = theme.textTheme.caption;
    return topicStyle;
  }

  //作者名字
  TextStyle getSpeakNameStyle(){
    TextStyle speakerNameStyle = theme.textTheme.body2;
    return speakerNameStyle;
  }

}
