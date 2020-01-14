import 'package:math_cow/data/model/topic.dart';
import 'package:math_cow/data/provider/topic_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

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
    // var connectivityResult = await (Connectivity().checkConnectivity());
    await read();
    print(_topics);
    if (_topics != null /*|| connectivityResult == ConnectivityResult.none*/) {
      // await read();
    } else {
      String body = await _tapi.getTopics();
      _topics = _tapi.parseTopics(body);
      await _save(body);
    }
  }

  Future _save(String jsonTopics) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'topics';
    final value = jsonTopics;
    await prefs.setString(key, value);
    // read();
  }

  Future read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'topics';
    final String value = await prefs.get(key) ?? 0;
    print('read : $value');
    _topics = _tapi.parseTopics(value);
  }
}
