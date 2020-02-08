import 'package:flutter/material.dart';
import 'package:math_cow/components/app_bar.dart';

import 'package:math_cow/utils/loading_anim.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:math_cow/data/services/user_service.dart';

class DiscoveryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Injector(
        inject: [
          Inject<UserService>(() => UserService()),
        ],
        initState: () {
          final ReactiveModel<UserService> topicModelRM =
              Injector.getAsReactive<UserService>();
          topicModelRM.setState(
            (state) async => await state.getUsers(),
          );
        },
        builder: (context) {
          return Stack(
            children: <Widget>[
              Scaffold(
                body: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.teal[600]
                        // gradient: LinearGradient(
                        //     begin: Alignment.topCenter,
                        //     colors: [Colors.teal[600], Colors.lime[300]]),
                        ),
                    child: WhenRebuilder<UserService>(
                      models: [Injector.getAsReactive<UserService>()],
                      onIdle: () => Text("idle"),
                      onError: (_) => Text("error"),
                      onWaiting: () => Center(child: Loading()),
                      onData: (store) => Column(
                        children: <Widget>[
                          SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Leadership",
                                  // style: TextStyle(color: Colors.white, fontSize: 40),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    _buildCircleavatar(1),
                                    Text(
                                      store.users[1].name,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          color: Colors.grey[50],
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "PRO",
                                      style: TextStyle(
                                          color: Colors.grey[100],
                                          fontWeight: FontWeight.bold),
                                    ),
                                    _roundedButton(
                                        title: "1000",
                                        color: Colors.lime[500],
                                        margin: 10,
                                        padding: 10),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    _buildCircleavatar(0),
                                    Text(
                                      store.users[0].name,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          color: Colors.grey[50],
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "PRO",
                                      style: TextStyle(
                                          color: Colors.grey[100],
                                          fontWeight: FontWeight.bold),
                                    ),
                                    _roundedButton(
                                        title: "1000",
                                        color: Colors.lime[500],
                                        margin: 10,
                                        padding: 10),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    _buildCircleavatar(2),
                                    Text(
                                      store.users[2].name,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          color: Colors.grey[50],
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "PRO",
                                      style: TextStyle(
                                          color: Colors.grey[100],
                                          fontWeight: FontWeight.bold),
                                    ),
                                    _roundedButton(
                                        title: "1000",
                                        color: Colors.lime[500],
                                        margin: 10,
                                        padding: 10),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      topRight: Radius.circular(40))),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: store.users.length,
                                  itemBuilder: (context, index) =>
                                      _buildList(context, index, store),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              ),
              TransAppBar(
                licon: Icons.toys,
                ltext: " 25 Cards",
                ctext: "DISCOVERY",
                rtext: Text("data"),
                ricon: Icons.timelapse,
              ),
            ],
          );
        });
  }

  Padding _buildCircleavatar(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          CircleAvatar(
            foregroundColor: Colors.red,
            radius: 40,
            backgroundColor: Colors.green[100],
            child: FlutterLogo(
              size: 100,
            ),
          ),
          _roundedButton(
              title: "${index + 1}",
              color: Colors.teal[500],
              margin: 8,
              padding: 5)
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, int index, UserService store) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "#${index + 1}",
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
          _roundedButton(
              title: "${store.users[index].points}",
              color: Colors.lime[500],
              margin: 10,
              padding: 10),
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "${store.users[index].name}",
                    style: TextStyle(
                        color: Colors.grey[900], fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "PRO Istanbul - TR",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.green[100],
                  child: FlutterLogo(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _roundedButton(
      {String title, Color color, double margin = 0, double padding = 0}) {
    return InkWell(
      child: Container(
        height: 20,
        //width: 50,
        padding: EdgeInsets.symmetric(horizontal: padding),
        margin: EdgeInsets.symmetric(horizontal: margin),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: color),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
