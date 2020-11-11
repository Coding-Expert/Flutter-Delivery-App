// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:nfl_app/utils/constants.dart';

class CheckButton extends StatefulWidget {
  final bool checkedIn;
  final bool enable;
  final Function checkInFunction;
  final Function checkOutFunction;

  static _() {}
  const CheckButton({
    Key key,
    this.enable,
    this.checkedIn,
    this.checkInFunction = _,
    this.checkOutFunction = _,
  }) : super(key: key);

  @override
  _CheckButtonState createState() => _CheckButtonState();
}

class _CheckButtonState extends State<CheckButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation; 

  Color get color =>
      _controller.value > .5 ? Constants.red : Constants.lightGreen;

  @override
  void initState() {
    
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    // animation = Tween<double>(begin: -1, end: 0).animate(_controller)..addListener(_animateSelectorBack);
    // _controller..addListener(() {setState((){});})..addStatusListener((AnimationStatus status) {
    //   if (status == AnimationStatus.completed) {
    //     print("animation works:-------------");
    //   } 
    //   if (status == AnimationStatus.dismissed) {
    //     print("animation works:-------------");
    //   }
    // });
    
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.checkedIn) _controller.value = 1;
    return Container(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Container(
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 3),
            borderRadius: BorderRadius.circular(1000),
          ),
          alignment: Alignment(
            (_controller.value * 2) - 1,
            0,
          ),
          
          child: RaisedButton.icon(
            color: color,
            colorBrightness: Brightness.dark,
            onPressed: !widget.enable
                ? null
                :!widget.checkedIn
                    ? widget.checkInFunction
                    : widget.checkOutFunction,
            icon: Image.asset("assets/images/check.png", width: 30, height: 30),
            label: Text(_controller.value > .5 ? "CHECK OUT" : "CHECK IN"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1000),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(CheckButton oldWidget) {
    if (widget.checkedIn) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }
  
}
