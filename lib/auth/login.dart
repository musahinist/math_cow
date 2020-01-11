import 'package:flutter/material.dart';
import 'package:math_cow/utils/fade_animation.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;
  String _password;

  void _submitCommand() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      _loginCommand();
    }
  }

  void _loginCommand() {
    // This is just a demo, so no actual login here.
    final snackbar = SnackBar(
      content: Text('Email: $_email, password: $_password'),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [Colors.purpleAccent, Colors.teal[300]]),
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
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40)),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Form(
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
                                            color: Colors.grey[200]))),
                                child: TextFormField(
                                  autofocus: true,
                                  style: TextStyle(color: Colors.black54),
                                  decoration: InputDecoration(
                                      hintText: "User Name",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: TextFormField(
                                  autofocus: true,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(color: Colors.black54),
                                  decoration: InputDecoration(
                                      hintText: "Email",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: TextFormField(
                                  autofocus: true,
                                  obscureText: true,
                                  style: TextStyle(color: Colors.black54),
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
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
      color: Colors.teal,
      child: Text("Register"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      onPressed: () {},
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
}
