import 'package:math_cow/data/model/topic.dart';
import 'package:math_cow/data/provider/user_api.dart';

class TopicService {
  API _api;
  TopicService({API api}) : _api = api;

  List<Topic> _topics;
  List<Topic> get topics => _topics;

  Future getTopics() async {
    _topics = await _api.getTopics();
  }
}
