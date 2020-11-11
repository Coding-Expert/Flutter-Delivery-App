import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nfl_app/models/chat/chat_bloc.dart';
import 'package:nfl_app/models/chat/chat_utils.dart';
import 'package:nfl_app/screens/home/home_screen.dart';
import 'package:nfl_app/screens/notification_screen.dart';
import 'package:nfl_app/screens/splash_screen.dart';
import 'package:nfl_app/screens/trips/trip_details_screen.dart';
import 'package:nfl_app/utils/trip.dart';
import 'package:redux/redux.dart';

import 'screens/authentication/code_screen.dart';
import 'screens/authentication/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Store<int> store = Store<int>(
    (prev, next) {
      if (next is int)
        return next;
      else
        return prev;
    },
    initialState: 0,
  );
  @override
  Widget build(BuildContext context) {
//    print(Distance.removeSpaces("kenya , soma, 123.1321"));
    return BlocProvider<ChatBloc>(
      create: (context) => ChatBloc(ChatStateLoading()),
      child: StoreProvider(
        store: store,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: theme,
          routes: {
            "/": (ctx) => SplashScreen(),
            "/login": (ctx) => LoginScreen(),
            "/code": (ctx) => CodeScreen(),
            "/home": (ctx) => HomeScreen(),
//            "/map": (ctx) => MapScreen(),
            "/details": (ctx) => TripDetailsScreen(),
            "/notifications": (ctx) => NotificationScreen(),
          },
        ),
      ),
    );
  }

  ThemeData get theme {
    return ThemeData(
      primaryColor: Color(0xffF6908C),
      buttonTheme: ButtonThemeData(
        height: 50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: Colors.transparent,
        // centerTitle: true,
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

//  void testRegex() {
//    String parse = "28 india afsd  1305.1635";
//
//    parse = parse.replaceAllMapped(RegExp(r"\s{1,}"), (match) => "+");
//    parse = parse.replaceAllMapped(RegExp(r"[\d,]*$"), (match) => "+");
//    // remove first and last +
//    parse = parse.replaceAllMapped(RegExp(r"\+*$|^\+*"), (match) => "");
//
//    print(parse);
//  }
}

//todo modify details screen
