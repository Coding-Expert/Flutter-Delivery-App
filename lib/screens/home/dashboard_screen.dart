import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nfl_app/models/home_screen_module.dart';
import 'package:nfl_app/utils/constants.dart';


class DashBoardScreen extends StatefulWidget {
  final Function(int) onLoadPage;
  static const double padding = 20;

  const DashBoardScreen({Key key, this.onLoadPage}) : super(key: key);
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  DashBoardModule data = DashBoardModule();

  @override
  void initState() {
    
    data.load().then((value) {
      setState(() {});
    });
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    if (data.allLoads == null) {
      return Center(
        // child: SpinKitFoldingCube(
        //   color: Constants.lightOrange,
        // ),
        child: Image.asset("assets/images/itruck-loader.gif", width: 60, height: 60),
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(20.0),
      children: <Widget>[
        GestureDetector(
          onTap:(){
            widget.onLoadPage?.call(3);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Constants.lightOrange,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(2, 5),
                )
              ],
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Load", style: Constants.darkText),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.blue[200]),
                              value: .50,
                              backgroundColor: Colors.white,
                              strokeWidth: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${data.allLoads}\n",
                                        style: Constants.lightTitle,
                                      ),
                                      TextSpan(
                                        text: "loads",
                                        style: Constants.lightText,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
        GestureDetector(
          onTap: () {
            widget.onLoadPage?.call(6);
          },
          child: Container(
            margin: EdgeInsets.only(left: 20),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xffFFCEFA),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(2, 5),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Trip detail", style: Constants.darkText),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Image.asset("assets/images/paper.png"),
                  ),
                )
              ],
            ),
          )
        ),
        GestureDetector(
          onTap: () {
            widget.onLoadPage?.call(5);
          },
          child: Container(
            margin: EdgeInsets.only(right: 20),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xffB0E6FF),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(2, 5),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Profile", style: Constants.darkText),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Image.asset("assets/images/clock-1.png"),
                  ),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap:(){
            widget.onLoadPage?.call(7);
          },
          child: Container(
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Color(0xffFFDD7F),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(2, 5),
                )
              ],
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Complete loads", style: Constants.darkText),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffFBE3DF),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  Color(0xff90c6FF),
                                ),
                                value: .50,
                                backgroundColor: Colors.white,
                                strokeWidth: 8,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "${data.completedLoads}\n",
                                          style: Constants.lightTitle,
                                        ),
                                        TextSpan(
                                          text: "loads",
                                          style: Constants.lightText,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
