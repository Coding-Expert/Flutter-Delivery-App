import 'dart:convert';

import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/base.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Distance {
  static const key = "AIzaSyBYj4SoDS8RsfnMKa_PtmhypjmFjjLuoPM";

  final double time;
  final double distance;

  Duration get timeDuration => Duration(seconds: time.ceil());

  const Distance({this.time, this.distance});

  static String removeSpaces(String parse) {
    parse = parse.replaceAllMapped(RegExp(r"[,.]"), (match) => " ");
    parse = parse.replaceAllMapped(RegExp(r"  *"), (match) => "+");
//    parse = parse.replaceAllMapped(RegExp(r"[\d,.]*$"), (match) => "+");
//    parse = parse.replaceAllMapped(RegExp(r"\+*"), (match) => "+");
    return parse;
  }

  static Future<Distance> distanceTo1(String origin_X, String origin_Y, String destination_X, String destination_Y, int index) async {
    // destination = removeSpaces(destination);
    // var position = await GeolocatorPlatform.instance.getCurrentPosition();
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // var mark = await GeocodingPlatform.instance
    //     .placemarkFromCoordinates(position.latitude, position.longitude);
    // var mark = await Geocoder.google("AIzaSyBYj4SoDS8RsfnMKa_PtmhypjmFjjLuoPM").findAddressesFromCoordinates(new Coordinates(position.latitude, position.longitude));
    
    var response;
    if(index == 0){
      response = await http.get(
        // "https://maps.googleapis.com/maps/api/distancematrix/json?origins=${mark[0].countryName},${mark[0].adminArea},${mark[0].subAdminArea},${mark[0].locality},&destinations=$destination&key=$key",
      "https://maps.googleapis.com/maps/api/distancematrix/json?origins=${position.latitude},${position.longitude}&destinations=${destination_X},${destination_Y}&key=$key",
      );
    }
    else{
      response = await http.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?origins=${origin_X},${origin_Y}&destinations=${destination_X},${destination_Y}&key=$key",
      );
    }
    Map data = jsonDecode(response.body);
    if (data["status"] != "OK"){
      // print("distance:----------");
      return null;
    }
    try {
      if(data["rows"].first["elements"].first["status"] == "OK"){
        var distance = data["rows"].first["elements"].first["distance"]["value"];
        var duration = data["rows"].first["elements"].first["duration"]["value"];
        
        return (Distance(time: duration / 1, distance: distance / 1));
      }
      else{
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  static Future<Distance> distanceTo(String destination_X, String destination_Y) async {
    // destination = removeSpaces(destination);
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // var mark = await GeocodingPlatform.instance
    //     .placemarkFromCoordinates(position.latitude, position.longitude);
    // var mark = await Geocoder.google("AIzaSyBYj4SoDS8RsfnMKa_PtmhypjmFjjLuoPM").findAddressesFromCoordinates(new Coordinates(position.latitude, position.longitude));
    var response = await http.get(
      // "https://maps.googleapis.com/maps/api/distancematrix/json?origins=${mark[0].countryName},${mark[0].adminArea},&destinations=$destination&key=$key",
      "https://maps.googleapis.com/maps/api/distancematrix/json?origins=${position.latitude},${position.longitude}&destinations=${destination_X},${destination_Y}&key=$key",
    );
    Map data = jsonDecode(response.body);
    
    if (data["status"] != "OK"){
      // print("distance:----------");
      return null;
    }
    try {
      if(data["rows"].first["elements"].first["status"] == "OK"){
        var distance = data["rows"].first["elements"].first["distance"]["value"];
        var duration = data["rows"].first["elements"].first["duration"]["value"];
        return (Distance(time: duration / 1, distance: distance / 1));
      }
      else{
        // print("distance:----------");
        return null;
      }
    } catch (e) {
      // print("distance:----------");
      return null;
    }
  }

  static Future<Distance> calculateTime(
    String origin,
    String destination,
  ) async {
    origin = removeSpaces(origin);
    destination = removeSpaces(destination);

    print(destination + "--------------");

    var response = await http.get(
      "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origin&destinations=$destination&key=$key",
    );

    print(response.body);
    Map data = jsonDecode(response.body);
    if (data["status"] != "OK")
      throw Exception("calculating distance error ${data["status"]}");

    try {
      var distance = data["rows"].first["elements"].first["distance"]["value"];
      var duration = data["rows"].first["elements"].first["distance"]["value"];
      return (Distance(time: duration / 1, distance: distance / 1));
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
