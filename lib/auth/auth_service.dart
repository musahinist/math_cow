import 'package:math_cow/data/model/user.dart';
import 'package:math_cow/data/provider/user_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class AuthService {
  UserApi _uapi;
  AuthService({UserApi uapi}) : _uapi = uapi;

  List<User> _users;
  String token;
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

  Future forget() async {
    await _uapi.save("");
  }

  Future getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final String value = prefs.get(key) ?? "";
    token = value;
  }

  final emailController = StreamController<String>();
  final passwordController = StreamController<String>();

  Function(String) get changeEmail => emailController.sink.add;
  Function(String) get changePassword => passwordController.sink.add;

  Stream<String> get email => emailController.stream.transform(validateEmail);
  Stream<String> get password =>
      passwordController.stream.transform(validatePassword);

  submit() {
    print("form submitted");
  }

  //The validation of the email. It must contain @
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if (email.contains("@")) {
        sink.add(email);
      } else {
        sink.addError("Enter a valid Email");
      }
    },
  );
  String _vvvvvvalidateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  //The validation of the password. It must have more than three characters
  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length > 3) {
        sink.add(password);
      } else {
        sink.addError("Enter a valid password");
      }
    },
  );

  //Disposing the controllers
  dispose() {
    emailController.close();
    passwordController.close();
    print("controllers are disposed");
  }
}
