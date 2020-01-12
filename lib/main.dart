import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_cow/auth/login.dart';
import 'package:math_cow/components/bottom-nav.dart';
import 'package:math_cow/screens/discovery/discovery.dart';
import 'package:math_cow/screens/game/flip_game.dart';
import 'package:math_cow/screens/home/home.dart';
import 'package:math_cow/screens/profile/profile.dart';
import 'package:math_cow/utils/exp_state_builder.dart';
import 'package:math_cow/utils/scroll_animation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([/*SystemUiOverlay.bottom*/]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // This widget is the root of application.
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(brightness: Brightness.dark),
        home: App());
  }
}

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _index;
  List<Widget> _page = [
    AppStateBuilderEx(),
    HomePage(),
    LogIn(),
    FlipGame(),
    ScrollAnimation(),
    DiscoveryPage(),
    ProfilePage()
  ];
  @override
  void initState() {
    _index = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page.elementAt(_index),
      bottomNavigationBar: BottomNavBar(setIndex: (i) {
        setState(() {
          _index = i;
        });
      }),
    );
  }
}
