import 'package:flutter/material.dart';
import 'package:math_cow/utils/fade_animation.dart';

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [Colors.orange[900], Colors.orange[400]]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                    1,
                    Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // FadeAnimation(
                  //     1.3,
                  //     Text(
                  //       "sdfsdfsdfsdf",
                  //       style: TextStyle(color: Colors.white, fontSize: 18),
                  //     )),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                            1.4,
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromRGBO(225, 95, 27, .3),
                                        blurRadius: 20,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: "Email or Phone number",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: "Password",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                            1.5,
                            Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.grey),
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                          1.6,
                          roundedButton(
                              title: 'Login',
                              color: Colors.orange[900],
                              margin: 50),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        FadeAnimation(
                            1.7,
                            Text(
                              "Continue with social media",
                              style: TextStyle(color: Colors.grey),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FadeAnimation(
                                1.8,
                                roundedButton(
                                  title: 'Google',
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: FadeAnimation(
                                1.9,
                                roundedButton(
                                  title: 'Instagram',
                                  color: Colors.deepPurple,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
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
