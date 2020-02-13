import 'package:math_cow/data/model/topic.dart';
import 'package:math_cow/data/model/user.dart';
import 'package:math_cow/data/provider/topic_api.dart';
import 'package:math_cow/data/provider/user_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopicService {
  TopicApi _tapi;
  UserApi _uapi = UserApi();
  TopicService({TopicApi tapi}) : _tapi = tapi;

  int i = 0;
  int j = 0;
  List<Topic> _topics;
  User _me;
  String token;
  List<Topic> get topics => _topics;
  User get me => _me;
  // Future getTopics() async {
  //   _topics = await _tapi.getTopics();
  // }

  Future getMainPageData() async {
    await getToken();
    print(token);
    if (token == "") {
      await registerGuestUser();
    }
    await getTopics();
    await getMe();
  }

  Future getMe() async {
    String body = await _uapi.getMe();
    _me = _uapi.parseMe(body);
  }

  Future getTopics() async {
    await _setTopicsFromApiandSaveToPrefs();
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // var topic = await _setTopicsFromPrefs();
    // // print(_topics);
    // if (topic != "" /*|| connectivityResult == ConnectivityResult.none*/) {
    //   // print("prefs topic: $topic");
    //   await _setTopicsFromPrefs();
    // } else {
    //   await _setTopicsFromApiandSaveToPrefs();
    // }
  }

  Future _save(String jsonTopics) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'topics';
    final value = jsonTopics;
    await prefs.setString(key, value);
    // read();
  }

  Future _setTopicsFromApiandSaveToPrefs() async {
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

  Future registerGuestUser() async {
    await _uapi.registerGuestUser();
  }

  Future getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final String value = prefs.get(key) ?? "";
    this.token = value;
  }
}
