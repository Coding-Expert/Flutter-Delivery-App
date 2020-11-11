import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:nfl_app/models/loads_module.dart';
import 'package:nfl_app/models/location_module.dart';
import 'package:nfl_app/utils/constants.dart';
import 'package:nfl_app/utils/order.dart';
import 'package:nfl_app/utils/trip.dart';

String timeinHours;
double distance1 = 0;
List responses;
List address = List<String>();
List listAsync = List<Distance>();
double remain_distance = 0;
String remain_time;

class ProgressWidget extends StatefulWidget {
  final Trip trip;
  final Order selectedOrder;
  final bool isPickup;
  final Function getTime;
  static const Color color = Constants.lightGreen;

  const ProgressWidget({
    Key key,
    this.selectedOrder,
    this.trip,
    this.isPickup,
    this.getTime
  }) : super(key: key);

  @override
  _ProgressWidgetState createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget> {
  bool loader = true;

  double progress = 0;

  Duration time = Duration(hours: 0);
  String complete = "";
  String next_milestone = "";
  String milestone = "";
  String load_number = "";
  int milestone_number = 0;
  int dot_count = 0;
  double truck_progress = 0;
  double truck_positionX = 0;
  // String time;

  @override
  void initState() {
    dot_count = widget.trip.shippers.length + widget.trip.consignees.length;
    init().then((value) => setState(() {
          loader = false;
        }));

    super.initState();
  }

  Future init() async {
    // var sendCurrent = await LoadsModule.sendCurrentLocation(widget.trip);
    //
    // todo send current location

    // var totalDistance = await Distance.calculateTime(
    //   widget.trip.orders.first.locationName,
    //   widget.trip.orders.last.locationName,
    // );

    // if (widget.selectedOrder == null) {
      // print("selected order is null");
      /*   this.distance = totalDistance.distance;
      this.time = totalDistance.timeDuration;*/

      if (widget.isPickup) {
        address.clear();
        listAsync.clear();
        for (int i = 0; i < widget.trip.shippers.length + widget.trip.consignees.length; i++) {
          // if (widget.isPickup) {
            // print("Progress widget if" + widget.trip.checkInList.toString());
            // if (widget.trip.checkInList[widget.trip.shippers.indexOf(i)] ==
              if(widget.trip.checkOutList[i] == "null"){
                if(i == 0){
                  milestone = "Pickup";
                  load_number = (i+1).toString();
                  // address.add("${widget.trip.shippers[i].shipperaddress} Pickup");
                  address.add(widget.trip.shippers[i].ship_pickup_latitude);
                  address.add(widget.trip.shippers[i].ship_pickup_longitude);
                  await Distance.distanceTo1("", "", widget.trip.shippers[i].ship_pickup_latitude, widget.trip.shippers[i].ship_pickup_longitude, i).then((value)
                   {
                     if(value != null){
                        listAsync.add(value);
                      }
                   }
                  );
                }
                if(i > 0 && i < widget.trip.shippers.length){
                  milestone = "Pickup";
                  load_number = (i+1).toString();
                  // address.add("${widget.trip.shippers[i].shipperaddress} Pickup");
                  address.add(widget.trip.shippers[i].ship_pickup_latitude);
                  address.add(widget.trip.shippers[i].ship_pickup_longitude);
                  await Distance.distanceTo1(widget.trip.shippers[i- 1].ship_pickup_latitude, widget.trip.shippers[i- 1].ship_pickup_longitude, widget.trip.shippers[i].ship_pickup_latitude, widget.trip.shippers[i].ship_pickup_longitude, i).then((value){
                    if(value != null){
                      listAsync.add(value);
                    }
                  });
                }
                if(i == widget.trip.shippers.length){
                  milestone = "Delivery";
                  load_number = "0";
                  // address.add("${widget.trip.consignees[0].consigneeaddress} Delivery");
                  address.add(widget.trip.consignees[0].conaddresslat);
                  address.add(widget.trip.consignees[0].conaddresslng);
                  await Distance.distanceTo1(widget.trip.shippers[i - 1].ship_pickup_latitude, widget.trip.shippers[i - 1].ship_pickup_longitude, widget.trip.consignees[0].conaddresslat, widget.trip.consignees[0].conaddresslng, i).then((value){
                    if(value != null){
                      listAsync.add(value);
                    }
                  });
                }
                if(i > widget.trip.shippers.length){
                  milestone = "Delivery";
                  load_number = (i - widget.trip.shippers.length).toString();
                  // address.add("${widget.trip.consignees[i - widget.trip.shippers.length].consigneeaddress} Delivery");
                  address.add(widget.trip.consignees[i - widget.trip.shippers.length].conaddresslat);
                  address.add(widget.trip.consignees[i - widget.trip.shippers.length].conaddresslng);
                  await Distance.distanceTo1(widget.trip.consignees[i - widget.trip.shippers.length - 1].conaddresslat, widget.trip.consignees[i - widget.trip.shippers.length - 1].conaddresslng, widget.trip.consignees[i - widget.trip.shippers.length].conaddresslat, widget.trip.consignees[i - widget.trip.shippers.length].conaddresslng, i).then((value){
                    if(value != null){
                      listAsync.add(value);
                    }
                  });
                }
                distance1 = listAsync.elementAt(0).distance;
                timeinHours = (listAsync.elementAt(0).time / 3600).toStringAsFixed(2);
                Distance d;
                await Distance.distanceTo(address.elementAt(0), address.elementAt(1)).then((value){
                  if(value != null){
                    d = value;
                    remain_distance = d.distance;
                    remain_time = (d.time / 3600).toStringAsFixed(2);
                    milestone_number = i;
                    truck_progress = (((remain_distance/distance1) * 100)*(1 + (milestone_number * (1 / (dot_count)))))/100;
                    truck_positionX = (1 + (milestone_number * (1 / (dot_count)))) -truck_progress < 1 ? (-1 + ((1 + (milestone_number * (1 / (dot_count)))) - truck_progress)) : truck_progress;
                  }
                });
                break;
              }
        }
      } else {
        address.clear();
        listAsync.clear();
        for (int i = 0; i < widget.trip.shippers.length + widget.trip.consignees.length; i++){
          if(widget.trip.checkOutList[i] == "null"){
            if(i == 0){
              milestone = "Pickup";
              load_number = (i+1).toString();
              // address.add("${widget.trip.shippers[i].shipperaddress} Pickup");
              address.add(widget.trip.shippers[i].ship_pickup_latitude);
              address.add(widget.trip.shippers[i].ship_pickup_longitude);
              listAsync.add(await Distance.distanceTo1("", "",widget.trip.shippers[i].ship_pickup_latitude,widget.trip.shippers[i].ship_pickup_longitude, i));
            }
            if(i > 0 && i < widget.trip.shippers.length){
              milestone = "Pickup";
              load_number = (i+1).toString();
              // address.add("${widget.trip.shippers[i].shipperaddress} Pickup");
              address.add(widget.trip.shippers[i].ship_pickup_latitude);
              address.add(widget.trip.shippers[i].ship_pickup_longitude);
              listAsync.add(await Distance.distanceTo1(widget.trip.shippers[i- 1].ship_pickup_latitude,widget.trip.shippers[i- 1].ship_pickup_longitude, widget.trip.shippers[i].ship_pickup_latitude, widget.trip.shippers[i].ship_pickup_longitude, i));
            }
            if(i == widget.trip.shippers.length){
              milestone = "Delivery";
              load_number = "1";
              // address.add("${widget.trip.consignees[0].consigneeaddress} Delivery");
              address.add(widget.trip.consignees[0].conaddresslat);
              address.add(widget.trip.consignees[0].conaddresslng);
              listAsync.add(await Distance.distanceTo1(widget.trip.shippers[i - 1].ship_pickup_latitude, widget.trip.shippers[i - 1].ship_pickup_longitude ,widget.trip.consignees[0].conaddresslat, widget.trip.consignees[0].conaddresslng, i));
            }
            if(i > widget.trip.shippers.length){
              milestone = "Delivery";
              load_number = (i - widget.trip.shippers.length).toString();
              // address.add("${widget.trip.consignees[i - widget.trip.shippers.length].consigneeaddress} Delivery");
              address.add(widget.trip.consignees[i - widget.trip.shippers.length].conaddresslat);
              address.add(widget.trip.consignees[i - widget.trip.shippers.length].conaddresslng);
              listAsync.add(await Distance.distanceTo1(widget.trip.consignees[i - widget.trip.shippers.length - 1].conaddresslat, widget.trip.consignees[i - widget.trip.shippers.length - 1].conaddresslng, widget.trip.consignees[i - widget.trip.shippers.length].conaddresslat, widget.trip.consignees[i - widget.trip.shippers.length].conaddresslng, i));
            }
            distance1 = listAsync.elementAt(0).distance;
            timeinHours = (listAsync.elementAt(0).time / 3600).toStringAsFixed(2);
            Distance d;
            await Distance.distanceTo(address.elementAt(0), address.elementAt(1)).then((value){
              if(value != null){
                d = value;
                remain_distance = d.distance;
                remain_time = (d.time / 3600).toStringAsFixed(2);
                milestone_number = i;
                truck_progress = (((remain_distance/distance1) * 100)*(1 + (milestone_number * (1 / (dot_count)))))/100;
                truck_positionX = (1 + (milestone_number * (1 / (dot_count)))) -truck_progress < 1 ? (-1 + ((1 + (milestone_number * (1 / (dot_count)))) - truck_progress)) : truck_progress;
              }
            });
            break;
          }
        }
        
      }
      print("milestone_number:-----------${milestone_number}");
      
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
  Widget getDots(double i, int index){
    return Align(
      alignment: Alignment(i, 0),
      child: Visibility(
        child: getCircle(true),
        visible: index <= milestone_number ? false : true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (!loader)
          ? listAsync.length < 1 || remain_time == null
            ? Container(child: Text("there is no load"),) :
            Column(
              children: [
                for (var i in listAsync)
                  Container(
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
                        Align(
                          alignment: Alignment(1, 0),
                          child: getCircle(false),
                        ),
                        
                        Align(
                            alignment: Alignment((truck_positionX / 2 + (milestone_number * (1 / (dot_count))) / 2), -.3),
                            // child: Text((i.time / 3600).toStringAsFixed(2))
                            child: Text(remain_time)
                            ),
                        Align(
                          alignment: Alignment(-((((remain_distance/i.distance) * 100)*1)/100)/2, .3),
                          child: Text("Drive Time in hrs",
                              style: TextStyle(fontSize: 10)),
                        ),
                        Align(
                          // alignment: Alignment(-.1, -.1),
                          alignment: Alignment((milestone_number * (1 / (dot_count))), -.1),
                          child: Miles(
                            distance1: i.distance,
                            load_type: milestone
                          ),
                        ),
                        Align(
                          alignment: Alignment((milestone_number * (1 / (dot_count))), 1.2),
                          child: Text("${milestone}" + "${load_number}",
                              style: TextStyle(fontSize: 14, color: Colors.black)),
                        ),
                        for(int dot_index = 0; dot_index < dot_count; dot_index++)
                            getDots((dot_index) * (1 / (dot_count)), dot_index),
                        Align(
                          alignment: Alignment(-1, -1),
                          child: Text(
                            "Current .\nLocation",
                            style: Constants.lightTextSmall,
                          ),
                        ),
                        //trunk
                        Align(
                          // alignment: Alignment(progress * 2 - 1, -0.1),
                          alignment: Alignment(truck_positionX, -0.1),
                          child: Image.asset("assets/images/trunk.png", 
                              width: 50, height: 50),
                        ),
                      ],
                    ),
                  )
              ],
            )
          // : SpinKitCubeGrid(
          //     color: Constants.darkGreen,
          //     size: 30,
          //   ),
          :  Image.asset("assets/images/itruck-loader.gif",width: 60, height: 60),
    );
  }
  @override
  void didUpdateWidget(ProgressWidget oldWidget) {
    dot_count = widget.trip.shippers.length + widget.trip.consignees.length;
    setState(() {
      loader = true;
    });
    init().then((value) => setState(() {
      loader = false;
    }));
    super.didUpdateWidget(oldWidget);
  }
}

class Miles extends StatelessWidget {
  final double distance1;
  final String load_type;

  const Miles({Key key, this.distance1, this.load_type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.75,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
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
                        alignment: Alignment.center,
                        child: FittedBox(
                          child: Text(
                            "${load_type}",
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
                              "${(distance1 / 1609).ceil()} \nMiles",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
          ]
        )
      ),
    );
  }
}
