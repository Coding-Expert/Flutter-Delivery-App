import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nfl_app/utils/constants.dart';

class CircleOfTime extends StatelessWidget {
  final DateTime date;
  final Color color;
  final bool selected;

  const CircleOfTime({Key key, this.selected = false, this.date, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      radius: Radius.circular(20),
      color: selected ? Colors.grey : Colors.transparent,
      borderType: BorderType.RRect,
      dashPattern: [3],
      strokeCap: StrokeCap.round,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected ? Colors.grey[200] : Colors.transparent,
        ),
        padding: selected ? EdgeInsets.all(5) : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              backgroundColor: color,
              radius: 25,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white54,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        date.day.toString(),
                        style: TextStyle(color: Constants.red),
                      ),
                      Text(
                        DateFormat.MMM().format(date),
                        style: TextStyle(color: Constants.blue, fontSize: 8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Text(
              DateFormat("h:mm a").format(date),
              style: TextStyle(color: Constants.red, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleOfTime1 extends StatelessWidget {
  final String date;
  final Color color;
  final bool selected;
  final String time;

  const CircleOfTime1(
      {Key key, this.selected = false, this.date, this.color, this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      radius: Radius.circular(20),
      color: selected ? Colors.grey : Colors.transparent,
      borderType: BorderType.RRect,
      dashPattern: [3],
      strokeCap: StrokeCap.round,
      child: Container(
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected ? Colors.grey[200] : Colors.transparent,
        ),
        padding: selected ? EdgeInsets.all(5) : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    child: Text(
                      date.split(',')[0],
                      style: TextStyle(
                          color: (color == Constants.lightBlue)
                              ? Constants.blue
                              : Constants.lightGreen, fontSize: 20)
                    ),
                  ),
                  // FittedBox(
                  //   child: Text(
                  //     date.split(',')[1],
                  //     style: TextStyle(
                  //         color: (color == Constants.lightBlue)
                  //             ? Constants.blue
                  //             : Constants.lightGreen, fontSize: 15)
                  //   ),
                  // ),
                  
                ],
              ),
            ),
            FittedBox(
              child: Text(
                (time == null) ? null : time,
                // DateFormat("h:mm a").format(date),
                style: TextStyle(color: Constants.red, fontSize: 12),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

class CircleOfTime2 extends StatelessWidget {
  final String date;
  final Color color;
  final bool selected;
  final String time;

  const CircleOfTime2(
      {Key key, this.selected = false, this.date, this.color, this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2.0,
            color: selected ? Constants.red : Colors.transparent,
          ),
        ),
      ),
//      decoration: BoxDecoration(
//        borderRadius: BorderRadius.circular(20),
//        color: selected ? Colors.grey[200] : Colors.transparent,
//      ),
      // padding: selected ? EdgeInsets.all(5) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          (color == Constants.blue)
              ? Text(
                  "PICKUP",
                  style: TextStyle(color: color, fontSize: 15),
                )
              : Text(
                  "DELIVERY",
                  style: TextStyle(color: color, fontSize: 15),
                ),
          Text(
            (time == null) ? null : time,
            // DateFormat("h:mm a").format(date),
            style: TextStyle(color: Constants.red, fontSize: 12),
          ),
          FittedBox(
            child: Text(
              date,
              style: TextStyle(color: Constants.blue, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
