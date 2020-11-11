import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nfl_app/models/loads_module.dart';
import 'package:nfl_app/models/location_module.dart';
import 'package:nfl_app/screens/map_screen.dart';
import 'package:nfl_app/utils/constants.dart';
import 'package:nfl_app/utils/order.dart';
import 'package:nfl_app/utils/trip.dart';
import 'package:nfl_app/widget/animated_border_widget.dart';
import 'package:nfl_app/widget/bottom_navigation.dart';
import 'package:nfl_app/widget/check_button.dart';
import 'package:nfl_app/widget/check_button1.dart';
import 'package:nfl_app/widget/circle_of_time.dart';
import 'package:nfl_app/widget/data_widget.dart';
import 'package:nfl_app/widget/my_appbar_widget.dart';
import 'package:nfl_app/widget/my_drawer_widget.dart';
import 'package:nfl_app/widget/progress_widget.dart';
import 'package:toast/toast.dart';

import 'package:flutter/material.dart';

Trip selectedTrip;

class DeliveryDetails extends StatelessWidget {
  final Trip selectedTrip;

  const DeliveryDetails({Key key, this.selectedTrip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TripDetailsScreen(
      selectedTrip: selectedTrip,
    );
  }
}

class TripDetailsScreen extends StatefulWidget {
  final Trip selectedTrip;

  const TripDetailsScreen({Key key, this.selectedTrip}) : super(key: key);

  @override
  _TripDetailsScreenState createState() => _TripDetailsScreenState();
}
const Map<String,int> monthsInYear = {
  "Jan" : 01,
  "February" : 02,
  "Mar" : 03,
  "Apr" : 04,
  "May" : 05,
  "Jun" : 06,
  "Jul" : 07,
  "Aug" : 08,
  "Sep" : 09,
  "Oct" : 10,
  "Nov" : 11,
  "Dec" : 12
};
class _TripDetailsScreenState extends State<TripDetailsScreen> {
  List<Order> get orders =>
      [for (var trip in LoadsModule.trips) ...trip.orders];

  bool uploading = false;
  bool checking = false;
  bool isPickup = false;

  int inOutIndex = 0;
  int inOutIndex1 = 0;

  int selectedOrderIndex = 1;

  String selectedLocationName = '-';
  String selectedName = "";
  List<String> check_trip = new List<String>();
  String checkin_time="";
  String checkout_time="";
  Timer location_timer;
  Timer send_locationTime;

