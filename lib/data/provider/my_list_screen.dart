import 'package:flutter/material.dart';

import 'package:math_cow/data/provider/user_api.dart';

class MyListScreen extends StatefulWidget {
  @override
  createState() => _MyListScreenState();
}

class _MyListScreenState extends State {
  var users;
  UserApi databaseHelper = UserApi();
  _getUsers() {
    users = databaseHelper.loginUser('oguzcc22', 'oguzcc73@gmail.com', '12345');
  }

  initState() {
    super.initState();
    _getUsers();
  }

  dispose() {
    super.dispose();
  }

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User List"),
      ),
      body: Text('sample text'),
    );
  }
}
