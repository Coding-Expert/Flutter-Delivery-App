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
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_id/device_id.dart';
import 'package:nfl_app/models/user_model.dart';
import 'package:geolocator/geolocator.dart';

class DeliverRequestScreen extends StatefulWidget {
  @override
  _DeliverRequestScreenState createState() => _DeliverRequestScreenState();
}

class _DeliverRequestScreenState extends State<DeliverRequestScreen> {
  bool loading = true;

  List<Trip> trips;
  List<Trip> trips1;
  int _index = 0;
  String start_date = "";
  String end_date = "";
  String deviceId = "";

  // Trip get selectedTrip => trips[_index];

  //todo sort orders
  List<Order> get allOrders =>
      [for (var trip in trips) ...trip.orders]..sort((x, y) {
          return x.date.compareTo(y.date);
        });

  bool get accepted => !LoadsModule.trips1.any((element) => !element.accepted);

  get progress => 0.0;

  @override
  void initState() {
    
    init();
    super.initState();
  }
  Future<String> getDeviceID()  async {
    return await DeviceId.getID;
  }

  Future<void> init() async {
    if (!loading) {
      setState(() {
        loading = true;
      });
    }
    await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LoadsModule.acceptLoadForDrivers()
        .then((value) => setState(() {
              trips = LoadsModule.trips1;
              LoadsModule.init()
                .then((value) => setState(() {
                    trips1 = LoadsModule.trips;
                    print("trips loading get value -----------${trips1.length}");
                    loading = false;
              })).catchError((err) {
                print(err.toString());
                print("loads loading get error $err ----------");
                trips = [];
                loading = false;
              });
        })).catchError((err) {
          print(err.toString());
          print("acceptloads loading get error $err ----------");
          trips = [];
          loading = false;
        });
  }
  logout(BuildContext context) async {
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    SharedPreferences sh = await SharedPreferences.getInstance();
    await sh.remove("number");
    Navigator.pushReplacementNamed(context, "/");
  }
  verifyDevice(BuildContext context){
    getDeviceID().then((id){
      UserModel.verifyDevice(id).then((value){
        if(value == "0"){
          logout(context);
        }
      });
    });
    
  }
  @override
  Widget build(BuildContext context) {
    verifyDevice(context);
    
    if (loading) {
      return Material(
        child: Center(
          // child: SpinKitCubeGrid(
          //   color: Theme.of(context).primaryColor,
          // ),
          child: Image.asset("assets/images/itruck-loader.gif",width: 60, height: 60),
        ),
      );
    } 
    else if (trips == null && trips1 == null) {
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

          // child: SpinKitCubeGrid(
          //   color: Theme.of(context).primaryColor,
          // ),
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
      child: (trips.isNotEmpty || trips1.isNotEmpty)
      // child: (trips.isNotEmpty)
          ? ListView(
              physics: BouncingScrollPhysics(),
              children: [
                dateWidget(context),
                SizedBox(height: 10),
                //  ProgressWidget(trip: selectedTrip),
                
                for (var trip in trips)
                    EachRequest(
                      trips: trip,
                    ),
                  
                
                for (var trip1 in trips1)
                    EachRequest(
                      trips: trip1,
                    )
              ],
            )
          : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  dateWidget(context),
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.refresh),
                              onPressed: init,
                            ),
                            Text("there are no trips"),
                          ]
                        )
                      ),
                    )
                  ),
                  
                ],
              ),
    );
  }

  Container dateWidget(BuildContext context){
    return Container(
        color: Constants.orange,
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap:() async {
                      DateTime newDateTime = await showRoundedDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year - 1),
                        lastDate: DateTime(DateTime.now().year + 1),
                        borderRadius: 2,
                      );
                      if (newDateTime != null) {
                        setState(() {
                          start_date = newDateTime.year.toString() + "-" + newDateTime.month.toString() + "-" + newDateTime.day.toString();
                          loading = true;
                        });
                        trips.clear();
                        trips1.clear();
                        LoadsModule.loadsBetween(start_date, end_date)
                            .then((value) => setState(() {
                                  print("trips loading get value -----------");
                                  trips = LoadsModule.trips;
                                  loading = false;
                                }))
                            .catchError((err) {
                          print(err.toString());
                          print("trips loading get error $err ----------");
                          trips = [];
                        });
                      }
                    },
                    child: Image.asset(
                      "assets/images/calender2.png",
                      width: 50,
                      height: 50,
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Start date"),
                      // Text(
                      //     DateFormat("EEE, dd MMM").format(trips[0].startDate)),
                      Text(start_date),
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
                  GestureDetector(
                    onTap:() async {
                      DateTime newDateTime = await showRoundedDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year - 1),
                        lastDate: DateTime(DateTime.now().year + 1),
                        borderRadius: 2,
                      );
                      if (newDateTime != null) {
                        setState(() {
                          end_date = newDateTime.year.toString() + "-" + newDateTime.month.toString() + "-" + newDateTime.day.toString();
                          loading = true;
                        });
                        trips.clear();
                        trips1.clear();
                        LoadsModule.loadsBetween(start_date, end_date)
                            .then((value) => setState(() {
                                  print("trips loading get value -----------");
                                  trips = LoadsModule.trips;
                                  loading = false;
                                }))
                            .catchError((err) {
                          print(err.toString());
                          print("trips loading get error $err ----------");
                          trips = [];
                        });
                      }
                    },
                    child: Image.asset(
                      "assets/images/calender2.png",
                      width: 50,
                      height: 50,
                    ),
                    
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("End date"),
                      //todo calculate start date and end date
                      Text(end_date),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}

