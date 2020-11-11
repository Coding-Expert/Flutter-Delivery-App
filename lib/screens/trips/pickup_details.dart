import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:nfl_app/models/loads_module.dart';
import 'package:nfl_app/models/location_module.dart';
import 'package:nfl_app/screens/map_screen.dart';
import 'package:nfl_app/utils/constants.dart';
import 'package:nfl_app/utils/order.dart';
import 'package:nfl_app/utils/trip.dart';
import 'package:nfl_app/widget/animated_border_widget.dart';
import 'package:nfl_app/widget/check_button.dart';
import 'package:nfl_app/widget/check_button1.dart';
import 'package:nfl_app/widget/circle_of_time.dart';
import 'package:nfl_app/widget/data_widget.dart';
import 'package:nfl_app/widget/progress_widget.dart';
import 'package:flutter/cupertino.dart';


//Trip selectedTrip;
class PickUpDetails extends StatefulWidget {
  final Trip selectedTrip;

  const PickUpDetails({Key key, this.selectedTrip}) : super(key: key);

  @override
  _PickUpDetailsState createState() => _PickUpDetailsState();
}

class _PickUpDetailsState extends State<PickUpDetails> {
  @override
  Widget build(BuildContext context) {
    return TripDetailsScreen(
      selectedTrip: widget.selectedTrip,
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
  bool isPickup = true;

  int inOutIndex = 0;

  int selectedOrderIndex = 1;

  String selectedLocationName = '-';
  String selectedName = "";
  List<String> check_trip = new List<String>();
  String checkin_time="";
  String checkout_time="";
  int selectedIndex = 0;
  String driver_time = "";
  String different_time = "";

  int _sliding = 0;
  // Order selectedOrder ;
  Order get selectedOrder => orders[selectedOrderIndex];
  Timer location_timer;
  Timer send_locationTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedLocationName = widget.selectedTrip.shippers[0].shipperaddress;
    selectedName = widget.selectedTrip.shippers[0].shippername;
    
    if(widget.selectedTrip.checkInList[inOutIndex] == "null" || widget.selectedTrip.checkInList[inOutIndex] == ""){
      checkin_time = "00:00";
    }
    else{
      checkin_time = widget.selectedTrip.checkInList[inOutIndex].split("##")[1];
    }
    if(widget.selectedTrip.checkOutList[inOutIndex] == "null" || widget.selectedTrip.checkInList[inOutIndex] == ""){
      checkout_time = "00:00";
    }
    else{
      checkout_time = widget.selectedTrip.checkOutList[inOutIndex].split("##")[1];
    }
    location_timer = Timer.periodic(Duration(minutes: 1), (Timer t) => saveLocation());
    send_locationTime = Timer.periodic(Duration(minutes: 10), (Timer t) => sendLoaction());
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
            isPickup: true,
            getTime: getDriverTime,
          ),
          SizedBox(height: 10),
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
                      time: widget.selectedTrip.deliveryTime.toString(),//timeinHours,
                      distance: widget.selectedTrip.distance.distance, //distance1,
                      current_lat: widget.selectedTrip.currentLat,
                      current_long: widget.selectedTrip.currentLng,
                      pickup_lat: widget.selectedTrip.shippers[0].ship_pickup_latitude,
                      pickup_long: widget.selectedTrip.shippers[0].ship_pickup_longitude
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
              value: "${widget.selectedTrip.shippers[inOutIndex].shippingweight ?? "x"}",
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
                value: "${widget.selectedTrip.shippers[inOutIndex].shippingquantity ?? "x"}",
              ),
              DataItem(
                key: "Pallets",
                value: "${widget.selectedTrip.shippers[inOutIndex].shippallets ?? "x"}",
              ),
              DataItem(
                key: "Boxes",
                value: "${widget.selectedTrip.shippers[inOutIndex].shipboxes ?? "0"}",
              ),
              DataItem(
                key: "Units",
                value: "${widget.selectedTrip.shippers[inOutIndex].shipunits ?? "0"}",
              ),
            ],
          ),
          DataWidget(
            data: [
              DataItem(
                key: "Pickup No",
                value: "${widget.selectedTrip.shippers[inOutIndex].shippicknumber ?? "x"}",
              ),
              DataItem(
                key: "Reference No",
                value: "${widget.selectedTrip.shippers[inOutIndex].shippickref ?? "x"}",
              ),
              DataItem(
                key: "PO No",
                value: "${widget.selectedTrip.shippers[inOutIndex].purchaseorder ?? "x"}",
              ),
            ],
          ),
          DataWidget(
            data: [
              DataItem(
                key: "Appointment-time",
                value: "${widget.selectedTrip.shippers[inOutIndex].shipappointment == "NA" ? "FCFS" : widget.selectedTrip.shippers[inOutIndex].shipappointment}",
//                icon: Image.asset(
//                  "assets/images/calendar.png",
//                  width: 30,
//                  height: 30,
//                ),
              ),
              DataItem(
                key: "Contact Person",
                value: "${widget.selectedTrip.shippers[inOutIndex].shipcontactpersonname ?? "x"}",
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
                value: "${widget.selectedTrip.shippers[inOutIndex].ship_hours ?? "x"}",
//                icon: Image.asset(
//                  "assets/images/clock.png",
//                  width: 30,
//                  height: 30,
//                ),
              ),
              DataItem(
                key: "Contact No",
                value: "${widget.selectedTrip.shippers[inOutIndex].shipcontactpersonphone ?? "x"}",
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
                        widget.selectedTrip.checkInList[inOutIndex] == "null" ? "00:00" : widget.selectedTrip.checkInList[inOutIndex].split('##')[1],
                        style: Constants.timeText,
                      ),
                      // Text(checkin_time.isNotEmpty ? checkin_time : "00:00",
                      //   style: Constants.timeText,
                      // ),
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
                      Text(widget.selectedTrip.checkOutList[inOutIndex] == "null" ? "00:00" : widget.selectedTrip.checkOutList[inOutIndex].split('##')[1],
                          style: Constants.timeText),
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
                        ((widget.selectedTrip.checkInList
                                    .elementAt(inOutIndex) !=
                                "null")
                                &&
                            (widget.selectedTrip.checkOutList
                                    .elementAt(inOutIndex) !=
                                "null")),
                    // checkedIn: true,
                    checkedIn: widget.selectedTrip.checkInList[inOutIndex] != "null",
                    freezeChecking: inOutIndex == 0 ? true : widget.selectedTrip.checkOutList
                                    .elementAt(inOutIndex-1) !=
                                "null" ? true : false,
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
  getDriverTime(String time){
    driver_time = time;
    // print("driver_time:-------------${driver_time}");
  }
  checkIn() {
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
    LoadsModule.checkIn(widget.selectedTrip, inOutIndex, "pickup")
        .then((value) {
          check_trip.clear();
          check_trip = LoadsModule.checkin_result;
          setState(() {
            checking = false;
            checkin_time = check_trip[inOutIndex].split("##")[1];
            widget.selectedTrip.checkInList[inOutIndex] = check_trip[inOutIndex];
            
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
    });   /// outtime= current time,
    LoadsModule.checkOut(widget.selectedTrip, inOutIndex, inOutIndex, "pickup").then((value) {
      check_trip.clear();
      check_trip = LoadsModule.checkout_result;
      setState(() {
        checking = false;
        checkout_time = check_trip[inOutIndex].split("##")[1];
        widget.selectedTrip.checkOutList[inOutIndex] = check_trip[inOutIndex];
        // int index = selectedOrderIndex;
        // if (index + 1 < orders.length) index++;
        // selectedOrderIndex = index;
      });
    }).catchError((e) {
      checking = false;
      print(e.toString());
      check_trip.clear();
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
            future: Distance.distanceTo(widget.selectedTrip.shippers[inOutIndex].ship_pickup_latitude, widget.selectedTrip.shippers[inOutIndex].ship_pickup_longitude),
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
                                child: Text(getdifferentTime() < double.parse((snapshot.data.time / 3600).toStringAsFixed(2))*60 ? "Late for Pickup " :
                                        getdifferentTime() >= double.parse((snapshot.data.time / 3600).toStringAsFixed(2))*60 && getdifferentTime() - double.parse((snapshot.data.time / 3600).toStringAsFixed(2))*60 <= 30 ? "Running Late for Pickup " :
                                        "On Time for Pickup ")
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
        ],
      );
  int getdifferentTime(){
    DateTime now = DateTime.now();
    DateTime currentDate = DateTime.utc(now.year, now.month, now.day, now.hour, now.minute);
    int current_pickYear = int.parse(widget.selectedTrip.shippers[inOutIndex].shippingdate.split(',')[1]);
    int current_pickMonth = monthsInYear[widget.selectedTrip.shippers[inOutIndex].shippingdate.split(',')[0].split(' ')[0]];
    int current_pickDay = int.parse(widget.selectedTrip.shippers[inOutIndex].shippingdate.split(',')[0].split(' ')[1]);
    int current_pickHour = int.parse(widget.selectedTrip.shippers[inOutIndex].shippingtime.split(':')[0]);
    int current_pickMinute = int.parse(widget.selectedTrip.shippers[inOutIndex].shippingtime.split(':')[1]);
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
          Expanded(
            child: Container(
              height: 60,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: widget.selectedTrip.shippers.length,
                
                itemBuilder: (context, index1) {
                  // Order order = selectedTrip.orders[index];

                  //selectedLocationName=selectedTrip.shippers[0].shipperaddress;
                  return GestureDetector(
                    onTap: () {
                      print("INDEX" + index1.toString());
                      topIconClick(
                          widget.selectedTrip.shippers[index1].shipperaddress,
                          widget.selectedTrip.shippers[index1].shippername,
                          index1);
                    },
                    child: CircleOfTime2(
                      selected: selectedIndex == index1,
                      date: widget.selectedTrip.shippers[index1].shippingdate,
                      time: widget.selectedTrip.shippers[index1].shippingtime,
                      color: Constants.blue,
                    ),
                  );
                },
                
                separatorBuilder: (context, index1) => SizedBox(
                  width: 20,
                ),
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
//      Expanded(
//        child: Container(
//          height: 100,
//          child: ListView.separated(
//            padding: EdgeInsets.symmetric(horizontal: 20),
//            itemCount:widget. selectedTrip.consignees.length,
//            itemBuilder: (context, index) {
//              // Order order = selectedTrip.orders[index];
//              //selectedLocationName=selectedTrip.consignees[0].consigneeaddress;
//              return GestureDetector(
//                onTap: () {
//                  print("INDEX topclicl" + index.toString());
//                  topIconClick1(
//                      widget.selectedTrip.consignees[index].consigneeaddress,
//                      index);
//                },
//                child: CircleOfTime1(
//                  selected: selectedLocationName ==
//                      widget.selectedTrip.consignees[index].consigneeaddress,
//                  date: widget.selectedTrip.consignees[index].consigneedate,
//                  time: widget.selectedTrip.consignees[index].consigneetime,
//                  color: Constants.lightGreen,
//                ),
//              );
//            },
//            separatorBuilder: (context, index) => SizedBox(
//              width: 20,
//            ),
//            scrollDirection: Axis.horizontal,
//          ),
//        ),
//      ),
        ],
      );

  topIconClick(String order, String name, int index) {
    print("INDEX 0" + index.toString());
    
    setState(() {
      //selectedTrip = selectedTrip;
      //selectedOrderIndex = selectedTrip.orders.indexOf(order);
      isPickup = true;
      inOutIndex = index;
      selectedLocationName = order;
      selectedIndex = index;
      selectedName = name;
      
    });
  }

  // topIconClick1(String order, int index) {
  //   print("INDEX 1" + index.toString());
  //   //consignee  delivery
  //   setState(() {
  //     //selectedTrip = selectedTrip;

  //     //selectedOrderIndex = selectedTrip.orders.indexOf(order);
  //     isPickup = false;
  //     inOutIndex = index + widget.selectedTrip.shippers.length;
  //     selectedLocationName = order;
  //   });
  // }

  bottomNavTap(int p) {
    if (p == 4 || p == 3) {
      return;
    } else {
      StoreProvider.of<int>(context).dispatch(p);
      Navigator.pop(context);
    }
  }
}