  // Order selectedOrder ;
  Order get selectedOrder => orders[selectedOrderIndex];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedLocationName = widget.selectedTrip.consignees[0].consigneeaddress;
    selectedName = widget.selectedTrip.consignees[0].consigneename;
    inOutIndex1 = widget.selectedTrip.shippers.length + inOutIndex;
    if(widget.selectedTrip.checkInList[inOutIndex1] == "null" || widget.selectedTrip.checkInList[inOutIndex1] == ""){
      checkin_time = "00:00";
    }
    else{
      checkin_time = widget.selectedTrip.checkInList[inOutIndex1].split("##")[1];
    }
    if(widget.selectedTrip.checkOutList[inOutIndex1] == "null" || widget.selectedTrip.checkOutList[inOutIndex1] == ""){
      checkout_time = "00:00";
    }
    else{
      checkout_time = widget.selectedTrip.checkOutList[inOutIndex1].split("##")[1];
    }
    location_timer = Timer.periodic(Duration(minutes: 5), (Timer t) => saveLocation());
    send_locationTime = Timer.periodic(Duration(minutes: 10), (Timer t) => sendLoaction());
    //selectedTrip.checkOutList.insert(0,"");
  }
  saveLocation() {
    LoadsModule.saveCurrentLocation();
  }
  sendLoaction() {
    LoadsModule.sendCurrentLocation(widget.selectedTrip).then((value){
      }
    );
  }
  @override
  void dispose() {
    location_timer?.cancel();
    send_locationTime?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   // print("Slected Trip" + widget.selectedTrip.checkOutList.toString());
    //print("SelectedTrip" + widget.selectedTrip.orders[0].toString());
    //selectedOrder=selectedTrip.orders[0]; //todo

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/map.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(8),
        children: [
          topIcon,
          SizedBox(height: 5),
          ProgressWidget(
            trip: widget.selectedTrip,
            isPickup: false,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isPickup ? "Pickup" : "Delivery",
                style: TextStyle(
                  color: isPickup ? Constants.blue : Constants.darkGreen,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(
                      trip: widget.selectedTrip,
                      distance: distance1,
                      time: timeinHours,
                    ),
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Image.asset("assets/images/road-sign.png"),
                      ),
                      TextSpan(
                        text: " Get Directions",
                        style: Constants.smallTextRed,
                      ),
                    ],
                  ),
                ),
              ),
              VerticalDivider(),
            ],
          ),
          title,
          DataWidget(data: [
            DataItem(
              key: "Temp in " +String.fromCharCodes(new Runes('\u00B0')) + "F",
              value: "${widget.selectedTrip.temp ?? "DRY"}" ?? "DRY",
//              icon: Image.asset(
//                "assets/images/temperature.png",
//                width: 30,
//                height: 30,
//              ),
            ),
            DataItem(
              key: "Weight in lbs",
              value: "${widget.selectedTrip.consignees[inOutIndex].consigneeweight ?? "x"}",
//              icon: Image.asset(
//                "assets/images/scale.png",
//                fit: BoxFit.fill,
//                width: 50,
//              ),
            ),
            DataItem(
              key: "Extra Stops",
              value: "${widget.selectedTrip.extraStops - 2 < 0 ? 0 : widget.selectedTrip.extraStops - 2}",
              icon: Image.asset(
                "assets/images/stop.png",
                width: 30,
                height: 30,
              ),
            ),
            DataItem(
              key: "Load No",
              value: "${widget.selectedTrip.loadId}",
            ),
          ]),
          DataWidget(
            data: [
              DataItem(
                key: "Quantity",
                value: "${widget.selectedTrip.consignees[inOutIndex].consigneequantity ?? "x"}",
              ),
              DataItem(
                key: "Pallets",
                value: "${widget.selectedTrip.consignees[inOutIndex].consigneepallets ?? "x"}",
              ),
              DataItem(
                key: "Boxes",
                value: "${widget.selectedTrip.consignees[inOutIndex].consigneeboxes ?? "0"}",
              ),
              DataItem(
                key: "Units",
                value: "${widget.selectedTrip.consignees[inOutIndex].consigneeunits ?? "0"}",
              ),
            ],
          ),
          DataWidget(
            data: [
              DataItem(
                key: "Delivery No",
                value: "${widget.selectedTrip.consignees[inOutIndex].consigneedeliverynumber ?? "x"}",
//                icon: Image.asset(
//                  "assets/images/pallet.png",
//                  width: 30,
//                  height: 30,
//                ),
              ),
              DataItem(
                key: "Reference No",
                value: "${widget.selectedTrip.consignees[inOutIndex].consigneedeliveryref ?? "x"}",
//                icon: Image.asset(
//                  "assets/images/box.png",
//                  width: 30,
//                  height: 30,
//                ),
              ),
              DataItem(
                key: "PO No",
                value: "${widget.selectedTrip.consignees[inOutIndex].consigneepurchaseorder ?? "x"}",
//                icon: Image.asset(
//                  "assets/images/unit.png",
//                  width: 30,
//                  height: 30,
//                ),
              ),
            ],
          ),
          DataWidget(
            data: [
              DataItem(
                key: "Appointment-time",
                value: "${widget.selectedTrip.consignees[inOutIndex].conapptime == "NA" ? "FCFS" : widget.selectedTrip.consignees[inOutIndex].conapptime}",
//                icon: Image.asset(
//                  "assets/images/calendar.png",
//                  width: 30,
//                  height: 30,
//                ),
              ),
              DataItem(
                key: "Contact Person",
                value: "${widget.selectedTrip.consignees[inOutIndex].concpn ?? "x"}",
//                icon: Image.asset(
//                  "assets/images/person.png",
//                  width: 30,
//                  height: 30,
//                ),
              ),
            ],
          ),
          DataWidget(
            data: [
              DataItem(
                key: "Hours",
                value: "${widget.selectedTrip.consignees[inOutIndex].con_hours ?? "x"}",
//                icon: Image.asset(
//                  "assets/images/clock.png",
//                  width: 30,
//                  height: 30,
//                ),
              ),
              DataItem(
                key: "Contact No",
                value: "${widget.selectedTrip.consignees[inOutIndex].concpp ?? "x"}",
//                icon: Image.asset(
//                  "assets/images/phone.png",
//                  width: 30,
//                  height: 30,
//                ),
              ),
            ],
          ),
          DataWidget(
            data: [
              DataItem(
                key: "Commodity",
                value: "${widget.selectedTrip.commodity ?? "No commodity"}",
//                icon: Image.asset(
//                  "assets/images/commodity.png",
//                  width: 30,
//                  height: 30,
//                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Notes : ",
                    style: TextStyle(color: Constants.red),
                  ),
                  TextSpan(
                    text: "${widget.selectedTrip.notes ?? "No notes"}",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          checkButton,
          SizedBox(height: 15),
          time,
          SizedBox(height: 30),
        ],
      ),
    );
  }

  get time => Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Constants.lightBlue,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Image.asset("assets/images/clock.png", width: 40),
                  VerticalDivider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Check in"),
                      Text(
                        widget.selectedTrip.checkInList[inOutIndex1] == "null" ? "00:00" : widget.selectedTrip.checkInList[inOutIndex1].split("##")[1],
                        style: Constants.timeText,
                      ),
                      
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 1.5,
              height: 40,
              color: Constants.lightBlue,
              margin: EdgeInsets.symmetric(horizontal: 10),
            ),
            Expanded(
              child: Row(
                children: [
                  Image.asset("assets/images/clock.png", width: 40),
                  VerticalDivider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Check out"),
                      Text(
                        widget.selectedTrip.checkOutList[inOutIndex1] == "null" ? "00:00" : widget.selectedTrip.checkOutList[inOutIndex1].split("##")[1],
                        style: Constants.timeText,
                      ),
                      // Text(checkout_time.isNotEmpty ? checkout_time : "00:00",
                      //   style: Constants.timeText,
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Row get checkButton => Row(
        children: [
          Expanded(
            child: checking
                ? Center(
                    child: SpinKitCubeGrid(
                      color: Constants.darkGreen,
                    ),
                  )
                : CheckButton1(
                    enable: 
                        ((widget.selectedTrip.checkInList[inOutIndex1] !=
                                "null") &&
                            (widget.selectedTrip.checkOutList[inOutIndex1] !=
                                "null")),
                    // checkedIn: true,
                    // checkedIn: (selectedLocationName == null ||
                    //         selectedLocationName == '-')
                    //     ? false
                    //     : widget.selectedTrip.checkInList
                    //             .elementAt(inOutIndex1) !=
                    //         "null",
                    checkedIn: widget.selectedTrip.checkInList[inOutIndex1] != "null",
                    freezeChecking: widget.selectedTrip.checkOutList.elementAt(inOutIndex1-1) != "null" ? true : false,
//                    (widget.selectedTrip?.checkInList
//                                    ?.elementAt(inOutIndex ?? 0) ??
//                                "Incomplete") !=
//                            "Incomplete",

                    checkInFunction: checkIn,
                    checkOutFunction: checkOut,
                  ),
          ),
          SizedBox(width: 5),
          uploading
              ? Center(
                  child: SpinKitCubeGrid(
                    color: Constants.darkGreen,
                  ),
                )
              : Theme(
                  data: ThemeData(
                    buttonTheme: ButtonThemeData(
                      buttonColor: Constants.lightGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 60,
                    ),
                  ),
                  child: RaisedButton.icon(
                    onPressed: upload,
                    icon: Image.asset(
                      "assets/images/file-upload.png",
                      width: 30,
                      color: Colors.white,
                    ),
                    label: Text(
                      "UPLOAD\nE-DOCS",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
        ],
      );

  upload() async {
    setState(() {
      uploading = true;
    });

    LoadsModule.upload(widget.selectedTrip.loadId).then(
      (value) => setState(() {
        uploading = false;
      }),
    );
  }
  
  checkIn() {
    //  print("CHECKIN FUNCTION"+selectedTrip.checkInList[inOutIndex].toString());
    setState(() {
      checking = true;
    });
    // LoadsModule.checkIn(
    //         widget.selectedTrip,
    //         inOutIndex + 1,
    //         (isPickup)
    //             ? widget
    //                 .selectedTrip.consignees[inOutIndex - 1].consigneeaddress
    //             : widget.selectedTrip.shippers[inOutIndex - 1].shipperaddress)
    //     .then((value) {
    //   setState(() {
    //     checking = false;
    //     //int index = selectedOrderIndex;
    //     //if (index + 1 < orders.length) index++;
    //     //selectedOrderIndex = index;
    //   });
    // });
    LoadsModule.checkIn(widget.selectedTrip, inOutIndex1, "delivery")
        .then((value) {
          check_trip.clear();
          check_trip = LoadsModule.checkin_result;
          setState(() {
            checking = false;
            checkin_time = check_trip[inOutIndex1].split("##")[1];
            widget.selectedTrip.checkInList[inOutIndex1] = check_trip[inOutIndex1];
            //int index = selectedOrderIndex;
            //if (index + 1 < orders.length) index++;
            //selectedOrderIndex = index;
          });
        })
        .catchError((err) {
          print(err.toString());
          check_trip.clear();
        });
  }

  checkOut() {
    setState(() {
      checking = true;
    });
    LoadsModule.checkOut(widget.selectedTrip, inOutIndex, inOutIndex1, "delivery").then((value) {
      check_trip.clear();
      check_trip = LoadsModule.checkout_result;
      setState(() {
        checking = false;
        checkout_time = check_trip[inOutIndex1].split("##")[1];
        widget.selectedTrip.checkOutList[inOutIndex1] = check_trip[inOutIndex1];
        // int index = selectedOrderIndex;
        // if (index + 1 < orders.length) index++;
        // selectedOrderIndex = index;
      });
    }).catchError((e) {
      checking = false;
      check_trip = [];
      Toast.show(
        e.toString().split(":").last,
        context,
      );
    });
  }

  Row get title => Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(selectedName, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(selectedLocationName, style: Constants.darkText),
              ]
            ),
          ),
          FutureBuilder <Distance>(
            future: Distance.distanceTo(widget.selectedTrip.consignees[inOutIndex].conaddresslat, widget.selectedTrip.consignees[inOutIndex].conaddresslng),
            builder: (context, snapshot) {
              return Expanded(
                child: snapshot.data == null ? Container():
                    AnimatedBorderWidget(
                      color: getdifferentTime() < double.parse((snapshot.data.time / 3600).toStringAsFixed(2))*60 ? Constants.red : 
                            getdifferentTime() >= double.parse((snapshot.data.time / 3600).toStringAsFixed(2))*60 && getdifferentTime() - double.parse((snapshot.data.time / 3600).toStringAsFixed(2))*60 <= 30 ? Constants.orange :
                            Constants.green,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: FittedBox(
                                child: Text(getdifferentTime() < double.parse((snapshot.data.time / 3600).toStringAsFixed(2))*60 ? "Late for Delivery " :
                                        getdifferentTime() >= double.parse((snapshot.data.time / 3600).toStringAsFixed(2))*60 && getdifferentTime() - double.parse((snapshot.data.time / 3600).toStringAsFixed(2))*60 <= 30 ? "Running Late for Delivery " :
                                        "On Time for Delivery ")
                              ),
                            ),
                            snapshot.data == null ?
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SpinKitCubeGrid(
                                  color: Constants.darkGreen,
                                  size: 15,
                                ),
                              ):
                              RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: getdifferentTime() < 0 ? "0.00" : (getdifferentTime() / 60).toStringAsFixed(2),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "Hrs",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                      ),
                    )
              );
            },
          ),

//           Expanded(
//             child: AnimatedBorderWidget(
//               color: Constants.darkGreen,
// //              color:(widget.selectedTrip.shippers==null)?Constants.darkGreen: DateTime.now().isAfter(DateTime.tryParse(widget.selectedTrip.shippers[inOutIndex].shippingtime))
// //                  ? Constants.red
// //                  : Constants.green,
//               child: Container(
//                 padding: EdgeInsets.all(8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: FittedBox(child: Text("on Time for Delivery ")),
//                     ),
//                     FutureBuilder<Distance>(
//                       future: Distance.distanceTo(selectedLocationName),
//                       builder: (context, snapshot) {
//                         if (snapshot.data == null)
//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: SpinKitCubeGrid(
//                               color: Constants.darkGreen,
//                               size: 15,
//                             ),
//                           );
//                         return RichText(
//                           text: TextSpan(
//                             children: [
//                               TextSpan(
//                                 text: snapshot.data.timeDuration
//                                     .toString()
//                                     .substring(
//                                       0,
//                                       snapshot.data.timeDuration
//                                           .toString()
//                                           .lastIndexOf(":"),
//                                     ),
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: "Hrs",
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 15,
//                                 ),
//                               ),
//                               // TextSpan(
//                               //   text: "  reach at " +
//                               //       (widget.selectedTrip.shippers[inOutIndex]
//                               //           .shippingtime),
//                               //   style: TextStyle(
//                               //     color: Colors.black,
//                               //     fontWeight: FontWeight.bold,
//                               //     fontSize: 15,
//                               //   ),
//                               // ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
        ],
      );
  int getdifferentTime(){
    DateTime now = DateTime.now();
    DateTime currentDate = DateTime.utc(now.year, now.month, now.day, now.hour, now.minute);
    int current_pickYear = int.parse(widget.selectedTrip.consignees[inOutIndex].consigneedate.split(',')[1]);
    int current_pickMonth = monthsInYear[widget.selectedTrip.consignees[inOutIndex].consigneedate.split(',')[0].split(' ')[0]];
    int current_pickDay = int.parse(widget.selectedTrip.consignees[inOutIndex].consigneedate.split(',')[0].split(' ')[1]);
    int current_pickHour = int.parse(widget.selectedTrip.consignees[inOutIndex].consigneetime.split(':')[0]);
    int current_pickMinute = int.parse(widget.selectedTrip.consignees[inOutIndex].consigneetime.split(':')[1]);
    DateTime current_pickDate = DateTime.utc(current_pickYear, current_pickMonth, current_pickDay, current_pickHour, current_pickMinute);
    int different_minutes = current_pickDate.difference(currentDate).inMinutes;
    return different_minutes;
  }

  Widget get directions => Center(
        child: FlatButton.icon(
          onPressed: () {},
          icon: Icon(Icons.directions),
          label: Text("get Directions"),
          textColor: Constants.red,
          padding: EdgeInsets.all(0),
        ),
      );

  get topIcon => Row(
        children: [
//          Expanded(
//            child: Container(
//              height: 100,
//              child: ListView.separated(
//                padding: EdgeInsets.symmetric(horizontal: 20),
//                itemCount: widget.selectedTrip.shippers.length,
//                itemBuilder: (context, index1) {
//                  // Order order = selectedTrip.orders[index];
//
//                  //selectedLocationName=selectedTrip.shippers[0].shipperaddress;
//                  return GestureDetector(
//                    onTap: () {
//                      print("INDEX" + index1.toString());
//                      topIconClick(
//                          widget.selectedTrip.shippers[index1].shipperaddress,
//                          index1);
//                    },
//                    child: CircleOfTime1(
//                      selected: selectedLocationName ==
//                          widget.selectedTrip.shippers[index1].shipperaddress,
//                      date: widget.selectedTrip.shippers[index1].shippingdate,
//                      time: widget.selectedTrip.shippers[index1].shippingtime,
//                      color: Constants.lightBlue,
//                    ),
//                  );
//                },
//                separatorBuilder: (context, index) => SizedBox(
//                  width: 20,
//                ),
//                scrollDirection: Axis.horizontal,
//              ),
//            ),
//          ),
          Expanded(
            child: Container(
              height: 60,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: widget.selectedTrip.consignees.length,
                itemBuilder: (context, index) {
                  // Order order = selectedTrip.orders[index];
                  //selectedLocationName=selectedTrip.consignees[0].consigneeaddress;
                  return GestureDetector(
                    onTap: () {

                      topIconClick1(
                          widget
                              .selectedTrip.consignees[index].consigneeaddress,
                          widget
                              .selectedTrip.consignees[index].consigneename,
                          index);
                    },
                    child: CircleOfTime2(
                      selected: selectedLocationName ==
                          widget
                              .selectedTrip.consignees[index].consigneeaddress,
                      date: widget.selectedTrip.consignees[index].consigneedate,
                      time: widget.selectedTrip.consignees[index].consigneetime,
                      color: Constants.lightGreen,
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                  width: 20,
                ),
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
        ],
      );

  topIconClick(String order, int index) {

    setState(() {
      //selectedTrip = selectedTrip;

      //selectedOrderIndex = selectedTrip.orders.indexOf(order);
      isPickup = true;
      inOutIndex = index;
      inOutIndex1 = widget.selectedTrip.shippers.length + inOutIndex;
      selectedLocationName = order;
    });
  }

  topIconClick1(String order, String name, int index) {
    //print("INDEX 1" + index.toString());
    //consignee  delivery
    setState(() {
      //selectedTrip = selectedTrip;

      //selectedOrderIndex = selectedTrip.orders.indexOf(order);
      isPickup = true;
      inOutIndex = index; //+ widget.selectedTrip.shippers.length;
      inOutIndex1 = widget.selectedTrip.shippers.length + inOutIndex;
      selectedLocationName = order;
      selectedName = name;
      
    });
  }

  bottomNavTap(int p) {
    if (p == 4 || p == 3) {
      return;
    } else {
      StoreProvider.of<int>(context).dispatch(p);
      Navigator.pop(context);
    }
  }
}
