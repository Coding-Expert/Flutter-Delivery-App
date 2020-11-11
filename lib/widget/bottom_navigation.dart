import 'package:flutter/material.dart';
import 'package:nfl_app/utils/constants.dart';

class BottomNavBar extends StatelessWidget {
  static List<Widget> children = [
    Image.asset("assets/images/Home.png"),
    Image.asset("assets/images/search.png"),
    Image.asset("assets/images/comment.png"),
    Image.asset("assets/images/box.png"),
    Image.asset("assets/images/logo2.png"),
    Image.asset("assets/images/User.png")
  ];
  final int selected;
  final Function(int) onTap;

  const BottomNavBar({Key key, this.selected, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < children.length; i++)
          Expanded(
            child: GestureDetector(
              onTap: () {
               // if ( i == 1) return;
                return onTap?.call(i);
              },
              child: Container(
                height: 60,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
//                    BoxShadow(
//                        offset: Offset(0, -1), spreadRadius: -3, blurRadius: 3),
                  ],
                  border: Border(
                    bottom: selected == i
                        ? BorderSide(color: Constants.darkGreen, width: 3)
                        : BorderSide(),
                    right: BorderSide(color: Colors.black38, width: .5),
                  ),
                ),
                child: children[i],
              ),
            ),
          ),
      ],
    );
  }
}
