import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nfl_app/screens/home/redirect_screen.dart';
import 'package:nfl_app/screens/messages/chats_list_screen.dart';
import 'package:nfl_app/screens/search_screen.dart';
import 'package:nfl_app/screens/trips/deliver_request_screen.dart';
import 'package:nfl_app/widget/bottom_navigation.dart';
import 'package:nfl_app/widget/my_appbar_widget.dart';
import 'package:nfl_app/widget/my_drawer_widget.dart';
import 'package:nfl_app/screens/home/tripDetails.dart';
import 'package:nfl_app/screens/home/completeloads.dart';
import 'package:redux/redux.dart';

import 'profile_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatelessWidget {

  getPage(Store<int> index) {
    switch (index.state) {
      case 0:
        return DashBoardScreen(
          onLoadPage: (i) {
            index.dispatch(i);
          },
        );
        break;

      case 1:
        return SearchScreen();
      case 2:
        return ChatsListScreen();
        break;
      case 3:
        return DeliverRequestScreen();
        break;
      case 5:
        return ProfileScreen();
        break;
      case 4:
         return RedirectScreen();
        break;
      case 6:
         return TripDetails();
        break;
      case 7:
         return Completeloads();
        break;
      default:
        return Placeholder();
    }
  }

  page(int index) {
    if (index == 0) return pages.dashboard;
    if (index == 1) return pages.search;
    if (index == 2) return pages.messages;
    if (index == 3) return pages.loads;
    if (index == 4) return pages.redirect;

    if (index == 5) return pages.profile;
    if (index == 6) return pages.details;
    if (index == 7) return pages.completed;
    return null;
  }

  title(int index) {
    if (index == 0) return "Dashboard";
    if (index == 1) return "Search";
    if (index == 2) return "Messages";
    if (index == 3) return "Loads";

    if (index == 5) return "Profile";
    if (index == 6) return "Trip Details";
    if (index == 7) return "Complete loads";
    return "";
  }
  getNavigationNumber(int index){
    if(index == 6 || index == 7){
      return 0;
    }
    if(index == 0) return 0;
    if(index == 1) return 1;
    if(index == 2) return 2;
    if(index == 3) return 3;
    if(index == 4) return 4;
    if(index == 5) return 5;
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<int>(
      builder: (context, vm) => Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.white,
            child: (vm.state != 1 && vm.state != 3)
                ? Image.asset("assets/images/background.png")
                : null,
            alignment: Alignment.topLeft,
          ),
          Scaffold(
            appBar: MyAppBarWidget(
              title: title(vm.state),
              context: context,
            ),
            backgroundColor: Colors.transparent,
            body: getPage(vm),
            endDrawer: MyDrawerWidget(
              page: page(vm.state),
              onPage: (i) {
                vm.dispatch(i);
              },
            ),
            bottomNavigationBar: BottomNavBar(
              selected: getNavigationNumber(vm.state),
              onTap: (i) => vm.dispatch(i),
            ),
          ),
        ],
      ),
    );
  }
}
