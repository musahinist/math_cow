import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:math_cow/data/model/question.dart';
import 'package:math_cow/data/model/topic.dart';
import 'package:math_cow/data/model/user.dart';

class API {
  static const baseUrl = "http://mathcow.herokuapp.com";
  // static Future getUsers() {
  //   var url = baseUrl + "/api/users";
  //   //  api/questions{tıtle}
  //   return http.get(url);
  // }

  static Future postUser(String name, String email, String password) {
    var url = baseUrl + "/api/users";
    return http.post(url,
        body: {'name': '$name', 'email': '$email', 'password': '$password'});
  }

  static Future authUser(String email, String password) {
    var url = baseUrl + "/api/auth";
    return http.post(url, body: {'email': '$email', 'password': '$password'});
  }

  static List<User> parseUsers(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  static Future<List<User>> getUsers() async {
    String url = baseUrl + "/api/users";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return parseUsers(response.body);
    } else {
      throw Exception('Unable to fetch users from the REST API');
    }
  }

  List<Question> parseQuestions(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Question>((json) => Question.fromJson(json)).toList();
  }

  Future<List<Question>> getQuestions(String id) async {
    String url = baseUrl + "/api/questions/$id";
    print("question api called");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return parseQuestions(response.body);
    } else {
      throw Exception('Unable to fetch questions from the REST API');
    }
  }

  List<Topic> parseTopics(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Topic>((json) => Topic.fromJson(json)).toList();
  }

  Future<List<Topic>> getTopics() async {
    String url = baseUrl + "/api/topics";
    print("toopic api called");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return parseTopics(response.body);
    } else {
      throw Exception('Unable to fetch questions from the REST API');
    }
  }
}
