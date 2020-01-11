import 'package:math_cow/data/model/question.dart';
import 'package:math_cow/data/provider/user_api.dart';

class QuestionService {
  API _api;
  QuestionService({API api}) : _api = api;

  List<Question> _questions;
  List<Question> get questions => _questions;

  Future getQuestions(String cardID) async {
    _questions = await _api.getQuestions(cardID);
  }
}
