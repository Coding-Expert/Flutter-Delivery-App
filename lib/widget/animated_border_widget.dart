import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nfl_app/utils/constants.dart';

class AnimatedBorderWidget extends StatefulWidget {
  final Widget child;
  final Color color;

  const AnimatedBorderWidget({Key key, this.child, this.color}) : super(key: key);

  @override
  _AnimatedBorderWidgetState createState() => _AnimatedBorderWidgetState();
}

class _AnimatedBorderWidgetState extends State<AnimatedBorderWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 5,
      ),
    );
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) => Container(
        margin: const EdgeInsets.all(8),
        child: child,
        decoration: BoxDecoration(
          border: _Border(color:widget.color,val: _controller.value),
        ),
      ),
    );
  }
}

class _Border extends BoxBorder {
  final double val;
  final Color color;

  _Border({this.color, this.val});

  @override
  BorderSide get top => null;

  @override
  BorderSide get bottom => null;

  @override
  EdgeInsetsGeometry get dimensions => null;

  @override
  bool get isUniform => false;

  @override
  void paint(Canvas canvas, Rect rect,
      {TextDirection textDirection,
      BoxShape shape = BoxShape.rectangle,
      BorderRadius borderRadius}) {
    Paint p = Paint();
    p.strokeWidth = 3.0;
    p.color =color;

    double area = 2 * rect.width + 2 * rect.height;

    double start = max((val - .6) / .4, .0) * area + rect.width / 2;
    double end = min(val / .9, 1) * area + rect.width / 2;

    // draw top side
    if (start < rect.width)
      canvas.drawLine(
        rect.topLeft + Offset(start, 0),
        rect.topLeft + Offset(min<double>(rect.width, end), 0),
        p,
      );
    if (start < rect.width + rect.height)
      canvas.drawLine(
        rect.topRight + Offset(0, max(start - rect.width, 0)),
        rect.topRight +
            Offset(
              0,
              max(min<double>(rect.height, end - rect.width), 0),
            ),
        p,
      );
//    if (start < 2 * rect.width + rect.height)
    canvas.drawLine(
      rect.bottomRight -
          Offset(
            min(max(start - rect.width - rect.height, 0.0), rect.width),
            0,
          ),
      rect.bottomRight -
          Offset(
            min(max(end - rect.width - rect.height, 0.0), rect.width),
            0,
          ),
      p,
    );
    canvas.drawLine(
      rect.bottomLeft -
          Offset(
            0,
            min(max(start - 2 * rect.width - rect.height, 0.0), rect.height),
          ),
      rect.bottomLeft -
          Offset(
            0,
            min(max(end - 2 * rect.width - rect.height, 0.0), rect.height),
          ),
      p,
    );
    canvas.drawLine(
      rect.topLeft +
          Offset(
            min(max(start - 2 * rect.width - 2 * rect.height, 0.0),
                rect.height),
            0,
          ),
      rect.topLeft +
          Offset(
            min(
              max(end - 2 * rect.width - 2 * rect.height, 0.0),
              rect.width,
            ),
            0,
          ),
      p,
    );
  }

  @override
  ShapeBorder scale(double t) => null;
}
