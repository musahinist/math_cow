import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:math_cow/data/provider/databasehelper.dart';

class MyListScreen extends StatefulWidget {
  @override
  createState() => _MyListScreenState();
}

class _MyListScreenState extends State {
  var users;
  DatabaseHelper databaseHelper = DatabaseHelper();
  _getUsers() {
    users = databaseHelper.loginData('oguzcc22', 'oguzcc73@gmail.com', '12345');
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
