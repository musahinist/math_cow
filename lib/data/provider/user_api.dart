import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:math_cow/data/model/user.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  String baseUrl = "http://mathcow.herokuapp.com";

  Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print(value);
    String url = baseUrl + "/api/users";
    final response = await http.get(
      url,
      headers: {'x-auth-token': '$value'},
      //headers: {'Accept': 'application/json', 'Authorization': 'Bearer $value'},
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return parseUsers(response.body);
    } else {
      throw Exception('Unable to fetch users from the REST API');
    }
  }

  List<User> parseUsers(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  Future postUser(String name, String email, String password) {
    var url = baseUrl + "/api/users";
    return http.post(url,
        body: {'name': '$name', 'email': '$email', 'password': '$password'});
  }

  Future authUser(String email, String password) {
    var url = baseUrl + "/api/auth";
    return http.post(url, body: {'email': '$email', 'password': '$password'});
  }

  ///////////////////////////////////////////////////////////

  registerUser(String name, String email, String password) async {
    String myUrl = "$baseUrl/api/users";
    print(myUrl);
    final response = await http.post(
      myUrl,
      //  headers: {'Accept': 'application/json'},
      body: {"name": "$name", "email": "$email", "password": "$password"},
      //headers: {HttpHeaders.contentTypeHeader: "text/html"},
      headers: {'x-auth-token': 'application/json'},
    );
    var status = response.body.contains('error');
    var token = response.headers['x-auth-token'];
    print("body");
    var data = json.decode(response.body);
    print(data);

    await _save(token);
    await read();
  }

  loginUser(String name, String email, String password) async {
    String myUrl = "$baseUrl/api/users";
    final response = await http.post(myUrl,
        headers: {HttpHeaders.authorizationHeader: "Basic token"},
        // headers: {'x-auth-token': 'application/json'},
        body: {"name": "$name", "email": "$email", "password": "$password"});
    var status = response.body.contains('error');

    print(status);
    //var data = json.decode(response.body);
    var data = json.decode(response.headers.toString());
    print(data);

    if (status) {
      print('data : ${data["error"]}');
      print('error error errr');
    } else {
      print(data);
      // _save(token);
    }
  }

  Future<List> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$baseUrl/products/";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    return json.decode(response.body);
  }

  void deleteData(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$baseUrl/products/$id";
    http.delete(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  void addData(String name, String price) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$baseUrl/products";
    http.post(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "name": "$name",
      "price": "$price"
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  void editData(int id, String name, String price) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    //String myUrl = "http://flutterapitutorial.codeforiraq.org/api/products/$id";
    http.put(baseUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "name": "$name",
      "price": "$price"
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
    print("$key : $value");
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read : $value');
  }

  // static Future getUsers() {
  //   var url = baseUrl + "/api/users";
  //   //  api/questions{tÄ±tle}
  //   return http.get(url);
  // }

}
