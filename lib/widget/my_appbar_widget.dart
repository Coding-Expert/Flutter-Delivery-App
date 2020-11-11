import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAppBarWidget extends AppBar {
  MyAppBarWidget({
    @required String title,
    BuildContext context,
  }) : super(
          title: Text(title),
          centerTitle: true,
          backgroundColor:Colors.transparent,
          actions: [
            if (context != null)
              IconButton(
                icon: Icon(CupertinoIcons.bell_solid),
                onPressed: () => Navigator.pushNamed(context, "/notifications"),
              ),
            Builder(
              builder: (context) {
                if (!Scaffold.of(context).hasEndDrawer) return SizedBox();
                return IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                );
              },
            ),
          ],
        );
}
