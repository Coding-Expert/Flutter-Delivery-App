import 'package:flutter/material.dart';
import 'package:nfl_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum pages {
  dashboard,
  loads,
  details,
  history,
  completed,
  messages,
  profile,
  search,
  redirect,
  
}

class MyDrawerWidget extends StatelessWidget {
  final Function(int) onPage;
  final pages page;

  const MyDrawerWidget({Key key, this.page, this.onPage}) : super(key: key);

  static const color = Colors.green;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          header,
          Container(
            color: page == pages.dashboard
                ? Colors.green[100]
                : Colors.transparent,
            child: ListTile(
              // todo change icon
              leading: Icon(Icons.dashboard, color: color),
              title: Text("Dashboard"),
              onTap: () {
                onPage?.call(0);
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            color: page == pages.loads ? Colors.green[100] : Colors.transparent,
            child: ListTile(
              leading: Image.asset(
                "assets/images/unit.png",
                width: 30,
                color: color,
              ),
              title: Text("Loads"),
              onTap: () {
                onPage?.call(3);
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            color:
                page == pages.details ? Colors.green[100] : Colors.transparent,
            child: ListTile(
              leading: Image.asset(
                "assets/images/paper.png",
                width: 30,
                color: color,
              ),
              title: Text("Trip details"),
              onTap: () {},
            ),
          ),
          Container(
            color: page == pages.completed
                ? Colors.green[100]
                : Colors.transparent,
            child: ListTile(
              leading: Image.asset(
                "assets/images/complete.png",
                width: 30,
                color: color,
              ),
              title: Text("Completed Loads"),
              onTap: () {},
            ),
          ),
          Container(
            color:
                page == pages.messages ? Colors.green[100] : Colors.transparent,
            child: ListTile(
              leading: Image.asset(
                "assets/images/comment.png",
                width: 30,
                color: color,
              ),
              title: Text("Messages"),
              onTap: () {
                onPage?.call(2);
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            color:
                page == pages.profile ? Colors.green[100] : Colors.transparent,
            child: ListTile(
              leading: Image.asset(
                "assets/images/User.png",
                width: 30,
                color: color,
              ),
              title: Text("Profile"),
              onTap: () {
                onPage?.call(5);
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            color:
                page == pages.search ? Colors.green[100] : Colors.transparent,
            child: ListTile(
              leading: Icon(
                Icons.search,
                color: color,
              ),
              title: Text("Search"),
//              onTap: () {
//                onPage?.call(1);
//                Navigator.pop(context);
//              },
            ),
          ),
          ListTile(
            leading: Image.asset(
              "assets/images/logout.png",
              width: 30,
              color: color,
            ),
            onTap: () => logout(context),
            title: Text("Logout"),
          ),
        ],
      ),
    );
  }

  ListTile get header {
    return ListTile(
      leading: AspectRatio(
        aspectRatio: 1,
        child: CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(UserModel.user.imageUrl ?? ""),
        ),
      ),
      title: Text(
        UserModel.user.name,
        style: TextStyle(
          fontSize: 21,
          color: Colors.green,
        ),
      ),
      subtitle:
          Text("15023.93 km - 70 runs"), //todo chnge this is static content
    );
  }

  logout(BuildContext context) async {
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    SharedPreferences sh = await SharedPreferences.getInstance();
    await sh.remove("number");
    Navigator.pushReplacementNamed(context, "/");
  }
}
