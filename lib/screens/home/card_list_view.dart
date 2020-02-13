import 'package:flutter/material.dart';
import 'package:math_cow/components/app_bar.dart';
import 'package:math_cow/data/model/topic.dart';
import 'package:math_cow/data/provider/question_api.dart';
import 'package:math_cow/data/services/question_service..dart';
import 'package:math_cow/data/services/topic_service.dart';
import 'package:math_cow/screens/game/game.dart';
import 'package:math_cow/screens/home/hero.dart';
import 'package:math_cow/utils/fade_animation.dart';
import 'package:math_cow/utils/loading_anim.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class CardListView extends StatelessWidget {
  int length = 0;
  int index = -1;
  @override
  Widget build(BuildContext context) {
    // setTopics();

    return WhenRebuilder<TopicService>(
      models: [Injector.getAsReactive<TopicService>()],
      onIdle: () => Center(child: Loading()),
      onWaiting: () => Center(child: Loading()),
      onError: (_) => Text("error"),
      onData: (store) => Stack(
        children: <Widget>[
          ListView(
            physics: BouncingScrollPhysics(),
            children: List<Widget>.generate(store.topics.length,
                (i) => _buildTopicsWithData(context, store.topics[i], store, i))
              ..insert(0, HeroWidget(store: store)),
          ),
          TransAppBar(
              licon: Icons.featured_play_list,
              ltext: "$length", //"${store.me.name}",
              ctext: "GAMES",
              rtext: Text("${store.me.points}"),
              ricon: Icons.monetization_on),
        ],
      ),
    );
  }

  Widget _buildTopicsWithData(
      BuildContext context, Topic data, TopicService store, int i) {
    if (index + 1 < store.me.finishedCards.length &&
        store.me.finishedCards[index + 1].topicID == store.topics[i].topicID) {
      this.index++;
    }
    return FadeAnimation(
      0.2,
      Container(
        margin: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(data.topicName),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                children: List<Widget>.generate(data.cards.length, (j) {
                  return _buildSubjectCard(
                      context, j, data.cards[j], data.topicID, store, i);
                }),

                // itemBuilder: (context, j) {
                //   var isOpen = store.me.finishedCards.any((value) =>
                //       value.topicID == data.topicID &&
                //       value.cardID == data.cards[j].cardID);
                //   matchTablo.add(isOpen);

                //   return _buildSubjectCard(context, matchTablo, j,
                //       data.cards[j], data.topicID, store, i);
                // },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, int j, Cards card,
      String topicID, TopicService store, i) {
    // int before = cardIndex - 1 < 0 ? 0 : cardIndex - 1;
    // if (i + 1 < store.me.finishedCards.length &&
    //     store.me.finishedCards[topicIndex].topicID == store.topics[i].topicID) {
    //   print(topicIndex);
    //   topicIndex++;
    // }
    return GestureDetector(
      onTap: () {
        if (j == 0 ||
            index < store.me.finishedCards.length &&
                j < store.me.finishedCards[index].cards.length &&
                store.me.finishedCards[index].topicID ==
                    store.topics[i].topicID &&
                (store.me.finishedCards[index].cards[j].cardID ==
                    store.topics[i].cards[j].cardID) ||
            index < store.me.finishedCards.length &&
                j < store.me.finishedCards[index].cards.length &&
                store.me.finishedCards[index - 1].topicID ==
                    store.topics[i].topicID &&
                (store.me.finishedCards[index].cards[j - 1].cardID ==
                    store.topics[i].cards[j - 1].cardID)) {
          store.i = i;
          store.j = j;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Injector(
                inject: [
                  Inject<QuestionService>(
                      () => QuestionService(qapi: QuestionApi()))
                ],
                initState: () {
                  final ReactiveModel<QuestionService> questionModelRM =
                      Injector.getAsReactive<QuestionService>();
                  questionModelRM.setState((state) async {
                    await state.getQuestions("$topicID/${card.cardID}");
                    state.setCardandTopicId(
                        cardId: card.cardID, topicId: topicID);
                    state.userID = store.me.sId;
                  });
                },
                builder: (context) => GamePage(),
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: (j == 0 ||
                  j < store.me.finishedCards[index].cards.length &&
                      store.me.finishedCards[index].topicID ==
                          store.topics[i].topicID &&
                      (store.me.finishedCards[index].cards[j].cardID ==
                          store.topics[i].cards[j].cardID) ||
                  j - 1 < store.me.finishedCards[index].cards.length &&
                      store.me.finishedCards[index].topicID ==
                          store.topics[i].topicID &&
                      (store.me.finishedCards[index].cards[j - 1].cardID ==
                          store.topics[i].cards[j - 1].cardID))
              ? Colors.grey[800]
              : Colors.grey[600],
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.all(20.0),
        margin: j == 0
            ? const EdgeInsets.only(left: 20.0)
            : const EdgeInsets.only(left: 10.0),
        width: MediaQuery.of(context).size.width * 0.37,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(card.cardName, style: TextStyle(fontWeight: FontWeight.bold)),
            _cardLock(store, j, i),
          ],
        ),
      ),
    );
  }

  Widget _cardLock(TopicService store, int j, int i) {
    if (j < store.me.finishedCards[index].cards.length &&
        store.me.finishedCards[index].topicID == store.topics[i].topicID &&
        store.me.finishedCards[index].cards[j].cardID ==
            store.topics[i].cards[j].cardID) {
      this.length++;

      var accr = store.me.finishedCards[index].cards[j].accuracyPercentageInCard
          .toStringAsFixed(0);
      var row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(Icons.star,
              color: store.me.finishedCards[index].cards[j]
                          .accuracyPercentageInCard <
                      50
                  ? Colors.red
                  : Colors.amber[800]),
          Text("$accr%")
        ],
      );
      //  this.index++;

      return row;
    } else if (j == 0) {
      return Icon(Icons.lock_open);
    } else if (j - 1 < store.me.finishedCards[index].cards.length &&
        store.me.finishedCards[index].topicID == store.topics[i].topicID &&
        (store.me.finishedCards[index].cards[j - 1].cardID ==
            store.topics[i].cards[j - 1].cardID)) {
      return Icon(Icons.lock_open);
    } else {
      return Icon(Icons.lock);
    }
  }
}
