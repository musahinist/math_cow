import 'package:flutter/material.dart';
import 'package:math_cow/components/app_bar.dart';
import 'package:math_cow/data/provider/topic_api.dart';
import 'package:math_cow/data/services/topic_service.dart';
import 'package:math_cow/utils/loading_anim.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color color1 = Color(0xffFC5CF0);
    final Color color2 = Color(0xffFE8852);
    //   final String image = avatars[0];
    return Injector(
        inject: [Inject<TopicService>(() => TopicService(tapi: TopicApi()))],
        initState: () {
          final ReactiveModel<TopicService> topicModelRM =
              Injector.getAsReactive<TopicService>();
          topicModelRM.setState((state) async => await state.getMe());
        },
        builder: (context) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color1,
                      Colors.pink[900], /*Colors.orange[900]*/
                    ]),
              ),
              child: StateBuilder<TopicService>(
                  models: [Injector.getAsReactive<TopicService>()],
                  builder: (context, snapshot) {
                    return snapshot.whenConnectionState(
                      onIdle: () => Center(child: Loading()),
                      onWaiting: () => Center(child: Loading()),
                      onError: (_) => null,
                      onData: (store) => Stack(
                        children: <Widget>[
                          Container(
                            height: 360,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(50.0),
                                    bottomRight: Radius.circular(50.0)),
                                gradient: LinearGradient(
                                    colors: [color1, color2],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 80),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "MathCow",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontStyle: FontStyle.italic),
                                ),
                                SizedBox(height: 20.0),
                                Expanded(
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: <Widget>[
                                      Container(
                                        height: 200,
                                        // margin: const EdgeInsets.only(
                                        //     left: 30.0, right: 30.0, top: 10.0),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            //Add İmage
                                            child: Image.network(
                                              'https://api.adorable.io/avatars/285/${store.me.email}.png',
                                              // color: Colors.pinkAccent,
                                              // colorBlendMode: BlendMode.color,
                                            )),
                                      ),
                                      Container(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 5.0),
                                          decoration: BoxDecoration(
                                              color: Colors.orangeAccent,
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          child:
                                              Text(store.me.points.toString()),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  store.me.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      size: 16.0,
                                      //  color: Colors.grey,
                                    ),
                                    Text(
                                      "İstanbul,TR",
                                      // style: TextStyle(color: Colors.grey.shade600),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(
                                      //color: Colors.grey,
                                      icon: Icon(Icons.ac_unit),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      // color: Colors.grey,
                                      icon: Icon(Icons.aspect_ratio),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      //  color: Colors.grey.shade600,
                                      icon: Icon(Icons.ac_unit),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Container(
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 16.0),
                                        margin: const EdgeInsets.only(
                                            top: 30,
                                            left: 20.0,
                                            right: 20.0,
                                            bottom: 20.0),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [color1, color2],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                              color: Colors.white,
                                              icon: Icon(
                                                  Icons.supervised_user_circle),
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              color: Colors.white,
                                              icon: Icon(Icons.location_on),
                                              onPressed: () {},
                                            ),
                                            Spacer(),
                                            IconButton(
                                              color: Colors.white,
                                              icon: Icon(Icons.add),
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              color: Colors.white,
                                              icon: Icon(Icons.message),
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                      Center(
                                        child: FloatingActionButton(
                                          child: Icon(
                                            Icons.favorite,
                                            color: Colors.pink,
                                          ),
                                          backgroundColor: Colors.white,
                                          onPressed: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          TransAppBar(
                            licon: Icons.toys,
                            ltext:
                                " ${store.me.finishedCards.length} Cards" + "",
                            ctext: "PROFILE",
                            rtext: Text("data"),
                            ricon: Icons.timelapse,
                          ),
                          // AppBar(
                          //   backgroundColor: Colors.transparent,
                          //   title: Text("PROFILE"),
                          //   centerTitle: true,
                          //   elevation: 0,
                          //   actions: <Widget>[
                          //     IconButton(
                          //       icon: Icon(Icons.notifications),
                          //       onPressed: () {},
                          //     ),
                          //     IconButton(
                          //       icon: Icon(Icons.menu),
                          //       onPressed: () {},
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    );
                  }),
            ),
          );
        });
  }
}
