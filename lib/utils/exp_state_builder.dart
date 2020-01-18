import 'package:flutter/material.dart';
import 'package:math_cow/data/provider/user_api.dart';
import 'package:math_cow/data/services/user_service.dart';
import 'package:math_cow/screens/discovery/discovery.dart';
import 'package:math_cow/utils/loading_anim.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

// Global instantiation
// final Counter counterModel = Counter();

class AppStateBuilderEx extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [
        Inject<UserService>(() => UserService(uapi: UserApi())),
        // Inject<QuestionService>(() => QuestionService(qapi: QuestionApi()))
      ],
      initState: () {
        final ReactiveModel<UserService> topicModelRM =
            Injector.getAsReactive<UserService>();
        topicModelRM.setState((state) => state.getUsers());
      },
      builder: (context) {
        //Use of 'getAsReactive' to get the model.
        //the suffix RM in counterModel means Reactive model.
        final ReactiveModel<UserService> topicModelRM =
            Injector.getAsReactive<UserService>();
        return Scaffold(
          body: HomePageState(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            //To mutate the state, use `setState` method.
            //setState notifies observers after state mutation.
            onPressed: () => topicModelRM.setState((state) {
              Navigator.of(context).pushReplacementNamed('/login');
              return state.forget();
            }
                // registerUser("deneme15", "deneme15@htomail.com", "1234567"), //
                ),
          ),
        );
      },
    );
  }
}

class HomePageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final ReactiveModel<UserService> topicModelRM =
    //     Injector.getAsReactive<UserService>(context: context);
    return StateBuilder<UserService>(
        models: [Injector.getAsReactive<UserService>()],
        builder: (context, model) {
          return model.whenConnectionState(
            onIdle: () => Center(child: Loading()),
            onWaiting: () => Center(child: Loading()),
            onData: (store) => DiscoveryPage(store),
            //  Center(
            //   //use the `state` getter to get the model state.
            //   child: ListView(
            //     children: List<Widget>.generate(
            //       store.users.length,
            //       (i) => Row(
            //         children: <Widget>[
            //           Text("${store.users[i].name}"),
            //           Text(":  ${store.users[i].points}"),
            //           Text(":  ${store.users[i].sId}"),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            onError: (_) => Text("error"),
          );
        });
  }
}
