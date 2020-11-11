import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nfl_app/models/location_module.dart';
import 'package:nfl_app/utils/order.dart';
import 'package:nfl_app/utils/trip.dart';
import 'package:nfl_app/widget/my_appbar_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nfl_app/widget/progress_widget.dart';

class MapScreen extends StatefulWidget {
  final Trip trip;
  final String time;
  final double distance;
  final double current_lat;
  final double current_long;
  final String pickup_lat;
  final String pickup_long;

  const MapScreen({this.trip, this.time, this.distance, this.current_lat, this.current_long, this.pickup_lat, this.pickup_long});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Order selectedOrder;
  double totalDistance;
  LatLng source_location = LatLng(0, 0);
  LatLng dest_location = LatLng(0, 0);
  Set<Marker> _markers = {};
  GoogleMapController pageController;
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  String googleAPIKey = "AIzaSyBYj4SoDS8RsfnMKa_PtmhypjmFjjLuoPM";

  @override
  void initState() {
    selectedOrder = widget.trip.orders.first;
    print("current_lat:-------------${widget.current_lat}");
    source_location = LatLng(widget.current_lat, widget.current_long);
    dest_location = LatLng(double.parse(widget.pickup_lat), double.parse(widget.pickup_long));
    setSourceAndDestinationIcons();
    // init();
    super.initState();
  }

//   init() async {
//     var position = await GeolocatorPlatform.instance.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.bestForNavigation,
//     );

//     currentPosition = Marker(
//       markerId: MarkerId("cpostion"),
//       infoWindow: InfoWindow(
//         title: "Current Position",
//       ),
//       position: LatLng(position.latitude, position.longitude),
//     );

//     var p = await GeocodingPlatform.instance.locationFromAddress(
//       address[0].split(" ")[0],
//     );

//     destination = Marker(
//       markerId: MarkerId("destination"),
//       position: LatLng(p[0].latitude, p[0].longitude),
//       infoWindow: InfoWindow(
//         title: "Destination",
//       ),
//     );

//     await _createPolylines(currentPosition.position, destination.position);
//     totalDistance = 0.0;
//     for (int i = 0; i < polylineCoordinates.length - 1; i++) {
//       totalDistance += _coordinateDistance(
//         polylineCoordinates[i].latitude,
//         polylineCoordinates[i].longitude,
//         polylineCoordinates[i + 1].latitude,
//         polylineCoordinates[i + 1].longitude,
//       );
//     }
//     //convert to mils
// //    totalDistance *= 0.000621371192;
// // Define two position variables
//     LatLng _northeastCoordinates;
//     LatLng _southwestCoordinates;

// // Calculating to check that
// // southwest coordinate <= northeast coordinate
//     if (currentPosition.position.latitude <= destination.position.latitude) {
//       _southwestCoordinates = currentPosition.position;
//       _northeastCoordinates = destination.position;
//     } else {
//       _southwestCoordinates = destination.position;
//       _northeastCoordinates = currentPosition.position;
//     }

// // Accommodate the two locations within the
// // camera view of the map

//     if (controller != null) {
//       controller.animateCamera(
//         CameraUpdate.newLatLngBounds(
//           LatLngBounds(
//             northeast: _northeastCoordinates,
//             southwest: _southwestCoordinates,
//           ),
//           100.0,
//         ),
//       );
//     }

//     setState(() {});
//   }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBarWidget(title: "Maps", context: context),
      body: Column(
        children: [
          Expanded(
            child: directionMap() //map(),
          ),
          Container(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOrder = widget.trip.orders.firstWhere(
                            (element) => element.type == OrderType.Pickup);
                      });
                      // init();
                    },
                    child: Container(
                      color: selectedOrder.type == OrderType.Pickup
                          ? Colors.blue[100]
                          : Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FittedBox(child: Text(address[0], style: TextStyle(color: Colors.blue))),
                          Text(
                            widget.trip.orders.first.locationName,
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOrder = widget.trip.orders.lastWhere(
                            (element) => element.type == OrderType.delivery);
                      });
                      // init();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedOrder.type == OrderType.delivery
                            ? Colors.blue[100]
                            : Colors.white,
                        border: Border(
                          left: BorderSide(color: Colors.black12),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery",
                            style: TextStyle(color: Colors.blue),
                          ),
                          Text(
                            widget.trip.orders
                                .lastWhere((element) =>
                                    element.type == OrderType.delivery)
                                .locationName,
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.black,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Deliver Time",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      /*Text(
                        "${widget.trip.deliveryTime?.inHours ?? 0}H ${(widget.trip.deliveryTime?.inMinutes ?? 0 / 60).ceil()}M",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),*/

