import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_cow/auth/login.dart';
import 'package:math_cow/components/bottom-nav.dart';
import 'package:math_cow/data/provider/topic_api.dart';
import 'package:math_cow/data/provider/user_api.dart';
import 'package:math_cow/data/services/topic_service.dart';
import 'package:math_cow/data/services/user_service.dart';
import 'package:math_cow/screens/discovery/discovery.dart';
import 'package:math_cow/screens/game/flip_game.dart';
import 'package:math_cow/screens/home/home.dart';
import 'package:math_cow/screens/profile/profile.dart';
import 'package:math_cow/utils/draw_svg.dart';
import 'package:math_cow/utils/exp_state_builder.dart';
import 'package:math_cow/utils/loading_anim.dart';
import 'package:math_cow/utils/scroll_animation.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

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
      title: 'MathCow',
      theme: ThemeData(
        brightness: Brightness.dark, /*fontFamily: 'RobotoMono'*/
      ),
      home: App(),
      // initialRoute: '/app',

      // routes: {
      //   // When navigating to the "/" route, build the FirstScreen widget.
      //   '/login': (BuildContext context) => LogIn(),
      //   // When navigating to the "/second" route, build the SecondScreen widget.
      //   '/app': (BuildContext context) => App(),
      //   '/home': (BuildContext context) => HomePage(),
      // },
    );
  }
}

// class Landing extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Stream<String> stream = Stream.fromFuture(UserApi().read());

//     return StreamBuilder(
//       stream: stream,
//       builder: (context, data) {
//         if (data.connectionState == ConnectionState.done) {
//           return data.hasData && data.data != "" ? App() : LogIn();
//         }
//         return Loading();
//       },
//     );
//   }
// }

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _index;
  List<Widget> _page = [
    HomePage(),

    AppStateBuilderEx(),
    // DiscoveryPage(),
    ProfilePage(),

    FlipGame(),
    ScrollAnimation(),
  ];
  @override
  void initState() {
    _index = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
