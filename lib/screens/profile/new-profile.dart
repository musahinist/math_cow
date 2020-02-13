import 'package:flutter/material.dart';
import 'package:math_cow/components/app_bar.dart';
import 'package:math_cow/data/services/user_service.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class NProfile extends StatelessWidget {
  // final ReactiveModel<UserService> questionModelRM =
  //     Injector.getAsReactive<UserService>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: size / 5, horizontal: size / 10),
                alignment: AlignmentDirectional.topStart,
                color: Color(0xFF354EF9),
                child: Text("datasdfsdfsdfsdf"),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Color(0xFFE3E7FC),
                padding: EdgeInsets.symmetric(
                    vertical: size / 5, horizontal: size / 10),
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  "dsfsdf",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.edit,
                  color: Color(0xFF354EF9),
                ),
                onPressed: () {}),
            CircleAvatar(
              radius: size / 6,
              backgroundImage:
                  NetworkImage('https://api.adorable.io/avatars/50'),
            ),
            FloatingActionButton(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.settings,
                  color: Color(0xFF354EF9),
                ),
                onPressed: () {}),
          ],
        ),
        TransAppBar(
          ltext: "musa",
          ctext: "PROFILE",
        ),
      ],
    );
  }
}
