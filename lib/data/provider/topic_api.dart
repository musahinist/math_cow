import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:math_cow/data/model/topic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopicApi {
  static const baseUrl = "http://mathcow.herokuapp.com";

  // Future<List<Topic>> getTopics() async {
  //   String url = baseUrl + "/api/topics";
  //   print("toopic api called");
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     return parseTopics(response.body);
  //   } else {
  //     throw Exception('Unable to fetch questions from the topic REST API');
  //   }
  // }
  Future<String> getTopics() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    // print(value);

    String url = baseUrl + "/api/topics";
    //  print("toopic api called");
    final response = await http.get(
      url,
      headers: {'x-auth-token': '$value'},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Unable to fetch questions from the topic REST API');
    }
  }

  List<Topic> parseTopics(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Topic>((json) => Topic.fromJson(json)).toList();
  }
}
