import 'package:math_cow/data/model/question.dart';
import 'package:math_cow/data/provider/question_api.dart';

class QuestionService {
  QuestionApi _qapi;
  QuestionService({QuestionApi qapi}) : _qapi = qapi;

  List<Question> _questions;
  List<Question> get questions => _questions;

  Future getQuestions(String cardID) async {
    _questions = await _qapi.getQuestions(cardID);
  }
}
