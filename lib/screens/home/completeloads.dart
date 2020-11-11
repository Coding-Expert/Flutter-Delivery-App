import 'package:flutter/material.dart';
import 'package:nfl_app/utils/trip.dart';
import 'package:nfl_app/models/loads_module.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nfl_app/utils/constants.dart';
import 'package:nfl_app/widget/order_widget.dart';
import 'package:nfl_app/widget/data_widget.dart';
import 'package:nfl_app/widget/animated_border_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_id/device_id.dart';
import 'package:nfl_app/models/user_model.dart';

class Completeloads extends StatefulWidget{
  
  @override
  CompleteloadsState createState() => CompleteloadsState();
}

class CompleteloadsState extends State<Completeloads>{

  bool loading = true;
  List<Trip> trips1;
  get progress => 0.0;
  String deviceId = "";

  @override
  void initState() {
    init();
    super.initState();
  }
  Future<String> getDeviceID()  async {
    return await DeviceId.getID;
  }
  void init() {
    if (!loading) {
      setState(() {
        loading = true;
      });
    }

    LoadsModule.completedloads()
        .then((value) => setState(() {
              print("trips loading get value -----------");
              trips1 = LoadsModule.trips;
              loading = false;
            }))
        .catchError((err) {
      print(err.toString());
      print("trips loading get error $err ----------");
      trips1 = [];
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
  Widget build(BuildContext context){
    verifyDevice(context);
    if (loading) {
      return Material(
        child: Center(
          child: SpinKitCubeGrid(
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    }
    else if (trips1 == null) {
      return Material(
        child: Center(
          child: SpinKitCubeGrid(
            color: Theme.of(context).primaryColor,
          ),
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
      child: (trips1.isNotEmpty )
        ? ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 10),
              //  ProgressWidget(trip: selectedTrip),
              for (var trip1 in trips1)
                  EachRequest(
                    trips: trip1,
                  )
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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