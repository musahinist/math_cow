import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:math_cow/data/model/question.dart';
import 'package:math_cow/data/model/topic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionApi {
  static const baseUrl = "http://mathcow.herokuapp.com";

  List<Question> parseQuestions(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Question>((json) => Question.fromJson(json)).toList();
  }

  Future<List<Question>> getQuestions(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String url = baseUrl + "/api/questions/$id";
    // print("question api called");
    final response = await http.get(
      url,
      headers: {'x-auth-token': '$value'},
    );
    if (response.statusCode == 200) {
      return parseQuestions(response.body);
    } else {
      throw Exception('Unable to fetch questions from the REST API');
    }
  }

  //////////////////////////////////////////

  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
    // print("$key : $value");
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    //  print('read : $value');
  }

  // Future<List> getData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final key = 'token';
  //   final value = prefs.get(key) ?? 0;

  //   String myUrl = "$baseUrl/products/";
  //   http.Response response = await http.get(myUrl, headers: {
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $value'
  //   });
  //   return json.decode(response.body);
  // }

  // void deleteData(int id) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final key = 'token';
  //   final value = prefs.get(key) ?? 0;

  //   String myUrl = "$baseUrl/products/$id";
  //   http.delete(myUrl, headers: {
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $value'
  //   }).then((response) {
  //     print('Response status : ${response.statusCode}');
  //     print('Response body : ${response.body}');
  //   });
  // }

  // void addData(String name, String price) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final key = 'token';
  //   final value = prefs.get(key) ?? 0;

  //   String myUrl = "$baseUrl/products";
  //   http.post(myUrl, headers: {
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $value'
  //   }, body: {
  //     "name": "$name",
  //     "price": "$price"
  //   }).then((response) {
  //     print('Response status : ${response.statusCode}');
  //     print('Response body : ${response.body}');
  //   });
  // }

  // void editData(int id, String name, String price) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final key = 'token';
  //   final value = prefs.get(key) ?? 0;

  //   //String myUrl = "http://flutterapitutorial.codeforiraq.org/api/products/$id";
  //   http.put(baseUrl, headers: {
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $value'
  //   }, body: {
  //     "name": "$name",
  //     "price": "$price"
  //   }).then((response) {
  //     print('Response status : ${response.statusCode}');
  //     print('Response body : ${response.body}');
  //   });
  // }

}
