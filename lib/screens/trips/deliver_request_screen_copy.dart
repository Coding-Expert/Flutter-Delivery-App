import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:nfl_app/models/loads_module.dart';
import 'package:nfl_app/utils/constants.dart';
import 'package:nfl_app/utils/order.dart';
import 'package:nfl_app/utils/trip.dart';
import 'package:nfl_app/widget/animated_border_widget.dart';
import 'package:nfl_app/widget/data_widget.dart';
import 'package:nfl_app/widget/order_widget.dart';
import 'package:nfl_app/widget/progress_widget.dart';

class DeliverRequestScreen extends StatefulWidget {
  @override
  _DeliverRequestScreenState createState() => _DeliverRequestScreenState();
}

class _DeliverRequestScreenState extends State<DeliverRequestScreen> {
  bool loading = true;

  List<Trip> trips;
  int _index = 0;

  Trip get selectedTrip => trips[_index];

  //todo sort orders
  List<Order> get allOrders =>
      [for (var trip in trips) ...trip.orders]..sort((x, y) {
          return x.date.compareTo(y.date);
        });

  bool get accepted => !LoadsModule.trips.any((element) => !element.accepted);

  get progress => 0.0;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    if (!loading) {
      setState(() {
        loading = true;
      });
    }

    LoadsModule.init()
        .then((value) => setState(() {
              print("trips loading get value -----------");
              trips = LoadsModule.trips;
              loading = false;
            }))
        .catchError((err) {
      print("trips loading get error $err ----------");
    });
  }

  get accept => Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Constants.lightGreen,
                colorBrightness: Brightness.dark,
                child: Text(selectedTrip.accepted ? "DETAILS" : "ACCEPT"),
                //todo set this function
                onPressed: accepted
                    ? () => Navigator.pushNamed(context, "/details")
                    : () async {
                        setState(() {
                          loading = true;
                        });
                        await LoadsModule.acceptAll(selectedTrip);
                        setState(() {
                          loading = false;
                        });
                      },
              ),
            ),
          ),
          Expanded(
            child: AnimatedBorderWidget(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 20),
                        child: FittedBox(
                          child: Text(
                            DateTime.now().isAfter(selectedTrip.endDate)
                                ? "late"
                                : DateTime.now()
                                        .add(selectedTrip.deliveryTime ??
                                            Duration())
                                        .isAfter(selectedTrip.endDate)
                                    ? "out of time"
                                    : "on Time",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    FittedBox(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: selectedTrip.deliveryTime != null
                                  ? "${selectedTrip.deliveryTime.toString().split(":").first}"
//                                      ":${selectedTrip.deliveryTime.toString().split(":")[1]}"
                                  : "00:00",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "Hrs",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Material(
        child: Center(
          child: SpinKitCubeGrid(
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    } else if (trips.isEmpty) {
      return Material(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: init,
              ),
              Text("there are no trips"),
            ],
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/map.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          dateWidget,
          SizedBox(height: 10),
          ProgressWidget(trip: selectedTrip),
          for (var trip in trips)
            OrderWidget(
              order: allOrders[0],
              last: false,
              consignees:
                  trips[trips.indexOf(trip)].consignees.toSet().toList(),
              shippers: trips[trips.indexOf(trip)].shippers.toSet().toList(),
            ),

          /* for (var order in allOrders)
            GestureDetector(
              onTap: () {
                setState(() {
                  var i = trips
                      .indexWhere((element) => element.orders.contains(order));

                  _index = max(i, 0);
                });
              },
              child: OrderWidget(
                order: order,
                last: order == allOrders.last,
                consignees: selectedTrip.consignees.toSet().toList(),
                shippers: selectedTrip.shippers.toSet().toList(),
              ),
            ),*/
          DataWidget(data: [
            DataItem(
              key: "Temp",
              value: "${selectedTrip.temp ?? "xx"}",
//              icon: Image.asset(
//                "assets/images/temperature.png",
//                width: 30,
//                height: 30,
//              ),
            ),
            DataItem(
              key: "Weight",
              value: "${selectedTrip.weight ?? "xx"}",
//              icon: Image.asset(
//                "assets/images/scale.png",
//                width: 40,
//                height: 40,
//              ),
            ),
            DataItem(
              key: "Extra Stops",
              value: "${selectedTrip.extraStops ?? "xx"}",
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/images/stop.png",
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ]),
//          SizedBox(height: 30),
          accept,
        ],
      ),
    );
  }

  Container get dateWidget => Container(
        color: Constants.orange,
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/calender2.png",
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Start date"),
                      Text(
                          DateFormat("EEE, dd MMM").format(trips[0].startDate)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              width: 1,
              color: Colors.black45,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/calender2.png",
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("end date"),
                      //todo calculate start date and end date
                      Text(DateFormat("EEE, dd MMM").format(trips[0].endDate)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
