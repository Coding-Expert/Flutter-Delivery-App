import 'package:flutter/material.dart';
import 'package:nfl_app/utils/constants.dart';
import 'package:nfl_app/utils/order.dart';
import 'package:nfl_app/widget/circle_of_time.dart';
import 'package:nfl_app/widget/colorfull_divider_widget.dart';

class OrderWidget extends StatelessWidget {
  final Order order;
  final bool last;

  const OrderWidget({
    Key key,
    this.order,
    this.last = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {



    print("Order location Name"+order.locationName);
    Color color = order.type == OrderType.delivery
        ? Constants.lightGreen
        : Constants.lightBlue;
    return Container(
      width: double.infinity,
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          CircleOfTime(
            color: color,
            date: order.date,
          ),
          ColorfulDividerWidget(
            color: color,
            last: last,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  order.type == OrderType.Pickup ? "Pickup" : "Delivery",
                  style: TextStyle(
                    color: order.type == OrderType.Pickup
                        ? Constants.blue
                        : Constants.lightGreen,
//                    fontSize: 16 ,
//                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  order.locationName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
