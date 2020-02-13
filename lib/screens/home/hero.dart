import 'package:flutter/material.dart';
import 'package:math_cow/data/provider/question_api.dart';
import 'package:math_cow/data/services/question_service..dart';
import 'package:math_cow/data/services/topic_service.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:math_cow/screens/game/game.dart';

class HeroWidget extends StatelessWidget {
  TopicService store;
  HeroWidget({this.store});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 70,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  store.topics[store.i].topicName,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  store.topics[store.i].cards[store.j].cardName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  elevation: 0,
                  padding: const EdgeInsets.fromLTRB(45, 20, 45, 20),
                  color: Colors.grey[800],
                  child: Text(
                    "Continue",
                    // style: TextStyle(color: Colors.amber[800]),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Injector(
                              inject: [
                                Inject<QuestionService>(
                                    () => QuestionService(qapi: QuestionApi()))
                              ],
                              initState: () {
                                final ReactiveModel<QuestionService>
                                    questionModelRM =
                                    Injector.getAsReactive<QuestionService>();
                                questionModelRM.setState((state) async {
                                  state.setCardandTopicId(
                                      cardId: store.topics[store.i]
                                          .cards[store.j].cardID,
                                      topicId: store.topics[store.i].topicID);
                                  state.userID = store.me.sId;
                                  await state.getQuestions(
                                      "${store.topics[store.i].topicID}/${store.topics[store.i].cards[store.j].cardID}");
                                });
                              },
                              builder: (context) => GamePage(),
                            )));
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
