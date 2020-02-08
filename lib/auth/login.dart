import 'package:flutter/material.dart';
import 'package:math_cow/data/services/user_service.dart';
import 'package:math_cow/main.dart';
import 'package:math_cow/utils/fade_animation.dart';
import 'package:math_cow/utils/loading_anim.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String _name;
  String _email;
  String _password;
  bool _register = true;
  bool _validate = false;
  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    return Injector(
        inject: [Inject<UserService>(() => UserService())],
        initState: () {
          final ReactiveModel<UserService> userService =
              Injector.getAsReactive<UserService>();
          userService.setState((state) => state.getToken());
        },
        builder: (context) {
          // final ReactiveModel<UserService> userService =
          //     Injector.getAsReactive<UserService>(context: context);
          return Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.teal[300], Colors.pink[300]]),
                ),
                child: StateBuilder<UserService>(
                    models: [Injector.getAsReactive<UserService>()],
                    builder: (context, userService) {
                      return userService.whenConnectionState(
                          onIdle: () => Center(child: Loading()),
                          onWaiting: () => Center(child: Loading()),
                          onError: (_) => Text("error"),
                          onData: (snapshot) {
                            return snapshot.token != ""
                                ? App()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      //
                                      FadeAnimation(
                                        1,
                                        Padding(
                                          padding: const EdgeInsets.all(40),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                _register
                                                    ? "Register"
                                                    : "LogIn",
                                                style: TextStyle(fontSize: 40),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.65,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: Padding(
                                          padding: EdgeInsets.all(20),
                                          child: FadeAnimation(
                                            1,
                                            Form(
                                              autovalidate: _validate,
                                              key: _formKey,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      225,
                                                                      95,
                                                                      27,
                                                                      .3),
                                                              blurRadius: 15,
                                                              offset:
                                                                  Offset(0, 5))
                                                        ]),
                                                    child: Column(
                                                      children: <Widget>[
                                                        _register
                                                            ? Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border:
                                                                      Border(
                                                                    bottom:
                                                                        BorderSide(
                                                                      color: Colors
                                                                              .grey[
                                                                          200],
                                                                    ),
                                                                  ),
                                                                ),
                                                                child:
                                                                    TextFormField(
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black54),
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        "User Name",
                                                                    hintStyle: TextStyle(
                                                                        color: Colors
                                                                            .grey),
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                  ),
                                                                  //s  maxLength: 15,
                                                                  validator:
                                                                      _validateName,
                                                                  onSaved:
                                                                      (String
                                                                          val) {
                                                                    _name = val;
                                                                  },
                                                                ),
                                                              )
                                                            : Container(),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          decoration: BoxDecoration(
                                                              border: Border(
                                                                  bottom: BorderSide(
                                                                      color: Colors
                                                                              .grey[
                                                                          200]))),
                                                          child: TextFormField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .emailAddress,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54),
                                                              decoration: InputDecoration(
                                                                  hintText:
                                                                      "Email",
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                  border:
                                                                      InputBorder
                                                                          .none),
                                                              // maxLength: 32,
                                                              validator:
                                                                  _validateEmail,
                                                              onSaved:
                                                                  (String val) {
                                                                _email = val;
                                                              }),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          decoration: BoxDecoration(
                                                              border: Border(
                                                                  bottom: BorderSide(
                                                                      color: Colors
                                                                              .grey[
                                                                          200]))),
                                                          child: TextFormField(
                                                            obscureText: true,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54),
                                                            decoration: InputDecoration(
                                                                hintText:
                                                                    "Password",
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                                border:
                                                                    InputBorder
                                                                        .none),
                                                            validator:
                                                                _validateName,
                                                            onSaved:
                                                                (String val) {
                                                              _password = val;
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  OutlineButton(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.grey[300]),
                                                    onPressed: () => userService
                                                        .setState((state) =>
                                                            setState(() {
                                                              _register =
                                                                  !_register;
                                                            })),
                                                    child: Text(
                                                      _register
                                                          ? "I have already account"
                                                          : "Create a new account",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                  RaisedButton(
                                                    elevation: 0,
                                                    color: Colors.cyan[600],
                                                    child: Container(
                                                        width: 250,
                                                        height: 50,
                                                        child: Center(
                                                            child: Text(_register
                                                                ? "Register"
                                                                : "LogIn"))),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    onPressed: () => userService
                                                        .setState(
                                                            (state) async {
                                                      if (_formKey.currentState
                                                          .validate()) {
                                                        // No any error in validation
                                                        _formKey.currentState
                                                            .save();
                                                        await state
                                                            .registerUser(
                                                                _name,
                                                                _email,
                                                                _password);
                                                        _scaffoldKey
                                                            .currentState
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              "Acount Created"),
                                                        ));
                                                        await state.getToken();
                                                        Navigator.of(context)
                                                            .pushReplacementNamed(
                                                                '/app');
                                                      } else {
                                                        // validation error
                                                        setState(() {
                                                          _validate = true;
                                                        });
                                                      }
                                                    }),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                          });
                    }),
              ),
            ),
          );
        });
  }

  Container roundedButton({String title, Color color, double margin = 0}) {
    return Container(
      height: 60,
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

  String _validateName(String value) {
    if (value.length < 5)
      return ' must be more than 4 charater';
    else if (value.length > 15) {
      return ' must be less than 16 charater';
    }
    return null;
  }

  String _validateEmail(String value) {
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
}
