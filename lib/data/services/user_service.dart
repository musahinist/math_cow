import 'package:math_cow/data/model/user.dart';
import 'package:math_cow/data/provider/user_api.dart';

class UserService {
  UserApi _uapi;
  UserService({UserApi uapi}) : _uapi = uapi;

  List<User> _users;
  List<User> get users => _users;

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
}
