import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;
import 'package:wanandroid/res/ResColors.dart';


//自定义圆圈倒计时进度条
class _DrawProgress extends CustomPainter {
  //颜色
  final Color color;
  //半径
  final double radius;
  double angle;
  AnimationController animation;

  Paint circleFillPaint;
  Paint progressPaint;
  Rect rect;

  _DrawProgress(this.color, this.radius,
      {double this.angle, AnimationController this.animation}) {
    circleFillPaint = new Paint();
    circleFillPaint.color = ResColors.colorWhite;
    circleFillPaint.style = PaintingStyle.fill;

    progressPaint = new Paint();
    progressPaint.color = color;
    progressPaint.style = PaintingStyle.stroke;
    //需要设置StrokeCap.round 不然两端是平的
    progressPaint.strokeCap = StrokeCap.round;
    progressPaint.strokeWidth = 2.0;

    if (animation != null && !animation.isAnimating) {
      animation.forward();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    double x = size.width / 2;
    double y = size.height / 2;
    Offset center = new Offset(x, y);
    //绘制白色的圆圈
    canvas.drawCircle(center, radius - 2, circleFillPaint);
    rect = Rect.fromCircle(center: center, radius: radius);
    //绘制进度条实际上就是绘制圆弧，
    //使用canvas.drawArc(Rect rect, double startAngle, double sweepAngle, bool useCenter, Paint paint)。
    //rect参数就是圆弧所在的整圆的Rect，
    //我们使用Rect.fromCircle来构造这个整圆的Rect：final Rect arcRect = Rect.fromCircle(center: offsetCenter, radius: drawRadius);
    //startAngle为起始弧度，sweepAngle为需要绘制的圆弧长度，这里要注意，这两个值都是 弧度制 的，canvas里面与角度有关的变量都是弧度制的，在计算的时候一定要注意；useCenter属性标示是否需要将圆弧与圆心相连；paint就是我们的画笔。
    //弧度和角度相互互换
    //num degToRad(num deg) => deg * (pi / 180.0);
    //num radToDeg(num rad) => rad * (180.0 / pi);
    angle = angle * (-1);
    double startAngle = -math.pi / 2;
    double sweepAngle = math.pi * angle / 180;
    print("draw paint-------------------= $startAngle, $sweepAngle");
    //canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
    Path path = new Path();
    path.arcTo(rect, startAngle, sweepAngle, true);
    //绘制圆弧
    canvas.drawPath(path, progressPaint);
  }

  //重绘方法
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class SkipDownTimeProgress extends StatefulWidget {
  final Color color;
  final double radius;
  final Duration duration;
  final Size size;
  String skipText;
  OnSkipClickListener clickListener;

  SkipDownTimeProgress(
      this.color,
      this.radius,
      this.duration,
      this.size, {
        Key key,
        String this.skipText = "跳过",
        OnSkipClickListener this.clickListener,
      }) : super(key: key);

  @override
  _SkipDownTimeProgressState createState() {
    return new _SkipDownTimeProgressState();
  }
}

class _SkipDownTimeProgressState extends State<SkipDownTimeProgress>
    with TickerProviderStateMixin {
  AnimationController animationController;
  double curAngle = 360.0;

  @override
  void initState() {
    super.initState();
    print('initState----------------------');
    //创建AnimationController对象
    animationController =
    new AnimationController(vsync: this, duration: widget.duration);
    animationController.addListener(_change);
    _doAnimation();
  }

  @override
  void didUpdateWidget(SkipDownTimeProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  //回收
  @override
  void dispose() {
    super.dispose();
    print('dispose----------------------');
    animationController.dispose();
  }

  void _onSkipClick() {
    if (widget.clickListener != null) {
      print('skip onclick ---------------');
      widget.clickListener.onSkipClick();
    }
  }

  void _doAnimation() async {
    //设置5秒
    Future.delayed(new Duration(milliseconds: 50), () {
      //mounted 若为true 表示Widget被加载到tree上了
      if(mounted) {
        //开启动画 加orCancel 先把之前的动画取消
        animationController.forward().orCancel;
      }else {
        _doAnimation();
      }
    });
  }

  void _change() {
    print('ange == $animationController.value');
    double ange =
    double.parse(((animationController.value * 360) ~/ 1).toString());
    setState(() {
      curAngle = (360.0 - ange);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: _onSkipClick,
      child: new Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new CustomPaint(
            painter:
            new _DrawProgress(widget.color, widget.radius, angle: curAngle),
            size: widget.size,
          ),
          Text(
            widget.skipText,
            style: TextStyle(
                color: widget.color,
                fontSize: 13.5,
                decoration: TextDecoration.none),
          ),
        ],
      ),
    );
  }
}

abstract class OnSkipClickListener {
  void onSkipClick();
}