// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:nfl_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';

class CheckButton1 extends StatefulWidget {
  final bool checkedIn;
  final bool enable;
  final bool freezeChecking;
  final Function checkInFunction;
  final Function checkOutFunction;
  

  static _() {}
  const CheckButton1({
    Key key,
    this.enable,
    this.checkedIn,
    this.freezeChecking,
    this.checkInFunction = _,
    this.checkOutFunction = _,
  }) : super(key: key);

  @override
  _CheckButtonState createState() => _CheckButtonState();
}

class _CheckButtonState extends State<CheckButton1>
    with SingleTickerProviderStateMixin {

  int _sliding = 0;
  int count = 0;
  Color thumbColor = HexColor("#00bf99");


  @override
  void initState() {
    if(widget.checkedIn){
      _sliding = 1;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: HexColor("#00bf99"), width: 2)
            ),
            child: CupertinoSlidingSegmentedControl(
              children: {
                0: Container(
                      height: 50,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 9.0),
                      child:Text('CheckIn', style: TextStyle(color: widget.freezeChecking ? widget.checkedIn ? Colors.black : Colors.white : Colors.black),),
                  ),
                1: Container(
                      alignment: Alignment.center,
                      height: 50,
                      padding: EdgeInsets.symmetric(vertical: 9.0),
                      child: Text('CheckOut', style: TextStyle(color: !widget.enable ? Colors.white : Colors.black)),
                  ),
              }, 
              // backgroundColor: Colors.white,
              thumbColor: widget.freezeChecking ? widget.enable ? Colors.grey : thumbColor : Colors.grey,
              // padding: EdgeInsets.symmetric(horizontal: 9.0),
              groupValue: _sliding,
              onValueChanged: (newValue){
                if(!widget.enable && widget.freezeChecking){
                  setState(() {
                    
                    if(_sliding == 0){
                      widget.checkInFunction.call();
                    }
                    if(_sliding == 1){
                      widget.checkOutFunction.call();
                    }
                  });
                }
              },
              
            ),
    );
  }

  @override
  void didUpdateWidget(CheckButton1 oldWidget) {
    if (widget.checkedIn) {
      _sliding = 1;
    } else {
      _sliding = 0;
    }
    super.didUpdateWidget(oldWidget);
  }
  
}
class HexColor extends Color{
  static int _getColorFromHex(String hexColor){
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
  HexColor(final String hexColor): super(_getColorFromHex(hexColor));
}
