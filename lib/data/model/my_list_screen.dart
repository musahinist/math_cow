import 'package:flutter/material.dart';
import 'package:math_cow/data/model/question.dart';
import 'package:math_cow/data/provider/user_api.dart';

import 'package:math_cow/data/model/user.dart';

class MyListScreen extends StatefulWidget {
  @override
  createState() => _MyListScreenState();
}

class _MyListScreenState extends State {
  List<User> users;
  Future<List<Question>> questions;
  API api = API();
  // _getUsers() {
  //   API.getUsers().then((response) {
  //     setState(() {
  //       usrs = response;
  //       // Iterable list = json.decode(response.body);
  //       // users = list.map((model) => User.fromJson(model)).toList();
  //       // user = json.decode(response.body);
  //     });
  //   });
  // }

  // _postUser() {
  //   API.postUser('musaa', 'musa@gmail.com', '12345').then((response) {
  //     setState(() {
  //       user = json.decode(response.body);
  //     });
  //   });
  // }

  // _authUser() async {
  //   await API.authUser('musa@gmail.com', '12345').then((response) {
  //     setState(() {
  //       user = json.decode(response.body);
  //       print(user['token']);
  //     });
  //   });
  // }
  void setUser() async {
    users = await API.getUsers();
  }

  @override
  void initState() {
    setUser();
    super.initState();

    // questions = api.getQuestions();
  }
  // initState() {
  //   super.initState();
  //   usrs = API.getUsers();
  // }

//  @override
//  build(context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("User List"),
//      ),
//      body: Text(user['x-auth-token']),
//    );
//  }

  @override
  build(context) {
    return Scaffold(
        // body: FutureBuilder<List<Question>>(
        //   future: questions,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       return GamePage(
        //         snapshot.data,
        //         id: 101,
        //       );
        //     } else if (snapshot.hasError) {
        //       return Text("${snapshot.error}");
        //     }

        //     // By default, show a loading spinner.
        //     return Center(child: CircularProgressIndicator());
        //   },
        // ),
        );
  }
}
