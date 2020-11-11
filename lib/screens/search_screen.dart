import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:nfl_app/models/loads_module.dart';
import 'package:nfl_app/models/user_model.dart';
import 'package:nfl_app/utils/constants.dart';
import 'package:nfl_app/utils/order.dart';
import 'package:nfl_app/utils/trip.dart';
import 'package:nfl_app/widget/animated_border_widget.dart';
import 'package:nfl_app/widget/data_widget.dart';
import 'package:nfl_app/widget/order_widget.dart';
import 'package:nfl_app/widget/progress_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_id/device_id.dart';

class SearchScreen extends StatefulWidget {
  @override
  _DeliverRequestScreenState createState() => _DeliverRequestScreenState();
}

class _DeliverRequestScreenState extends State<SearchScreen> {
  bool loading = false;

  List<Trip> trips;
  List<Trip> trips1;
  int _index = 0;
  TextEditingController searchController = new TextEditingController();
  final FocusNode searchNode = FocusNode();
  String searchString = "";
  String deviceId = "";

  Trip get selectedTrip => trips[_index];

  //todo sort orders
  List<Order> get allOrders =>
      [for (var trip in trips) ...trip.orders]..sort((x, y) {
          return x.date.compareTo(y.date);
        });

  bool get accepted => !LoadsModule.trips1.any((element) => !element.accepted);

  get progress => 0.0;

  @override
  void initState() {
    
    super.initState();
    init("");
  }
  Future<String> getDeviceID()  async {
    
    return await DeviceId.getID;
  }

  void init(String content) {
    if (!loading) {
      setState(() {
        loading = false;
      });
    }

    // LoadsModule.searchLoadForDrivers(content)
    //     .then((value) => setState(() {
    //           print("trips loading get value -----------");
    //           trips = LoadsModule.trips1;
    //           loading = false;
    //         }))
    //     .catchError((err) {
    //   print(err.toString());
    //   print("trips loading get error $err ----------");
    //   trips = [];
    // });
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
        child: Scaffold(
          body: Center(
            // child: SpinKitCubeGrid(
            //   color: Theme.of(context).primaryColor,
            // ),
            child: Image.asset("assets/images/itruck-loader.gif",width: 60, height: 60),
          ),
        ),
      );
    } 
    if(trips == null){
      return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(30.0),
                    elevation: 8,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        cursorColor: Colors.orange[200],
                        focusNode: searchNode,
                        controller: searchController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          
                          suffixIcon: 
                            GestureDetector(
                              onTap:() {
                                search();
                                
                              },
                              child:Icon(Icons.search, color: Colors.orange[200], size: 30),
                            ),
                          hintText: "Enter Shipper Name/ Shipper Addresss",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none),
                        ),
                        onChanged: (String value){
                          searchString = value;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.refresh),
                            ),
                            Text("there are no trips"),
                          ]
                        )
                      ),
                    )
                  ),
                  
                ],
              );
    }
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/map.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: (trips.isNotEmpty)
          ? 
          Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Material(
                    borderRadius: BorderRadius.circular(30.0),
                    elevation: 8,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        cursorColor: Colors.orange[200],
                        keyboardType: TextInputType.text,
                        controller: searchController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          suffixIcon: 
                            GestureDetector(
                              onTap:() {
                                search();
                              },
                              child:Icon(Icons.search, color: Colors.orange[200], size: 30),
                            ),
                          hintText: "Enter Shipper Name/ Shipper Addresss",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none),
                        ),
                        onChanged: (String value){
                          searchString = value;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                    // physics: BouncingScrollPhysics(),
                    // children: [
                      // dateWidget,
                      
                      //  ProgressWidget(trip: selectedTrip),
                      child: Container(
                        child: Column(
                          children:<Widget>[
                            if (trips.length > 0)
                              for (var trip in trips)
                                EachRequest(
                                  trips: trip,
                                ),
                          ]
                        )
                      ),
                      
                      // ],
                    )
                  ),
                  
                  
                ]
              )
          )
          
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  borderRadius: BorderRadius.circular(30.0),
                  elevation: 8,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      cursorColor: Colors.orange[200],
                      focusNode: searchNode,
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        suffixIcon: 
                          GestureDetector(
                            onTap:() {
                              search();
                              
                            },
                            child:Icon(Icons.search, color: Colors.orange[200], size: 30),
                          ),
                        hintText: "Enter Shipper Name/ Shipper Addresss",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                      ),
                      onChanged: (String value){
                          searchString = value;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.refresh),
                          ),
                          Text("there are no trips"),
                        ]
                      )
                    ),
                  )
                ),
                
              ],
            )
    );
  }
  search(){
    if(searchString.isNotEmpty){
      
      setState(() {
        loading = true;
        searchController.text = searchString;
      });

      LoadsModule.searchLoadForDrivers(searchString)
          .then((value) => setState(() {
                print("trips loading get value -----------");
                trips = LoadsModule.trips1;
                loading = false;
              }))
          .catchError((err) {
        print(err.toString());
        print("trips loading get error $err ----------");
        trips = [];
      });
    // print("search text------------: ${searchController.text}");
    }
  }
  /* Container get dateWidget => Container(
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
  );*/
  TextEditingController myController = TextEditingController();

  Container get dateWidget => Container(
        child: Column(
          children: [
            TextField(
              controller: myController,
            ),
            GestureDetector(
                onTap: () {
                  init(myController.text);
                },
                child: Text("Search"))
          ],
        ),
      );
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
            key: "Temp",
            value: "${trips.temp ?? "DRY"} deg",
//            icon: Image.asset(
//              "assets/images/temperature.png",
//              width: 30,
//              height: 30,
//            ),
          ),
          DataItem(
            key: "Weight",
            value: "${trips.shippers[0].shippingweight ?? "xx"} lbs",
//            icon: Image.asset(
//              "assets/images/scale.png",
//              width: 40,
//              height: 40,
//            ),
          ),
          DataItem(
            key: "Extra Stops",
            value: "${trips.extraStops - 2 < 0 ? 0 : trips.extraStops - 2?? "xx"}",
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
                      await LoadsModule.acceptAll(widget.selectedTrip);
                      setState(() {
                        loading = false;
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
                                ? "${widget.selectedTrip.deliveryTime.toString().split(":").first}"
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
