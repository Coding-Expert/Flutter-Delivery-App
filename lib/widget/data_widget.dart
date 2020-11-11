import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nfl_app/utils/constants.dart';

class DataWidget extends StatelessWidget {
  final List<DataItem> data;
  final double margin;

  const DataWidget({Key key, this.margin = 0, this.data = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 5,
      ),
      height: 50,
//      decoration: BoxDecoration(
//        borderRadius: BorderRadius.circular(10),
//        border: Border.all(color: Colors.black12),
//      ),
      padding: EdgeInsets.all(margin),
//      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var item in data) buildTextField(item),
        ],
      ),
    );
  }

  Widget buildExpanded(DataItem item) {
    return Expanded(
      child: Container(
        decoration: item == data.last
            ? null
            : BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.black12,
                  ),
                ),
              ),
        child: Column(
          children: [
            Text(item.key),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                item.icon,
                Text(item.value, maxLines: 1,),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildTextField(DataItem item) {
    return Expanded(
      flex: item.flex,
      child: InputDecorator(
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 5),
            Center(child: item.icon ?? SizedBox.shrink()),
            // SizedBox(width: 5),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 0),
                child: Text(item.value, style: TextStyle(color: Colors.black54, fontSize: item.key == "Commodity" ? 14 :24), maxLines: 1,),
              ),
            //   child: FittedBox(
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(vertical:5),
            //       child:
            //           Text(item.value, style: TextStyle(color: Colors.black54,)),
            //     ),
            //     // fit: BoxFit.contain,
            //   ),
            ),
            // SizedBox(width: 5),
            
          ],
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 14),
          labelText: "  ${item.key}",
          labelStyle: Constants.darkText,
          enabledBorder: OutlineInputBorder(
//            gapPadding: 5,
            borderRadius: BorderRadius.horizontal(
              left:
                  item == data.first ? Radius.circular(10) : Radius.circular(0),
              right:
                  item == data.last ? Radius.circular(10) : Radius.circular(0),
            ),
            borderSide: BorderSide(
              color: Colors.black38,
              width: .5,
            ),
          ),
        ),
      ),
    );
  }
}

class DataItem {
  final String key, value;
  final int flex;
  final Widget icon;

  const DataItem({this.key, this.flex = 1, this.value, this.icon});
}
