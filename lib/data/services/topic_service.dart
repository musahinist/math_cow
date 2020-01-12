import 'package:math_cow/data/model/topic.dart';
import 'package:math_cow/data/provider/topic_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopicService {
  TopicApi _tapi;
  TopicService({TopicApi tapi}) : _tapi = tapi;
  Topic _topic;
  List<Topic> _topics;
  List<Topic> get topics => _topics;

  // Future getTopics() async {
  //   _topics = await _tapi.getTopics();
  // }
  Future getTopics() async {
    String body = await _tapi.getTopics();
    _save(body);

    _topics = _tapi.parseTopics(body);
  }

  _save(String jsonTopics) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'topics';
    final value = jsonTopics;
    await prefs.setString(key, value);
    read();
  }

  Future read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'topics';
    final value = await prefs.get(key) ?? 0;
    // print('read : $value');
    _topics = _tapi.parseTopics(value);
  }
}
