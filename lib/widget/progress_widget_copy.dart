import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nfl_app/models/loads_module.dart';
import 'package:nfl_app/models/location_module.dart';
import 'package:nfl_app/utils/constants.dart';
import 'package:nfl_app/utils/order.dart';
import 'package:nfl_app/utils/trip.dart';

String timeinHours;
double distance1 = 0;

class ProgressWidget extends StatefulWidget {
  final Trip trip;
  final Order selectedOrder;
  static const Color color = Constants.lightGreen;

  const ProgressWidget({
    Key key,
    this.selectedOrder,
    this.trip,
  }) : super(key: key);

  @override
  _ProgressWidgetState createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget> {
  bool loader = true;

  double progress = 0;

  Duration time = Duration(hours: 0);

  // String time;

  @override
  void initState() {
    init().then((value) => setState(() {
          loader = false;
        }));

    super.initState();
  }

  Future init() async {
    var sendCurrent = await LoadsModule.sendCurrentLocation(widget.trip);

    var totalDistance = await Distance.calculateTime(
      widget.trip.orders.first.locationName,
      widget.trip.orders.last.locationName,
    );

    if (widget.selectedOrder == null) {
      print("selected order is null");
      /*   this.distance = totalDistance.distance;
      this.time = totalDistance.timeDuration;*/

      var distance = await Distance.distanceTo(
        widget.trip.orders.last.locationName,
      );

      distance1 = distance.distance;
      timeinHours = distance.time.floor().toString();
    } else {
      print("else selcted order is not null");
      var distance = await Distance.distanceTo(
        widget.selectedOrder.locationName,
      );

      distance1 = distance.distance;
      this.time = distance.timeDuration;
      timeinHours = distance.time.floor().toString();
      //this.time = distance.timeDuration.inHours as String;
    }

    if (widget.trip.isChecked(widget.trip.orders.first)) {
      var distanceToFinish = await Distance.distanceTo(
        widget.trip.orders.last.locationName,
      );

      progress = 1 - distanceToFinish.distance / totalDistance.distance;

      progress = min(max(progress, 0), 1);
    } else if (widget.trip.isChecked(widget.trip.orders.last)) {
      progress = 1;
    }
  }

  Widget getCircle(bool closed) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: closed ? ProgressWidget.color : Colors.white,
        border: closed ? null : Border.all(color: Colors.grey, width: 5),
      ),
    );
  }

  Widget get miles => AspectRatio(
        aspectRatio: .75,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(300)),
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/milestone.png",
                ),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    alignment: Alignment.bottomLeft,
                    child: FittedBox(
                      child: Text(
                        "  Delivery",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          "${(distance1.ceil() / 1609).ceil()} \nMiles",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (!loader)
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 80,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  //the main bar
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.topLeft,
                      color: Colors.grey,
                      height: 6,
                      width: double.infinity,
                      child: FractionallySizedBox(
                        widthFactor: progress,
                        alignment: Alignment.topLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: ProgressWidget.color,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(-1, 0),
                    child: getCircle(true),
                  ),
//          Align(
//            alignment: Alignment(.5, -1),
//            child: Container(
//              child: Text("Deliver 1", style: Constants.lightText),
//            ),
//          ),
//          Align(
//            alignment: Alignment(.5, 0),
//            child: getCircle(progress >= 1.5 / 2),
//          ),

                  Align(
                    alignment: Alignment(1, -1),
                    child: Container(
                      child: Text("Deliver", style: Constants.lightText),
                    ),
                  ),
                  Align(
                    alignment: Alignment(1, 0),
                    child: getCircle(false),
                  ),

                  Align(
                      alignment: Alignment(-.6, -.3),
                      child: Text((int.parse(timeinHours) / 3600)
                          .toDouble()
                          .toStringAsFixed(
                              2)) /*Text(
                DateFormat("HH:mm").format(DateTime(2020, 1, 1).add(time)),
                style: TextStyle(fontSize: 10),
              ),*/
                      ),
                  Align(
                    alignment: Alignment(-.6, .3),
                    child: Text("Drive Time in hrs",
                        style: TextStyle(fontSize: 10)),
                  ),
                  Align(
                    alignment: Alignment(-.1, -.1),
                    child: miles,
                  ),
                  Align(
                    alignment: Alignment(-1, -1),
                    child: Text(
                      "Current .\nLocation",
                      style: Constants.lightTextSmall,
                    ),
                  ),
                  //trunk
                  Align(
                    alignment: Alignment(progress * 2 - 1, -0.1),
                    child: Image.asset("assets/images/trunk.png",
                        width: 50, height: 50),
                  ),
                ],
              ),
            )
          : SpinKitCubeGrid(
              color: Constants.darkGreen,
              size: 30,
            ),
    );
  }
}
