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
import 'package:nfl_app/screens/trips/pickup_details.dart';
import 'package:nfl_app/utils/constants.dart';
import 'package:nfl_app/utils/order.dart';
import 'package:nfl_app/utils/trip.dart';
import 'package:nfl_app/widget/animated_border_widget.dart';
import 'package:nfl_app/widget/bottom_navigation.dart';
import 'package:nfl_app/widget/check_button.dart';
import 'package:nfl_app/widget/circle_of_time.dart';
import 'package:nfl_app/widget/data_widget.dart';
import 'package:nfl_app/widget/my_appbar_widget.dart';
import 'package:nfl_app/widget/my_drawer_widget.dart';
import 'package:nfl_app/widget/progress_widget.dart';
import 'package:toast/toast.dart';

import 'delivery_details.dart';

class TripDetailsScreen extends StatefulWidget {
  @override
  _TripDetailsScreenState createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  List<Order> get orders =>
      [for (var trip in LoadsModule.trips) ...trip.orders];

  bool uploading = false;
  bool checking = false;
  bool isPickup = true;
  Trip selectedTrip;

  int inOutIndex = 0;

  int selectedOrderIndex = 1;

  String selectedLocationName = '-';

  // Order selectedOrder ;
  Order get selectedOrder => orders[selectedOrderIndex];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //selectedTrip.checkOutList.insert(0,"");
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    if (arguments != null)
      print("PRINT" + arguments['exampleArgument'].toString());
    selectedTrip = arguments['exampleArgument'];

    print("Print selected trip " + selectedTrip.shippers.toString());

//    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
//
//    if (arguments != null) print(arguments['exampleArgument']);
//    selectedTrip = arguments['exampleArgument'];
//
//    print("Slected Trip" + selectedTrip.checkOutList.toString());
//    print("SelectedTrip" + selectedTrip.orders[0].toString());
//    //selectedOrder=selectedTrip.orders[0]; //todo