                      Text(
                        "${(widget.time)}Hrs",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Distance",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "${(widget.distance / 1609).toStringAsFixed(2)} ML",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      /*Text(
                        "${totalDistance?.toStringAsFixed(0)} ML",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GoogleMapController controller;
  Marker currentPosition;
  Marker destination;

  LatLng position;

  // map() {
  //   Set<Marker> set = {};
  //   if (currentPosition != null) {
  //     set.add(currentPosition);
  //   }
  //   if (destination != null) {
  //     set.add(destination);
  //   }

  //   return GoogleMap(
  //     initialCameraPosition: CameraPosition(target: LatLng(0.0, 0.0)),
  //     myLocationEnabled: true,
  //     myLocationButtonEnabled: true,
  //     mapType: MapType.normal,
  //     zoomGesturesEnabled: true,
  //     zoomControlsEnabled: false,
  //     polylines: Set<Polyline>.of(polylines.values),
  //     onMapCreated: (ctr) {
  //       controller = ctr;
  //     },
  //     markers: {currentPosition, destination}..removeWhere(
  //         (element) => element == null,
  //       ),
  //   );
  // }
  directionMap(){
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      compassEnabled: true,
      tiltGesturesEnabled: false,
      initialCameraPosition: CameraPosition(
        // target: _kMapCenter,
        target: dest_location, //source_location,
        zoom: 13.0,
        tilt: 0,
        bearing: 30
      ),
      // markers: _createMarker(),/////////////
      markers: _markers,
      polylines: _polylines,
      onMapCreated: _onMapCreated,
    );
  }

  // PolylinePoints polylinePoints;
  // List<LatLng> polylineCoordinates = [];
  // Map<PolylineId, Polyline> polylines = {};

  // _createPolylines(LatLng start, LatLng destination) async {
  //   polylinePoints = PolylinePoints();
  //   polylineCoordinates.clear();
  //   polylines.clear();

  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     Distance.key, // Google Maps API Key
  //     PointLatLng(start.latitude, start.longitude),
  //     PointLatLng(destination.latitude, destination.longitude),
  //     travelMode: TravelMode.transit,
  //   );

  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //   }

  //   PolylineId id = PolylineId('poly');

  //   Polyline polyline = Polyline(
  //     polylineId: id,
  //     color: Colors.red,
  //     points: polylineCoordinates,
  //     width: 3,
  //   );

  //   // Adding the polyline to the map
  //   polylines[id] = polyline;
  // }
  void _onMapCreated(GoogleMapController controller) {
      pageController = controller;
      setMapPins();
      setPolylines();
  }
  void setMapPins() {
    
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: source_location,
          icon: sourceIcon));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: dest_location,
          icon: destinationIcon));
    });
  }
  void setPolylines() async {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          googleAPIKey,PointLatLng(source_location.latitude, source_location.longitude),PointLatLng(dest_location.latitude,dest_location.longitude));
      if (result.points.isNotEmpty) {
        print("polylines:------------ ${result.points}");
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          
        });
      }

      setState(() {
          Polyline polyline = Polyline(
              polylineId: PolylineId("poly"),
              color: Color.fromARGB(255, 40, 122, 198),
              points: polylineCoordinates);
          _polylines.add(polyline);
      });
  }
  void setSourceAndDestinationIcons() async {
      sourceIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 2.5), 'assets/driving_pin.png');
      destinationIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 2.5),
          'assets/destination_map_marker.png');
    }
}
