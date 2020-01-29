import 'package:math_cow/data/model/question.dart';
import 'package:math_cow/data/provider/question_api.dart';
import 'package:math_cow/data/provider/user_api.dart';
import 'dart:convert';

class QuestionService {
  QuestionApi _qapi;
  UserApi _uapi = UserApi();
  QuestionService({QuestionApi qapi}) : _qapi = qapi;

  String _cardID;
  String _topicID;
  bool _isDragCompleted = false;
  bool _isAnswerCorrect = false;
  int correctCounter = 0;
  int wrongCounter = 0;
  //String qID;
  List _questionsAnswerList = [];
  int _index = 0;
  Map data;
  String userID;

  List<Question> _questions;
  Question _question;

  ///GETTER

  int get index => _index;
  String get cardID => _cardID;
  String get topicID => _topicID;
  bool get isDragCompleted => _isDragCompleted;
  bool get isAnswerCorrect => _isAnswerCorrect;
  List get questionsAnswerList => _questionsAnswerList;
  List<Question> get questions => _questions;
  Question get question => _question;

  ///SETTER
  pushAnswerToList(String qID, bool isCorrect) {
    _questionsAnswerList.add({"question_id": qID, "isCorrect": isCorrect});
  }

  setCardandTopicId({String cardId, String topicId}) {
    _cardID = cardId;
    _topicID = topicId;
    print(cardId);
    print(topicId);
  }

  indexIncrement() {
    _index++;
  }

  resetIndex() {
    _index = 0;
  }

  toggleDragCompleted(bool bol) {
    print("correct:$correctCounter");
    print("wrong:$wrongCounter");
    _isDragCompleted = bol;
  }

  toggleAnswerCorrect(bool bol) {
    _isAnswerCorrect = bol;
  }

  ///PROVIDERS

  Future getQuestions(String cID) async {
    _questions = await _qapi.getQuestions(cID);
  }

  Future addUserData() async {
    data = {
      "user_id": userID,
      "points": correctCounter * 3,
      "correctQuestions": correctCounter,
      "wrongQuestions": wrongCounter,
      "finishedCards": [
        {"topicID": _topicID, "cardID": _cardID}
      ],
      "finishedQuestions": questionsAnswerList
    };
    print(data);
    var body = json.encode(data);
    return await _uapi.addUserData(body);
  }
}