class EachRequest extends StatelessWidget {
  final Trip trips;

  const EachRequest({
    Key key,
    this.trips,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OrderWidget(
          order: trips.orders[0],
          last: false,
          consignees: trips.consignees.toSet().toList(),
          shippers: trips.shippers.toSet().toList(),
        ),

        DataWidget(data: [
          DataItem(
            key: "Temp in " +String.fromCharCodes(new Runes('\u00B0')) + "F",
            value: "${trips.temp ?? "DRY"}",
//            icon: Image.asset(
//              "assets/images/temperature.png",
//              width: 30,
//              height: 30,
//            ),
          ),
          DataItem(
            key: "Weight in lbs",
            value: "${trips.weight ?? "xx"}",
//            icon: Image.asset(
//              "assets/images/scale.png",
//              width: 40,
//              height: 40,
//            ),
          ),
          DataItem(
            key: "Extra Stops",
            value: "${trips.extraStops - 2 < 0 ? 0 : trips.extraStops - 2}",
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/stop.png",
                width: 30,
                height: 30,
              ),
            ),
          ),
          DataItem(
            key: "Load No",
            value: "${trips.loadId}",
//            icon: Image.asset(
//              "assets/images/scale.png",
//              width: 40,
//              height: 40,
//            ),
          ),
        ]),
//          SizedBox(height: 30),
        AcceptButton(
          selectedTrip: trips,
        ),

        Divider(),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class AcceptButton extends StatefulWidget {
  final Trip selectedTrip;

  const AcceptButton({Key key, this.selectedTrip}) : super(key: key);

  @override
  _AcceptButtonState createState() => _AcceptButtonState();
}

class _AcceptButtonState extends State<AcceptButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Constants.lightGreen,
              colorBrightness: Brightness.dark,
              child: Text(widget.selectedTrip.accepted ? "DETAILS" : "ACCEPT"),
              //todo set this function
              onPressed: widget.selectedTrip.accepted
                  ? () => Navigator.pushNamed(context, "/details",
                      arguments: {'exampleArgument': widget.selectedTrip})
                  : () async {
                      setState(() {
                        loading = true;
                      });
                      await LoadsModule.acceptAll(widget.selectedTrip).then((value) {
                        setState(() {
                          widget.selectedTrip.accepted = true;
                          loading = true;
                        });
                      });
                    },
            ),
          ),
        ),
        Expanded(
          child: AnimatedBorderWidget(
            color: DateTime.now().isAfter(widget.selectedTrip.endDate)
                ? Constants.red
                : DateTime.now()
                        .add(widget.selectedTrip.deliveryTime ?? Duration())
                        .isAfter(widget.selectedTrip.endDate)
                    ? Constants.orange
                    : Constants.lightGreen,
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
                          DateTime.now().isAfter(widget.selectedTrip.endDate)
                              ? "late"
                              : DateTime.now()
                                      .add(widget.selectedTrip.deliveryTime ??
                                          Duration())
                                      .isAfter(widget.selectedTrip.endDate)
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
                            text: widget.selectedTrip.deliveryTime != null
                                ? "${widget.selectedTrip.deliveryTime.toString().split(':')[0]}" + " : " + "${widget.selectedTrip.deliveryTime.toString().split(':')[1]}"
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
  }
}
