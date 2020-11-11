import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nfl_app/models/consignees.dart';
import 'package:nfl_app/models/location_module.dart';
import 'package:nfl_app/models/shippers.dart';
import 'package:nfl_app/models/user_model.dart';
import 'package:nfl_app/utils/order.dart';
import 'package:nfl_app/utils/trip.dart';
import 'package:dio/dio.dart';
import 'package:geocoder/geocoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadsModule {
  static List<Trip> trips;
  static List<Trip> trips1;
  static List<String> checkin_result = new List<String>();
  static List<String> checkout_result= new List<String>();

//5598274800
  //
  //an8il9wi5ngg00s1
  static Future init() async {
    var response = await http.get(
      "https://www.itruckdispatch.com/api/loadsfordriver?phone=${UserModel.user.phone}&apikey=${UserModel.key}",
      headers: UserModel.headers.cast(),
    );
    /* var response = await http.get(
      "https://www.itruckdispatch.com/api/loadsfordriver?phone=5598274800&apikey=an8il9wi5ngg00s1",
      headers: UserModel.headers.cast(),
    );*/
    // print("api_result:----------- ${response.body}");
    Map res = jsonDecode(response.body);

    List data = res["response"];
    print("api_result:----------- ${data.length}");
    trips = [];
    for (var e in data) {
      Distance d;
      try {
        d = await Distance.calculateTime(
          e["pickupaddress"],
          e["deliveryaddress"],
        );
      } catch (e) {
        // print(e.toString());
      }

      /**************************** */
//       var trip = Trip(
//           accepted: e["acceptstatus"] == 1,
//           currentLat: double.tryParse(e["currentlat"]),
//           currentLng: double.tryParse(e["currentlng"]),
//           miles: ((d?.distance ?? 0) * 0.000621371192).ceil(),
//           progress: 0,
//           pickupNumber: e[""],
//           //todo
//           commodity: e[''],
//           //todo
//           hours: e[""],
//           //todo
//           boxes: e[""],
//           //todo
//           pallet: e[""],
//           //todo
//           units: e[""],
//           //todo
//           weight: e[""],
//           //todo

//           deliveryTime: d?.timeDuration,
//           checkInList: [
//             e["in1"]??"null",
//             e["in2"]??"null",
//             e["in3"]??"null",
//             e["in4"]??"null",
//             e["in5"]??"null",
//           ],
// //          ..removeWhere(
// //              (element) => element == null || element == "Incomplete"),
//           checkOutList: [
//             e["out1"]??"null",
//             e["out2"]??"null",
//             e["out3"]??"null",
//             e["out4"]??"null",
//             e["out5"]??"null",
//           ],
// //          ..removeWhere(
// //              (element) => element == null || element == "Incomplete"),
//           appointmentTime: e["date"],
//           loadId: e["loadid"],
//           referenceNumber: e["refrencenumber"],
//           contactPerson: e["customername"],
//           contactNumber: e["customercontactnumber"],
//           extraStops: e["totalstops"],
//           temp: e["temprature"] == null ? null : int.tryParse(e["temprature"]),
//           notes: e["notes"],
//           orders: [
//             Order(
//               locationName: e["pickupaddress"],
//               date: DateTime.tryParse(e["pickupdate"]),
//               type: OrderType.Pickup,
//               done: e["checkin"] != null,
//             ),
//             Order(
//               locationName: e["deliveryaddress"],
//               date: DateTime.tryParse(e["deliverydate"]),
//               type: OrderType.delivery,
//               done: e["checkout"] != null,
//             ),
//           ],
//           consignees: getConsignees(e['consignees']),
//           shippers: getShippers(e['shippers']));
      

      var trip = Trip(
        accepted: e["acceptstatus"] == 1,
        //  currentLat: double.tryParse(e["currentlat"]) ?? 99.99,
        // currentLng: double.tryParse(e["currentlng"]) ?? 99.8,
        // miles: (d == null) ? ((d?.distance ?? 0) * 0.000621371192).ceil() : 0,
       
        
        currentLat: e["currentlat"] == null ? 99.99 : double.tryParse(e["currentlat"]),
        currentLng: e["currentlng"] == null ? 99.99 : double.tryParse(e["currentlng"]),
        progress: 0,
        pickupNumber: e[""],
        //todo
        commodity: e['commodity'],
        //todo
        hours: e[""],
        //todo
        boxes: e[""],
        //todo
        pallet: e[""],
        //todo
        units: e[""],
        //todo
        // weight: e[""],
        //todo
        
        deliveryTime: d?.timeDuration,
        accepttime: e["accepttime"],
        distance: d,
        checkInList: [
          e["in1"] == null || e["in1"] == "" ? "null" : e["in1"],
          e["in2"] == null || e["in2"] == "" ? "null" : e["in2"],
          e["in3"] == null || e["in3"] == "" ? "null" : e["in3"],
          e["in4"] == null || e["in4"] == "" ? "null" : e["in4"],
          e["in5"] == null || e["in5"] == "" ? "null" : e["in5"],
          e["in6"] == null || e["in6"] == "" ? "null" : e["in6"],
          e["in7"] == null || e["in7"] == "" ? "null" : e["in7"],
          e["in8"] == null || e["in8"] == "" ? "null" : e["in8"],
          e["in9"] == null || e["in9"] == "" ? "null" : e["in9"],
          e["in10"] == null || e["in10"] == "" ? "null" : e["in10"],
        ],
        // ..removeWhere((element) => element == null || element == "Incomplete"),
        checkOutList: [
          e["out1"] == null || e["out1"] == "" ? "null" : e["out1"],
          e["out2"] == null || e["out2"] == "" ? "null" : e["out2"],
          e["out3"] == null || e["out3"] == "" ? "null" : e["out3"],
          e["out4"] == null || e["out4"] == "" ? "null" : e["out4"],
          e["out5"] == null || e["out5"] == "" ? "null" : e["out5"],
          e["out6"] == null || e["out6"] == "" ? "null" : e["out6"],
          e["out7"] == null || e["out7"] == "" ? "null" : e["out7"],
          e["out8"] == null || e["out8"] == "" ? "null" : e["out8"],
          e["out9"] == null || e["out9"] == "" ? "null" : e["out9"],
          e["out10"] == null || e["out10"] == "" ? "null" : e["out10"],
        ],
        pickups: [
          e["pickup1"]??"null",
          e["pickup2"]??"null",
          e["pickup3"]??"null",
          e["pickup4"]??"null",
          e["pickup5"]??"null",
          
        ],
        deliverys: [
          e["delivery1"]??"null",
          e["delivery2"]??"null",
          e["delivery3"]??"null",
          e["delivery4"]??"null",
          e["delivery5"]??"null",
        ],

        //..removeWhere((element) => element == null || element == "Incomplete"),
        appointmentTime: e["date"],
        loadId: e["loadid"],
        referenceNumber: e["refrencenumber"],
        contactPerson: e["customername"],
        contactNumber: e["customercontactnumber"],
        extraStops: e["totalstops"],
        temp: e["temprature"] == null ? null : int.tryParse(e["temprature"]),
        weight: e["weight"] == null ? null : e["weight"],
        notes: e["notes"],
        orders: [
          Order(
            locationName: e["pickupaddress"],
            date: DateTime.tryParse(e["pickupdate"]),
            type: OrderType.Pickup,
            done: e["checkin"] != null,
          ),
          Order(
            locationName: e["deliveryaddress"],
            date: DateTime.tryParse(e["deliverydate"]),
            type: OrderType.delivery,
            done: e["checkout"] != null,
          ),
        ],
        
        consignees: getConsignees(e['consignees']),
        shippers: getShippers(e['shippers']),
      );
      trips.add(trip);
    }
  }

  static Future acceptLoadForDrivers() async {
    var response = await http.get(
      "https://www.itruckdispatch.com/api/acceptloadsfordriver?phone=${UserModel.user.phone}&apikey=${UserModel.key}",
      headers: UserModel.headers.cast(),
    );
    Map res = jsonDecode(response.body);
    List data1 = res["response"];
    trips1 = [];
    
    for (var i = 0; i < data1.length; i++) {
      var e = data1[i];
      print("Value of the object " + e.toString());
      Distance d;
      try {
        d = await Distance.calculateTime(
          e["pickupaddress"],
          e["deliveryaddress"],
        );
      } catch (e) {
        // print('print exception inside distance mehod' + e.toString());
      }


      var trip = Trip(
        accepted: e["acceptstatus"] == 1,
        currentLat: e["currentlat"] == null ? 99.99 : double.tryParse(e["currentlat"]),
        currentLng: e["currentlng"] == null ? 99.99 : double.tryParse(e["currentlng"]),
        progress: 0,
        pickupNumber: e[""],
        //todo
        commodity: e['commodity'],
        //todo
        hours: e[""],
        //todo
        boxes: e[""],
        //todo
        pallet: e[""],
        //todo
        units: e[""],
        //todo
        weight: e["weight"] == null ? null : e["weight"],
        //todo

        deliveryTime: d?.timeDuration,
        distance: d,
        checkInList: [
          e["in1"] == null || e["in1"] == "" ? "null" : e["in1"],
          e["in2"] == null || e["in2"] == "" ? "null" : e["in2"],
          e["in3"] == null || e["in3"] == "" ? "null" : e["in3"],
          e["in4"] == null || e["in4"] == "" ? "null" : e["in4"],
          e["in5"] == null || e["in5"] == "" ? "null" : e["in5"],
          e["in6"] == null || e["in6"] == "" ? "null" : e["in6"],
          e["in7"] == null || e["in7"] == "" ? "null" : e["in7"],
          e["in8"] == null || e["in8"] == "" ? "null" : e["in8"],
          e["in9"] == null || e["in9"] == "" ? "null" : e["in9"],
          e["in10"] == null || e["in10"] == "" ? "null" : e["in10"],
        ],
        // ..removeWhere((element) => element == null || element == "Incomplete"),
        checkOutList: [
          e["out1"] == null || e["out1"] == "" ? "null" : e["out1"],
          e["out2"] == null || e["out2"] == "" ? "null" : e["out2"],
          e["out3"] == null || e["out3"] == "" ? "null" : e["out3"],
          e["out4"] == null || e["out4"] == "" ? "null" : e["out4"],
          e["out5"] == null || e["out5"] == "" ? "null" : e["out5"],
          e["out6"] == null || e["out6"] == "" ? "null" : e["out6"],
          e["out7"] == null || e["out7"] == "" ? "null" : e["out7"],
          e["out8"] == null || e["out8"] == "" ? "null" : e["out8"],
          e["out9"] == null || e["out9"] == "" ? "null" : e["out9"],
          e["out10"] == null || e["out10"] == "" ? "null" : e["out10"],
        ],
        pickups: [
          e["pickup1"]??"null",
          e["pickup2"]??"null",
          e["pickup3"]??"null",
          e["pickup4"]??"null",
          e["pickup5"]??"null",
          
        ],
        deliverys: [
          e["delivery1"]??"null",
          e["delivery2"]??"null",
          e["delivery3"]??"null",
          e["delivery4"]??"null",
          e["delivery5"]??"null",
        ],

        //..removeWhere((element) => element == null || element == "Incomplete"),
        appointmentTime: e["date"],
        loadId: e["loadid"],
        referenceNumber: e["refrencenumber"],
        contactPerson: e["customername"],
        contactNumber: e["customercontactnumber"],
        extraStops: e["totalstops"],
        temp: e["temprature"] == null ? null : int.tryParse(e["temprature"]),
        notes: e["notes"],
        orders: [
          Order(
            locationName: e["pickupaddress"],
            date: DateTime.tryParse(e["pickupdate"]),
            type: OrderType.Pickup,
            done: e["checkin"] != null,
          ),
          Order(
            locationName: e["deliveryaddress"],
            date: DateTime.tryParse(e["deliverydate"]),
            type: OrderType.delivery,
            done: e["checkout"] != null,
          ),
        ],
        consignees: getConsignees(e['consignees']),
        shippers: getShippers(e['shippers']),
      );
      trips1.add(trip);
    }
  }
  static Future loadsBetween(String start_date, String end_date) async{
    var response = await http.post(
      "https://www.itruckdispatch.com/api/loadsbetween?phone=${UserModel.user.phone}&apikey=${UserModel.key}&from=${start_date}&to=${end_date}",
      headers: UserModel.headers.cast(),
    );
    /* var response = await http.get(
      "https://www.itruckdispatch.com/api/loadsfordriver?phone=5598274800&apikey=an8il9wi5ngg00s1",
      headers: UserModel.headers.cast(),
    );*/
    Map res = jsonDecode(response.body);

    List data = res["response"];
    trips = [];
    for (var e in data) {
      Distance d;
      try {
        d = await Distance.calculateTime(
          e["pickupaddress"],
          e["deliveryaddress"],
        );
      } catch (e) {
        // print(e.toString());
      }
      var trip = Trip(
        accepted: e["acceptstatus"] == 1,
        /* currentLat: double.tryParse(e["currentlat"]) ?? 99.99,
        currentLng: double.tryParse(e["currentlng"]) ?? 99.8,
        miles: (d == null) ? ((d?.distance ?? 0) * 0.000621371192).ceil() : 0,
       */
        progress: 0,
        pickupNumber: e[""],
        //todo
        commodity: e[''],
        //todo
        hours: e[""],
        //todo
        boxes: e[""],
        //todo
        pallet: e[""],
        //todo
        units: e[""],
        //todo
        weight: e[""],
        //todo

        deliveryTime: d?.timeDuration,
        checkInList: [
          e["in1"]??"null",
          e["in2"]??"null",
          e["in3"]??"null",
          e["in4"]??"null",
          e["in5"]??"null",
        ],
        // ..removeWhere((element) => element == null || element == "Incomplete"),
        checkOutList: [
          e["out1"]??"null",
          e["out2"]??"null",
          e["out3"]??"null",
          e["out4"]??"null",
          e["out5"]??"null",
        ],
        pickups: [
          e["pickup1"]??"null",
          e["pickup2"]??"null",
          e["pickup3"]??"null",
          e["pickup4"]??"null",
          e["pickup5"]??"null",
          
        ],
        deliverys: [
          e["delivery1"]??"null",
          e["delivery2"]??"null",
          e["delivery3"]??"null",
          e["delivery4"]??"null",
          e["delivery5"]??"null",
        ],

        //..removeWhere((element) => element == null || element == "Incomplete"),
        appointmentTime: e["date"],
        loadId: e["loadid"],
        referenceNumber: e["refrencenumber"],
        contactPerson: e["customername"],
        contactNumber: e["customercontactnumber"],
        extraStops: e["totalstops"],
        temp: e["temprature"] == null ? null : int.tryParse(e["temprature"]),
        notes: e["notes"],
        orders: [
          Order(
            locationName: e["pickupaddress"],
            date: DateTime.tryParse(e["pickupdate"]),
            type: OrderType.Pickup,
            done: e["checkin"] != null,
          ),
          Order(
            locationName: e["deliveryaddress"],
            date: DateTime.tryParse(e["deliverydate"]),
            type: OrderType.delivery,
            done: e["checkout"] != null,
          ),
        ],
        consignees: getConsignees(e['consignees']),
        shippers: getShippers(e['shippers']),
      );
      trips.add(trip);
    }
  }

  static Future onroadloads() async{
    var response = await http.post(
      "https://www.itruckdispatch.com/api/onroadloads?phone=${UserModel.user.phone}&apikey=${UserModel.key}",
      headers: UserModel.headers.cast(),
    );
    /* var response = await http.get(
      "https://www.itruckdispatch.com/api/loadsfordriver?phone=5598274800&apikey=an8il9wi5ngg00s1",
      headers: UserModel.headers.cast(),
    );*/
    Map res = jsonDecode(response.body);

    List data = res["response"];
    trips = [];
    for (var e in data) {
      Distance d;
      try {
        d = await Distance.calculateTime(
          e["pickupaddress"],
          e["deliveryaddress"],
        );
      } catch (e) {
        // print(e.toString());
      }
      var trip = Trip(
        accepted: e["acceptstatus"] == 1,
        /* currentLat: double.tryParse(e["currentlat"]) ?? 99.99,
        currentLng: double.tryParse(e["currentlng"]) ?? 99.8,
        miles: (d == null) ? ((d?.distance ?? 0) * 0.000621371192).ceil() : 0,
       */
        progress: 0,
        pickupNumber: e[""],
        //todo
        commodity: e[''],
        //todo
        hours: e[""],
        //todo
        boxes: e[""],
        //todo
        pallet: e[""],
        //todo
        units: e[""],
        //todo
        weight: e[""],
        //todo

        deliveryTime: d?.timeDuration,
        checkInList: [
          e["in1"]??"null",
          e["in2"]??"null",
          e["in3"]??"null",
          e["in4"]??"null",
          e["in5"]??"null",
        ],
        // ..removeWhere((element) => element == null || element == "Incomplete"),
        checkOutList: [
          e["out1"]??"null",
          e["out2"]??"null",
          e["out3"]??"null",
          e["out4"]??"null",
          e["out5"]??"null",
        ],
        pickups: [
          e["pickup1"]??"null",
          e["pickup2"]??"null",
          e["pickup3"]??"null",
          e["pickup4"]??"null",
          e["pickup5"]??"null",
          
        ],
        deliverys: [
          e["delivery1"]??"null",
          e["delivery2"]??"null",
          e["delivery3"]??"null",
          e["delivery4"]??"null",
          e["delivery5"]??"null",
        ],

        //..removeWhere((element) => element == null || element == "Incomplete"),
        appointmentTime: e["date"],
        loadId: e["loadid"],
        referenceNumber: e["refrencenumber"],
        contactPerson: e["customername"],
        contactNumber: e["customercontactnumber"],
        extraStops: e["totalstops"],
        temp: e["temprature"] == null ? null : int.tryParse(e["temprature"]),
        notes: e["notes"],
        orders: [
          Order(
            locationName: e["pickupaddress"],
            date: DateTime.tryParse(e["pickupdate"]),
            type: OrderType.Pickup,
            done: e["checkin"] != null,
          ),
          Order(
            locationName: e["deliveryaddress"],
            date: DateTime.tryParse(e["deliverydate"]),
            type: OrderType.delivery,
            done: e["checkout"] != null,
          ),
        ],
        consignees: getConsignees(e['consignees']),
        shippers: getShippers(e['shippers']),
      );
      trips.add(trip);
    }
  }
  static Future completedloads() async{
    var response = await http.post(
      "https://www.itruckdispatch.com/api/completedloads?phone=${UserModel.user.phone}&apikey=${UserModel.key}",
      headers: UserModel.headers.cast(),
    );
    /* var response = await http.get(
      "https://www.itruckdispatch.com/api/loadsfordriver?phone=5598274800&apikey=an8il9wi5ngg00s1",
      headers: UserModel.headers.cast(),
    );*/
    Map res = jsonDecode(response.body);

    List data = res["response"];
    trips = [];
    for (var e in data) {
      Distance d;
      try {
        d = await Distance.calculateTime(
          e["pickupaddress"],
          e["deliveryaddress"],
        );
      } catch (e) {
        // print(e.toString());
      }
      var trip = Trip(
        accepted: e["acceptstatus"] == 1,
        /* currentLat: double.tryParse(e["currentlat"]) ?? 99.99,
        currentLng: double.tryParse(e["currentlng"]) ?? 99.8,
        miles: (d == null) ? ((d?.distance ?? 0) * 0.000621371192).ceil() : 0,
       */
        progress: 0,
        pickupNumber: e[""],
        //todo
        commodity: e[''],
        //todo
        hours: e[""],
        //todo
        boxes: e[""],
        //todo
        pallet: e[""],
        //todo
        units: e[""],
        //todo
        weight: e[""],
        //todo

        deliveryTime: d?.timeDuration,
        checkInList: [
          e["in1"]??"null",
          e["in2"]??"null",
          e["in3"]??"null",
          e["in4"]??"null",
          e["in5"]??"null",
        ],
        // ..removeWhere((element) => element == null || element == "Incomplete"),
        checkOutList: [
          e["out1"]??"null",
          e["out2"]??"null",
          e["out3"]??"null",
          e["out4"]??"null",
          e["out5"]??"null",
        ],
        pickups: [
          e["pickup1"]??"null",
          e["pickup2"]??"null",
          e["pickup3"]??"null",
          e["pickup4"]??"null",
          e["pickup5"]??"null",
          
        ],
        deliverys: [
          e["delivery1"]??"null",
          e["delivery2"]??"null",
          e["delivery3"]??"null",
          e["delivery4"]??"null",
          e["delivery5"]??"null",
        ],

        //..removeWhere((element) => element == null || element == "Incomplete"),
        appointmentTime: e["date"],
        loadId: e["loadid"],
        referenceNumber: e["refrencenumber"],
        contactPerson: e["customername"],
        contactNumber: e["customercontactnumber"],
        extraStops: e["totalstops"],
        temp: e["temprature"] == null ? null : int.tryParse(e["temprature"]),
        notes: e["notes"],
        orders: [
          Order(
            locationName: e["pickupaddress"],
            date: DateTime.tryParse(e["pickupdate"]),
            type: OrderType.Pickup,
            done: e["checkin"] != null,
          ),
          Order(
            locationName: e["deliveryaddress"],
            date: DateTime.tryParse(e["deliverydate"]),
            type: OrderType.delivery,
            done: e["checkout"] != null,
          ),
        ],
        consignees: getConsignees(e['consignees']),
        shippers: getShippers(e['shippers']),
      );
      trips.add(trip);
    }
  }


  static Future searchLoadForDrivers(String content) async {

    //https://www.itruckdispatch.com/api/search?content=5&apikey=an8il9wi5ngg00s1&phone=5593361010
    var response = await http.get(
      "https://www.itruckdispatch.com/api/search?content=$content&phone=${UserModel.user.phone}&apikey=${UserModel.key}",
      headers: UserModel.headers.cast(),
    );


//    var response = await http.get(
//      "https://www.itruckdispatch.com/api/acceptloadsfordriver?phone=5598274800&apikey=an8il9wi5ngg00s1",
//      headers: UserModel.headers.cast(),
//    );
    print(response.body);

    Map res = jsonDecode(response.body);

    List data1 = res["response"];

    trips1 = [];

    for (var i = 0; i < data1.length; i++) {
      var e = data1[i];

      print("Value of the object " + e.toString());
      Distance d;
      try {
        d = await Distance.calculateTime(
          e["pickupaddress"],
          e["deliveryaddress"],
        );
      } catch (e) {
        print('print exception inside distance mehod' + e.toString());
      }


      var trip = Trip(
        accepted: e["acceptstatus"] == 1,
        /* currentLat: double.tryParse(e["currentlat"]) ?? 99.99,
        currentLng: double.tryParse(e["currentlng"]) ?? 99.8,
        miles: (d == null) ? ((d?.distance ?? 0) * 0.000621371192).ceil() : 0,
       */
        progress: 0,
        pickupNumber: e[""],
        //todo
        commodity: e[''],
        //todo
        hours: e[""],
        //todo
        boxes: e[""],
        //todo
        pallet: e[""],
        //todo
        units: e[""],
        //todo
        weight: e[""],
        //todo

        deliveryTime: d?.timeDuration,
        checkInList: [
          e["in1"]??"null",
          e["in2"]??"null",
          e["in3"]??"null",
          e["in4"]??"null",
          e["in5"]??"null",
        ],
        // ..removeWhere((element) => element == null || element == "Incomplete"),
        checkOutList: [
          e["out1"]??"null",
          e["out2"]??"null",
          e["out3"]??"null",
          e["out4"]??"null",
          e["out5"]??"null",
        ],
        pickups: [
          e["pickup1"]??"null",
          e["pickup2"]??"null",
          e["pickup3"]??"null",
          e["pickup4"]??"null",
          e["pickup5"]??"null",
          
        ],
        deliverys: [
          e["delivery1"]??"null",
          e["delivery2"]??"null",
          e["delivery3"]??"null",
          e["delivery4"]??"null",
          e["delivery5"]??"null",
        ],

        //..removeWhere((element) => element == null || element == "Incomplete"),
        appointmentTime: e["date"],
        loadId: e["loadid"],
        referenceNumber: e["refrencenumber"],
        contactPerson: e["customername"],
        contactNumber: e["customercontactnumber"],
        extraStops: e["totalstops"],
        temp: e["temprature"] == null ? null : int.tryParse(e["temprature"]),
        notes: e["notes"],
        orders: [
          Order(
            locationName: e["pickupaddress"],
            date: DateTime.tryParse(e["pickupdate"]),
            type: OrderType.Pickup,
            done: e["checkin"] != null,
          ),
          Order(
            locationName: e["deliveryaddress"],
            date: DateTime.tryParse(e["deliverydate"]),
            type: OrderType.delivery,
            done: e["checkout"] != null,
          ),
        ],
        consignees: getConsignees(e['consignees']),
        shippers: getShippers(e['shippers']),
      );

      trips1.add(trip);

      //return;

    }
  }
  static Future checkIn(Trip trip, int inNumber, String type) async {
    // var position = await GeolocatorPlatform.instance.getCurrentPosition();
    /* String location = trip.orders
        .where((element) => element.type == OrderType.Pickup)
        .toList()[inNumber - 1]
        .locationName;*/
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var time = DateTime.now().hour.toString() + ":" + DateTime.now().minute.toString();
    // var coordinates = new Coordinates(trip.currentLat, trip.currentLng);
    var coordinates = new Coordinates(position.latitude, position.longitude);
    var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var url =
        "https://www.itruckdispatch.com/api/checkin?loadid=${trip.loadId}&currentlat=${trip.currentLat}"
        "&currentlng=${trip.currentLng}&innumber=${inNumber+1}"
        "&location=${address.first.addressLine}&intime=${time}"
        "&apikey=${UserModel.key}&type=${type}"; //todo
    print("checkdata:------------------${url}");

    var response = await http.get(
      url,
      headers: UserModel.headers.cast(),
    );
    
    Map res = jsonDecode(response.body);
    checkin_result.clear();
    checkin_result.add(res["response"]["in1"]);
    checkin_result.add(res["response"]["in2"]);
    checkin_result.add(res["response"]["in3"]);
    checkin_result.add(res["response"]["in4"]);
    checkin_result.add(res["response"]["in5"]);
    checkin_result.add(res["response"]["in6"]);
    checkin_result.add(res["response"]["in7"]);
    checkin_result.add(res["response"]["in8"]);
    checkin_result.add(res["response"]["in9"]);
    checkin_result.add(res["response"]["in10"]);
  }

  static Future checkOut(Trip trip, int outNumber, int outNumber1, String type) async {
    // print("CHECKOUT");
    // var position = await GeolocatorPlatform.instance.getCurrentPosition();
    
    // String location = trip.orders
    //     .where((element) => element.type == OrderType.delivery)
    //     .toList()[outNumber - 1]
    //     .locationName;

    // print(location);

    // var time = DateTime.now().millisecondsSinceEpoch;

    // var request =
    //     "https://www.itruckdispatch.com/api/checkout?loadid=${trip.loadId}"
    //     "&outnumber=$outNumber&location=$location&outtime=$time"
    //     "&currentlat=${position.latitude}&currentlng=${position.longitude}"
    //     "&apikey=${UserModel.key}";

    // print(request);

    // var response = await http.get(
    //   "https://www.itruckdispatch.com/api/checkout?loadid=${trip.loadId}"
    //   "&outnumber=$outNumber"
    //   "&location=$location"
    //   "&outtime=$time"
    //   "&apikey=${UserModel.key}",
    //   headers: {
    //     'Accept': 'application/json',
    //   },
    // );

    // print(response.body);

    
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var time = DateTime.now().hour.toString() + ":" + DateTime.now().minute.toString();
    // var coordinates = new Coordinates(trip.currentLat, trip.currentLng);
    var coordinates = new Coordinates(position.latitude, position.longitude);
    var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // var first = address[address.length - 2];
    var url =
        "https://www.itruckdispatch.com/api/checkout?loadid=${trip.loadId}&outnumber=${outNumber1+1}"
        "&location=${address.first.addressLine}&outtime=${time}"
        "&type=${type}&deliverydone=${type}${outNumber+1}&currentlat=${trip.currentLat}&currentlng=${trip.currentLng}"
        "&apikey=${UserModel.key}"; //todo

    var response = await http.get(
      url,
      headers: UserModel.headers.cast(),
    );
    Map res = jsonDecode(response.body);
    checkout_result.clear();
    checkout_result.add(res["response"]["out1"]);
    checkout_result.add(res["response"]["out2"]);
    checkout_result.add(res["response"]["out3"]);
    checkout_result.add(res["response"]["out4"]);
    checkout_result.add(res["response"]["out5"]);
    checkout_result.add(res["response"]["out6"]);
    checkout_result.add(res["response"]["out7"]);
    checkout_result.add(res["response"]["out8"]);
    checkout_result.add(res["response"]["out9"]);
    checkout_result.add(res["response"]["out10"]);
    await init();
  }

  static Trip tripOfOrder(Order order) {
    return trips.firstWhere((element) => element.orders.contains(order));
  }

  static Future acceptAll(Trip trip) async {
    // var location = await GeolocatorPlatform.instance.getCurrentPosition();
    Position location = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //for (Trip t in trips) {
    // if (!t.accepted) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm##dd MMM yyyy').format(now);
    DateTime queryDate2 = DateTime.utc(now.year, now.month, now.day, now.hour, now.minute);
    print("current_datetime:----------${queryDate2.toString()}");
    
    var url = "https://www.itruckdispatch.com/api/acceptload?"
        "loadid=${trip.loadId}"
        "&acceptstatus=1"
        // "accepttime=${queryDate2.toString()}"
        "&currentlat=${location.latitude}"
        "&currentlng=${location.longitude}"
        //"&apikey=an8il9wi5ngg00s1";
        "&apikey=${UserModel.key}";
    await http.get(url, headers: UserModel.headers.cast());

    await init();
  }

  static Future<dynamic> upload(dynamic loadid) async {
    File _image;
    var image = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return null;
    _image = File(image.path);
    
    // var task = await FirebaseStorage.instance
    //     .ref()
    //     .child("images/${image.path.split("/").last}")
    //     .putFile(_image)
    //     .onComplete;

    // var url = await task.ref.getDownloadURL();
    // print("file url:------------ ${_image.path}");
    
    var post = "https://www.itruckdispatch.com/api/eDocUpload";
        // "loadid=7257"
        // "&apikey=${UserModel.key}";
        
    var request = http.MultipartRequest('POST', Uri.parse(post));
    request.fields['loadid'] = "${loadid}";
    request.fields['apikey'] = "an8il9wi5ngg00s1";
    request.headers["Accept"] = "*/*";
    request.headers["Content-Type"] = "multipart/form-data;boundary=----WebKitFormBoundaryyrV7KO0BoCBuDbTL";
    
    request.files.add(
      http.MultipartFile(
        'file',
        _image.readAsBytes().asStream(),
        _image.lengthSync(),
        filename: image.path.split("/").last
        )
    );
    var response = await request.send();
    print("response:-----------${response.statusCode}");
    // return http.Response.fromStream(response);
  }

  static Future sendCurrentLocation(Trip trip) async {
    
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var coordinates = new Coordinates(position.latitude, position.longitude);
    var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy MMM dd').format(now);
    String formattedTime = DateFormat('kk:mm').format(now);
    double latitude; double longitude; String location;
    latitude = position.latitude;
    longitude = position.longitude;
    location = address.first.addressLine;
    String info = "trackstarted";
    if(position == null){
      SharedPreferences sh = await SharedPreferences.getInstance();
      latitude = sh.getDouble("currentLat");
      longitude = sh.getDouble("currentLong");
      location = sh.getString("location");
      info = "trackinterupted";
    }
    var url =
        "https://www.itruckdispatch.com/api/currentlocation?loadid=${trip.loadId}"
        "&currentlat=${position.latitude}&currentlng=${position.longitude}"
        "&apikey=${UserModel.key}"
        "&date=${formattedDate}"
        "&time=${formattedTime}"
        "&info=${info}"
        "&location=${location}";

    var response = await http.get(
      url,
      headers: UserModel.headers.cast()
    );
    if(response.statusCode == 200){
      print("SEND CURRENT LOCATION TO SERVER");
    }    
    // await init();
  }
  static Future saveCurrentLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(position != null){
      var coordinates = new Coordinates(position.latitude, position.longitude);
      var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      SharedPreferences sh = await SharedPreferences.getInstance();
      sh.setDouble("currentLat", position.latitude);
      sh.setDouble("currentLong", position.longitude);
      sh.setString("location", address.first.addressLine);
      print("location:------${address.first.addressLine}");
    }
  }

  static List<Consignees> getConsignees(String e) {
    List<Consignees> consigneesList = List<Consignees>();

    List<String> splitConsignees = e.split("@@");

    var i;
    for (i in splitConsignees) {
      List<String> consigneesProperties = i.split("##");

      var object = Consignees(
        consigneename: consigneesProperties[0],
        consigneeaddress: consigneesProperties[1],
        consigneedate: consigneesProperties[2],
        consigneetime: consigneesProperties[3],
        consigneequantity: consigneesProperties[4],
        consigneeweight: consigneesProperties[5],
        consigneepurchaseorder: consigneesProperties[6],
        cmjrintersection: consigneesProperties[7],
        cappointment: consigneesProperties[8],
        cdescription: consigneesProperties[9],
        consigneeunits: consigneesProperties[10],
        consigneepallets: consigneesProperties[11],
        consigneeboxes: consigneesProperties[12],
        consigneedeliveryref: consigneesProperties[13],
        consigneedeliverynumber: consigneesProperties[14],
        conapptime: consigneesProperties[15],
        conaddresslat: consigneesProperties[16],
        conaddresslng: consigneesProperties[17],
        concpn: consigneesProperties[18],
        concpp: consigneesProperties[19],
        concity: consigneesProperties[20],
        constate: consigneesProperties[21],
        concountry: consigneesProperties[22],
        con_hours: consigneesProperties[23] + " : " + consigneesProperties[24]
      );

      consigneesList.add(object);
    }

    //print("CONSIGNEE LISt" + consigneesList.length.toString());
    return consigneesList;
  }

  static List<Shippers> getShippers(String e) {
    List<Shippers> shippersList = List<Shippers>();

    List<String> splitShippers = e.split("@@");

    var i;
    for (i in splitShippers) {
      List<String> shippersProperties = i.split("##");

      var object = Shippers(
        shippername: shippersProperties[0],
        shipperaddress: shippersProperties[1],
        shippingdate: shippersProperties[2],
        shippingtime: shippersProperties[3],
        shippingquantity: shippersProperties[4],
        shippingweight: shippersProperties[5],
        purchaseorder: shippersProperties[6],
        shipunits: shippersProperties[10],
        shippallets: shippersProperties[11],
        shipboxes: shippersProperties[12],
        shippickref: shippersProperties[13],
        shippicknumber: shippersProperties[14],
        shipappointment: shippersProperties[15],
        shipcontactpersonname: shippersProperties[18],
        shipcontactpersonphone: shippersProperties[19],
        ship_pickup_latitude: shippersProperties[16],
        ship_pickup_longitude: shippersProperties[17],
        ship_pickup_city: shippersProperties[20],
        ship_pickup_state: shippersProperties[21],
        ship_pickup_country: shippersProperties[22],
        ship_hours: shippersProperties[23] + " - " + shippersProperties[24]
      );

      shippersList.add(object);
    }
   // print("SHIPPERSLIST LISt" + shippersList.length.toString());

    return shippersList;
  }
}

class MediaType {
}
