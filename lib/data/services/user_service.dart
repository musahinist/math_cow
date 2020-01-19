import 'package:math_cow/data/model/user.dart';
import 'package:math_cow/data/provider/user_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  UserApi _uapi;
  UserService({UserApi uapi}) : _uapi = uapi;

  List<User> _users;
  User _me;
  String token;
  List<User> get users => _users;
  User get me => _me;

  getUsers() async {
    _users = await _uapi.getUsers();
  }

  // Future postUser(name, email, password) async {
  //   await _uapi.postUser(name, email, password);
  // }

  Future registerUser(name, email, password) async {
    await _uapi.registerUser(name, email, password);
  }

  Future logInUser(email, password) async {
    await _uapi.logInUser(email, password);
  }

  // Future getMe() async {
  //   body = await _uapi.getMe();
  // }

  Future forget() async {
    await _uapi.save("");
  }

  Future getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final String value = prefs.get(key) ?? "";
    token = value;
  }
}
