import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorfulDividerWidget extends StatelessWidget {
  final Color color;
  final Widget icon;
  final bool last;
  final bool first;

  const ColorfulDividerWidget({
    Key key,
    this.color = Colors.green,
    this.last = false,
    this.first = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          last
              ? Column(
                  children: <Widget>[
                    Container(
                      height: 7,
                      width: 1,
                      color: Colors.black45,
                    ),
                    Icon(Icons.location_on, color: Colors.lightGreen, size: 15)
                  ],
                )
              : icon == null
                  ? Column(
                    children: <Widget>[
                      if (!first)
                        Container(
                          height: 7,
                          width: 1,
                          color: Colors.black45,
                        ),
                      if(first)
                        Padding(padding: EdgeInsets.only(top: 7)),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: color,
                      )
                    ],
                  ) 
                  : icon,
          if (!last)
            Expanded(
              child: Container(
                width: 2,
                color: Colors.black12,
              ),
            ),
          
        ],
      ),
    );
  }
}
