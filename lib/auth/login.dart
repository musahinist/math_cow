import 'package:flutter/material.dart';
import 'package:math_cow/utils/fade_animation.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _name;
  String _email;
  String _password;
  bool _validate = false;
  // void _submitCommand() {
  //   final form = formKey.currentState;

  //   if (form.validate()) {
  //     form.save();

  //     // Email & password matched our validation rules
  //     // and are saved to _email and _password fields.
  //     _loginCommand();
  //   }
  // }

  // void _loginCommand() {
  //   // This is just a demo, so no actual login here.
  //   final snackbar = SnackBar(
  //     content: Text('Email: $_email, password: $_password'),
  //   );

  //   scaffoldKey.currentState.showSnackBar(snackbar);
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.teal[300], Colors.pink[300]]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //
              Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Register",
                      style: TextStyle(fontSize: 40),
                    ),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40)),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    autovalidate: _validate,
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, .3),
                                    blurRadius: 15,
                                    offset: Offset(0, 5))
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                ),
                                child: TextFormField(
                                  style: TextStyle(color: Colors.black54),
                                  decoration: InputDecoration(
                                    hintText: "User Name",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  maxLength: 15,
                                  validator: validateName,
                                  onSaved: (String val) {
                                    _name = val;
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(color: Colors.black54),
                                    decoration: InputDecoration(
                                        hintText: "Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                    maxLength: 32,
                                    validator: validateEmail,
                                    onSaved: (String val) {
                                      _email = val;
                                    }),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: TextFormField(
                                  obscureText: true,
                                  style: TextStyle(color: Colors.black54),
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                  validator: validateEmail,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        _withRoundedRectangleBorder()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _withRoundedRectangleBorder() {
    return RaisedButton(
      elevation: 0,
      padding: const EdgeInsets.fromLTRB(
        100,
        15,
        100,
        15,
      ),
      color: Colors.cyan[600],
      child: Text("Register"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      onPressed: _sendToServer,
    );
  }

  Container roundedButton({String title, Color color, double margin = 0}) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: margin),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(50), color: color),
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String validateName(String value) {
    if (value.length < 5)
      return 'Name must be more than 4 charater';
    else
      return null;
  }

  String validateEmail(String value) {
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

  _sendToServer() {
    if (_formKey.currentState.validate()) {
      // No any error in validation
      _formKey.currentState.save();
      print("Name $_name");
      // print("Mobile $mobile");
      print("Email $_email");
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }
}