    return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          //Changing this will change the color of the TabBar
          accentColor: Constants.red,
        ),
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  title: Text('Trips details'),
                  centerTitle: true,
                  bottom: TabBar(
                    tabs: [
                      Tab(text: "PICKUP DETAILS"),
                      Tab(text: "DELIVERY DETAILS")
                    ],
                  ),
                  leading: new IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                  ),
                ),
                endDrawer: MyDrawerWidget(
                  page: pages.loads,
                  onPage: bottomNavTap,
                ),
                body: TabBarView(
                  children: [
                    PickUpDetails(
                      selectedTrip: selectedTrip,
                    ),
                    DeliveryDetails(selectedTrip: selectedTrip),
                  ],
                ))));
  }

  // get time => Container(
  //       padding: EdgeInsets.all(5),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(15),
  //         border: Border.all(
  //           color: Constants.lightBlue,
  //           width: 2,
  //         ),
  //       ),
  //       child: Row(
  //         children: [
  //           Expanded(
  //             child: Row(
  //               children: [
  //                 Image.asset("assets/images/clock.png", width: 40),
  //                 VerticalDivider(),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Text("Check in"),
  //                     Text(
  //                       "${selectedTrip.checkInTime}",
  //                       style: Constants.timeText,
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Container(
  //             width: 1.5,
  //             height: 40,
  //             color: Constants.lightBlue,
  //             margin: EdgeInsets.symmetric(horizontal: 10),
  //           ),
  //           Expanded(
  //             child: Row(
  //               children: [
  //                 Image.asset("assets/images/clock.png", width: 40),
  //                 VerticalDivider(),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Text("Check out"),
  //                     Text("${selectedTrip.checkOutTime}",
  //                         style: Constants.timeText),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     );

  // Row get checkButton => Row(
  //       children: [
  //         Expanded(
  //           child: checking
  //               ? Center(
  //                   child: SpinKitCubeGrid(
  //                     color: Constants.darkGreen,
  //                   ),
  //                 )
  //               : CheckButton(
  //                   enable: selectedLocationName != null &&
  //                       selectedLocationName != '-',
  //                   // checkedIn: true,
  //                   checkedIn: (selectedLocationName == null ||
  //                           selectedLocationName == '-')
  //                       ? false
  //                       : (selectedTrip?.checkInList
  //                                   ?.elementAt(inOutIndex ?? 0) ??
  //                               "Incomplete") !=
  //                           "Incomplete",

  //                   checkInFunction: checkIn,
  //                   checkOutFunction: checkOut,
  //                 ),
  //         ),
  //         SizedBox(width: 5),
  //         uploading
  //             ? Center(
  //                 child: SpinKitCubeGrid(
  //                   color: Constants.darkGreen,
  //                 ),
  //               )
  //             : Theme(
  //                 data: ThemeData(
  //                   buttonTheme: ButtonThemeData(
  //                     buttonColor: Constants.lightGreen,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                     height: 60,
  //                   ),
  //                 ),
  //                 child: RaisedButton.icon(
  //                   onPressed: upload,
  //                   icon: Image.asset(
  //                     "assets/images/file-upload.png",
  //                     width: 30,
  //                     color: Colors.white,
  //                   ),
  //                   label: Text(
  //                     "UPLOAD\nE-DOCS",
  //                     style: TextStyle(
  //                       fontSize: 18,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //       ],
  //     );

  // upload() async {
  //   setState(() {
  //     uploading = true;
  //   });

  //   LoadsModule.upload(selectedTrip.loadId).then(
  //     (value) => setState(() {
  //       uploading = false;
  //     }),
  //   );
  // }

  // checkIn() {
  //   //  print("CHECKIN FUNCTION"+selectedTrip.checkInList[inOutIndex].toString());
  //   setState(() {
  //     checking = true;
  //   });
  //   LoadsModule.checkIn(
  //           selectedTrip,
  //           inOutIndex + 1,
  //           (isPickup)
  //               ? selectedTrip.consignees[inOutIndex - 1].consigneeaddress
  //               : selectedTrip.shippers[inOutIndex - 1].shipperaddress)
  //       .then((value) {
  //     setState(() {
  //       checking = false;
  //       //int index = selectedOrderIndex;
  //       //if (index + 1 < orders.length) index++;
  //       //selectedOrderIndex = index;
  //     });
  //   });
  // }

  // checkOut() {
  //   setState(() {
  //     checking = true;
  //   });
    // LoadsModule.checkOut(selectedTrip, inOutIndex + 1).then((value) {
    //   setState(() {
    //     checking = false;
    //     int index = selectedOrderIndex;
    //     if (index + 1 < orders.length) index++;
    //     selectedOrderIndex = index;
    //   });
    // }).catchError((e) {
    //   checking = false;
    //   Toast.show(
    //     e.toString().split(":").last,
    //     context,
    //   );
    // });
  // }

//   Row get title => Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               //selectedOrder.locationName,
//               selectedLocationName,
//               style: Constants.darkText,
//             ),
//           ),
//           Expanded(
//             child: AnimatedBorderWidget(
//               color: Constants.green,
// //                color: DateTime.now().isAfter(DateTime.tryParse(selectedTrip.shippers[inOutIndex].shippingtime))
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
//         ],
//       );

  // Widget get directions => Center(
  //       child: FlatButton.icon(
  //         onPressed: () {},
  //         icon: Icon(Icons.directions),
  //         label: Text("get Directions"),
  //         textColor: Constants.red,
  //         padding: EdgeInsets.all(0),
  //       ),
  //     );

  // get topIcon => Row(
  //       children: [
  //         Expanded(
  //           child: Container(
  //             height: 100,
  //             child: ListView.separated(
  //               padding: EdgeInsets.symmetric(horizontal: 20),
  //               itemCount: selectedTrip.shippers.length,
  //               itemBuilder: (context, index1) {
  //                 // Order order = selectedTrip.orders[index];

  //                 //selectedLocationName=selectedTrip.shippers[0].shipperaddress;
  //                 return GestureDetector(
  //                   onTap: () {

  //                     topIconClick(
  //                         selectedTrip.shippers[index1].shipperaddress, index1);
  //                   },
  //                   child: CircleOfTime1(
  //                     selected: selectedLocationName ==
  //                         selectedTrip.shippers[index1].shipperaddress,
  //                     date: selectedTrip.shippers[index1].shippingdate,
  //                     time: selectedTrip.shippers[index1].shippingtime,
  //                     color: Constants.lightBlue,
  //                   ),
  //                 );
  //               },
  //               separatorBuilder: (context, index) => SizedBox(
  //                 width: 20,
  //               ),
  //               scrollDirection: Axis.horizontal,
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           child: Container(
  //             height: 100,
  //             child: ListView.separated(
  //               padding: EdgeInsets.symmetric(horizontal: 20),
  //               itemCount: selectedTrip.consignees.length,
  //               itemBuilder: (context, index) {
  //                 // Order order = selectedTrip.orders[index];
  //                 //selectedLocationName=selectedTrip.consignees[0].consigneeaddress;
  //                 return GestureDetector(
  //                   onTap: () {

  //                     topIconClick1(
  //                         selectedTrip.consignees[index].consigneeaddress,
  //                         index);
  //                   },
  //                   child: CircleOfTime1(
  //                     selected: selectedLocationName ==
  //                         selectedTrip.consignees[index].consigneeaddress,
  //                     date: selectedTrip.consignees[index].consigneedate,
  //                     time: selectedTrip.consignees[index].consigneetime,
  //                     color: Constants.lightGreen,
  //                   ),
  //                 );
  //               },
  //               separatorBuilder: (context, index) => SizedBox(
  //                 width: 20,
  //               ),
  //               scrollDirection: Axis.horizontal,
  //             ),
  //           ),
  //         ),
  //       ],
  //     );

  // topIconClick(String order, int index) {

  //   setState(() {
  //     //selectedTrip = selectedTrip;

  //     //selectedOrderIndex = selectedTrip.orders.indexOf(order);
  //     isPickup = true;
  //     inOutIndex = index;
  //     selectedLocationName = order;
  //   });
  // }

  // topIconClick1(String order, int index) {

  //   //consignee  delivery
  //   setState(() {
  //     //selectedTrip = selectedTrip;

  //     //selectedOrderIndex = selectedTrip.orders.indexOf(order);
  //     isPickup = false;
  //     inOutIndex = index + selectedTrip.shippers.length;
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
