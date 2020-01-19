import 'package:math_cow/data/model/topic.dart';
import 'package:math_cow/data/model/user.dart';
import 'package:math_cow/data/provider/topic_api.dart';
import 'package:math_cow/data/provider/user_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

class TopicService {
  TopicApi _tapi;
  UserApi _uapi = UserApi();
  TopicService({TopicApi tapi}) : _tapi = tapi;

  List<Topic> _topics;
  User _me;
  List<Topic> get topics => _topics;
  User get me => _me;
  // Future getTopics() async {
  //   _topics = await _tapi.getTopics();
  // }
  Future getMe() async {
    print("Call MEE");
    String body = await _uapi.getMe();
    print(body);
    _me = _uapi.parseMe(body);
    print("_me: $_me");
  }

  Future getMainPageData() async {
    await getTopics();
    await getMe();
  }

  Future getTopics() async {
    // var connectivityResult = await (Connectivity().checkConnectivity());
    var topic = await _setTopicsFromPrefs();
    // print(_topics);
    if (topic != "" /*|| connectivityResult == ConnectivityResult.none*/) {
      // print("prefs topic: $topic");
      _setTopicsFromPrefs();
    } else {
      _setTopicsFromApiandSavaToPrefs();
    }
  }

  Future _save(String jsonTopics) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'topics';
    final value = jsonTopics;
    await prefs.setString(key, value);
    // read();
  }

  Future _setTopicsFromApiandSavaToPrefs() async {
    String body = await _tapi.getTopics();
    _topics = _tapi.parseTopics(body);
    await _save(body);
  }

  Future _setTopicsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'topics';
    final String value = await prefs.get(key) ?? "";

    _topics = _tapi.parseTopics(value);
    return value;
  }
}
