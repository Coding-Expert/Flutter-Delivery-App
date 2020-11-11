import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nfl_app/models/consignees.dart';
import 'package:nfl_app/models/location_module.dart';
import 'package:nfl_app/models/shippers.dart';
import 'package:nfl_app/utils/order.dart';

class Trip {
  final double progress;
  final List<Order> orders;
  final List<Consignees> consignees;
  final List<Shippers> shippers;

  final int temp;
  final String weight;
  final int extraStops;

  final int pickupNumber, referenceNumber;
  final int pallet, boxes, units;

  final String appointmentTime;
  final String contactPerson;
  final String hours, contactNumber;
  final String commodity, notes;

  final int miles;

  final List<String> checkInList;
  final List<String> checkOutList;
  final List<String> pickups;
  final List<String> deliverys;

  final Duration deliveryTime;
  final String accepttime;

  bool accepted;

  final double currentLat;
  final double currentLng;
  final Distance distance;

  String checkInTime(int index) {
    try {
      var num = checkInList[index].split("##").first;
      int number = int.tryParse(num);
      var date = DateTime.fromMillisecondsSinceEpoch(number);
      return DateFormat("hh:mm a").format(date);
    } catch (e) {
      return "00:00";
    }
  }

  String checkOutTime(int index) {
    try {
      // var num = checkOutList
      //     .lastWhere((element) => element != null)
      //     .split("##")
      //     .first;
      var num = checkOutList[index].split("##").first;
      int number = int.tryParse(num);
      var date = DateTime.fromMillisecondsSinceEpoch(number);
      return DateFormat("hh:mm a").format(date);
    } catch (e) {
      return "00:00";
    }
  }

  final loadId;

  get loadNumber => loadId;

  DateTime get endDate => orders.last.date;

  DateTime get startDate => orders.last.date;

  Trip({
    @ required this.consignees,
    @ required this.shippers,
    @required this.accepted,
    @required this.currentLat,
    @required this.currentLng,
    @required this.loadId,
    @required this.progress,
    @required this.miles,
    @required this.orders,
    @required this.temp,
    @required this.weight,
    @required this.extraStops,
    @required this.notes,
    @required this.pickupNumber,
    @required this.referenceNumber,
    @required this.checkInList,
    @required this.checkOutList,
    @required this.pallet,
    @required this.boxes,
    @required this.units,
    @required this.appointmentTime,
    @required this.contactPerson,
    @required this.hours,
    @required this.contactNumber,
    @required this.commodity,
    @required this.deliveryTime,
    @required this.distance,
    @required this.pickups,
    @required this.deliverys,
    @required this.accepttime
  });

  bool isChecked(Order order) {
    try {
      if (order.type == OrderType.Pickup) {
        var check = checkInList
            .firstWhere((element) => element.contains(order.locationName));

        return check != null;
      } else {

        var check = checkOutList
            .firstWhere((element) => element.contains(order.locationName));
        return check != null;
      }
    } catch (e) {
      return false;
    }
  }


  /*bool isCheckedValue(String order) {
    try {
      if (order.type == OrderType.Pickup) {
        var check = checkInList
            .firstWhere((element) => element.contains(order.locationName));

        return check != null;
      } else {

        var check = checkOutList
            .firstWhere((element) => element.contains(order.locationName));
        return check != null;
      }
    } catch (e) {
      return false;
    }
  }*/
}
