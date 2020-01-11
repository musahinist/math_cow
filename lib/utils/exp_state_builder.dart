import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:math_cow/data/provider/user_api.dart';
import 'package:math_cow/data/services/question_service..dart';
import 'package:math_cow/data/services/topic_service.dart';
import 'package:math_cow/utils/loading_anim.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

//Global instantiation
//final Counter counterModel = Counter();

class AppStateBuilderEx extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [
        Inject<TopicService>(() => TopicService(api: API())),
        Inject<QuestionService>(() => QuestionService(api: API()))
      ],
      initState: () {
        final ReactiveModel<TopicService> topicModelRM =
            Injector.getAsReactive<TopicService>();
        topicModelRM.setState((state) => state.getTopics());
      },
      builder: (context) {
        //Use of 'getAsReactive' to get the model.
        //the suffix RM in counterModel means Reactive model.
        final ReactiveModel<TopicService> topicModelRM =
            Injector.getAsReactive<TopicService>();
        return MaterialApp(
          home: Scaffold(
            body: HomePageState(),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              //To mutate the state, use `setState` method.
              //setState notifies observers after state mutation.
              onPressed: () =>
                  topicModelRM.setState((state) => state.getTopics()),
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
    // final ReactiveModel<TopicService> topicModelRM =
    //     Injector.getAsReactive<TopicService>(context: context);
    return StateBuilder<TopicService>(
        models: [Injector.getAsReactive<TopicService>()],
        builder: (context, model) {
          return model.whenConnectionState(
            onIdle: () => null,
            onWaiting: () => Center(child: Loading()),
            onData: (store) => Center(
              //use the `state` getter to get the model state.
              child: Text("${store.topics[0].topicName}"),
            ),
            onError: (_) => null,
          );
        });
  }
}
