import 'package:flutter/material.dart';
import 'package:nfl_app/models/consignees.dart';
import 'package:nfl_app/models/shippers.dart';
import 'package:nfl_app/utils/constants.dart';
import 'package:nfl_app/utils/order.dart';
import 'package:nfl_app/widget/circle_of_time.dart';
import 'package:nfl_app/widget/colorfull_divider_widget.dart';

class OrderWidget extends StatefulWidget {
  final Order order;
  final bool last;
  final List<Consignees> consignees;
  final List<Shippers> shippers;

  const OrderWidget({
    Key key,
    this.order,
    this.last = false,
    this.consignees,
    this.shippers,
  }) : super(key: key);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  var list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    list = null;

    list = <Widget>[
      for (var i in widget.shippers) ShipperWidget(shippers: i, last: false, first: (widget.shippers.indexOf(i) == 0)),
      for (var j in widget.consignees)
        ConsigneeWidget(
          consignees: j,
          last: (widget.consignees.indexOf(j) == widget.consignees.length - 1),
        ),
        
    ];
//    print("Order location Name" + widget.order.locationName);
//    print(widget.shippers.length);
//    print(widget.consignees.length);

    Color color = widget.order.type == OrderType.delivery
        ? Constants.lightGreen
        : Constants.lightBlue;
    return Column(children: list);
  }
}

//Delivery
class ConsigneeWidget extends StatelessWidget {
  final Consignees consignees;
  final bool last;

  const ConsigneeWidget({Key key, this.consignees, this.last})
      : super(key: key); //Delivery Widget
  @override
  Widget build(BuildContext context) {
    print(consignees);
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 45,
            child: Row(
              children: [
                CircleOfTime1(
                  color: Constants.lightGreen,
                date: consignees.consigneedate,

                  ///date: (consignees.consigneedate),
                  time: consignees.consigneetime,
                  //time: "",
                ),
                ColorfulDividerWidget(
                  color: Constants.lightGreen,
                  last: last,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(top: 3)),
                      Text(
                        "Delivery",
                        style: TextStyle(
                          color: Constants.lightGreen,
                        fontSize: 16 ,
      //                    fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        consignees.concity + "," + consignees.constate + "," + consignees.concountry,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400), maxLines: 1,
                      ),
                      
                    ],
                  ),
                ),
              ],
            ),
          ),
          if(!last)
            Divider(
              color: Colors.black,
              height: 0
            )
        ]
      )
      
    );
  }
}

//pickup shipper widgte
class ShipperWidget extends StatelessWidget {
  final Shippers shippers;
  final bool last;
  final bool first;

  const ShipperWidget({Key key, this.shippers, this.last, this.first })
      : super(key: key); //Delivery Widget
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      // height: 70,
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 45,
            child: Row(
              children: [
                CircleOfTime1(
                  color: Constants.lightBlue,
                  date: (shippers.shippingdate),
                  time: shippers.shippingtime,
                ),
                
                ColorfulDividerWidget(
                  color: Constants.lightBlue,
                  last: last,
                  first: first,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(top: 3)),
                      Text(
                        "Pickup",
                        style: TextStyle(
                          color: Constants.blue,
                        //  fontSize: 16 ,
      //                    fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        shippers.ship_pickup_city + "," + shippers.ship_pickup_state + "," + shippers.ship_pickup_country,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400), maxLines: 1,
                      ),
                      
                    ],
                  ),
                ),
                ],
              ),
          ),
          Divider(
            color: Colors.black,
            height: 0,
          )
          
        ]
      )
      
    );
  }
}
