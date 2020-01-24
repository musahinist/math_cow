import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:math_cow/data/model/user.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  String baseUrl = "http://mathcow.herokuapp.com";
  String _token;

  ////// REGISTER
  Future registerUser(String name, String email, String password) async {
    final response = await http.post(
      baseUrl + "/api/users",
      body: {"name": "$name", "email": "$email", "password": "$password"},
      headers: {'x-auth-token': 'application/json'},
    );
    var status = response.body.contains('error');
    var data = json.decode(response.body);
    _token = response.headers['x-auth-token'];
    if (status) {
      print('data : ${data["error"]}');
      print('error error errr');
    } else {
      await save(_token);
      return _token;
    }
  }

//////// LOGIN
  Future logInUser(String email, String password) async {
    final response = await http.post(
      baseUrl + "/api/auth",
      body: {'email': '$email', 'password': '$password'},
      headers: {'x-auth-token': 'application/json'},
    );
    var status = response.body.contains('error');
    var data = json.decode(response.body);
    _token = response.headers['x-auth-token'];
    if (status) {
      print('data : ${data["error"]}');
      print('error error errr');
    } else {
      await save(_token);
    }
  }

  /// GET my info ofr Currenrt User

  Future<String> getMe() async {
    _token = await read();
    final response = await http.get(
      baseUrl + "/api/users/me",
      headers: {'x-auth-token': '$_token'},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Unable to fetch users from the user API');
    }
  }

  User parseMe(String responseBody) {
    print(responseBody);
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return User.fromJson(parsed);
  }

  /// Add info to Current User
  Future addUserData(body) async {
    var token = await read();

    final response = await http.post(baseUrl + "/api/cardends",
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "x-auth-token": "$token"
        },
        body: body);
    //  print(response.statusCode);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Unable to fetch users from the user API');
    }
  }

/////// GET ALL USERS INFO
  Future<List<User>> getUsers() async {
    _token = await read();
    final response = await http.get(
      baseUrl + "/api/users",
      headers: {'x-auth-token': '$_token'},
    );

    if (response.statusCode == 200) {
      return _parseUsers(response.body);
    } else {
      throw Exception('Unable to fetch users from the user API');
    }
  }

  List<User> _parseUsers(String responseBody) {
    //print(responseBody); ///////////////////////////////
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  /// Save to Shared
  save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

  /// Read from Shared
  Future<String> read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    return value;
  }

  // Future postUser(String name, String email, String password) {
  //   var url = baseUrl + "/api/users";
  //   return http.post(url,
  //       body: {'name': '$name', 'email': '$email', 'password': '$password'});
  // }

  // /////////////////////////////////////////////////////////

  // loginUser(String name, String email, String password) async {
  //   String myUrl = "$baseUrl/api/users";
  //   final response = await http.post(myUrl,
  //       headers: {HttpHeaders.authorizationHeader: "Basic token"},
  //       // headers: {'x-auth-token': 'application/json'},
  //       body: {"name": "$name", "email": "$email", "password": "$password"});
  //   var status = response.body.contains('error');

  //   print(status);
  //   //var data = json.decode(response.body);
  //   var data = json.decode(response.headers.toString());
  //   print(data);

  //   if (status) {
  //     print('data : ${data["error"]}');
  //     print('error error errr');
  //   } else {
  //     print(data);
  //     // _save(token);
  //   }
  // }

  // Future<List> getData() async {
  //   _token = await read();

  //   String myUrl = "$baseUrl/products/";
  //   http.Response response = await http.get(myUrl, headers: {
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $_token'
  //   });
  //   return json.decode(response.body);
  // }

  // void deleteData(int id) async {
  //   _token = await read();

  //   String myUrl = "$baseUrl/products/$id";
  //   http.delete(myUrl, headers: {
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $_token'
  //   }).then((response) {
  //     print('Response status : ${response.statusCode}');
  //     print('Response body : ${response.body}');
  //   });
  // }

  // void addData(String name, String price) async {
  //   _token = await read();
  //   String myUrl = "$baseUrl/products";
  //   http.post(myUrl, headers: {
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $_token'
  //   }, body: {
  //     "name": "$name",
  //     "price": "$price"
  //   }).then((response) {
  //     print('Response status : ${response.statusCode}');
  //     print('Response body : ${response.body}');
  //   });
  // }

  // void editData(int id, String name, String price) async {
  //   _token = await read();

  //   //String myUrl = "http://flutterapitutorial.codeforiraq.org/api/products/$id";
  //   http.put(baseUrl, headers: {
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $_token'
  //   }, body: {
  //     "name": "$name",
  //     "price": "$price"
  //   }).then((response) {
  //     print('Response status : ${response.statusCode}');
  //     print('Response body : ${response.body}');
  //   });
  // }
}
