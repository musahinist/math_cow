import 'package:flutter/material.dart';

class DiscoveryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [Colors.teal[600], Colors.lime[300]]),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Leadership",
                    // style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                ],
              ),
            ),
            Container(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _buildCircleavatar(),
                      Text(
                        "Musa SAHIN",
                        style: TextStyle(
                            color: Colors.grey[50],
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "PRO",
                        style: TextStyle(
                            color: Colors.grey[100],
                            fontWeight: FontWeight.bold),
                      ),
                      _roundedButton(
                          title: "1000",
                          color: Colors.lime[500],
                          margin: 10,
                          padding: 10),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      _buildCircleavatar(),
                      Text(
                        "Musa SAHIN",
                        style: TextStyle(
                            color: Colors.grey[50],
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "PRO",
                        style: TextStyle(
                            color: Colors.grey[100],
                            fontWeight: FontWeight.bold),
                      ),
                      _roundedButton(
                          title: "1000",
                          color: Colors.lime[500],
                          margin: 10,
                          padding: 10),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _buildCircleavatar(),
                      Text(
                        "Musa SAHIN",
                        style: TextStyle(
                            color: Colors.grey[50],
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "PRO",
                        style: TextStyle(
                            color: Colors.grey[100],
                            fontWeight: FontWeight.bold),
                      ),
                      _roundedButton(
                          title: "1000",
                          color: Colors.lime[500],
                          margin: 10,
                          padding: 10),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemCount: 20,
                    itemBuilder: _buildList,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding _buildCircleavatar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          CircleAvatar(
            foregroundColor: Colors.red,
            radius: 40,
            backgroundColor: Colors.green[100],
            child: FlutterLogo(
              size: 100,
            ),
          ),
          _roundedButton(
              title: "1", color: Colors.teal[500], margin: 8, padding: 5)
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "#$index",
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
          _roundedButton(
              title: "${1000 - index}",
              color: Colors.lime[500],
              margin: 10,
              padding: 10),
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Musa SAHIN",
                    style: TextStyle(
                        color: Colors.grey[900], fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "PRO Istanbul - TR",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.green[100],
                  child: FlutterLogo(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _roundedButton(
      {String title, Color color, double margin = 0, double padding = 0}) {
    return InkWell(
      child: Container(
        height: 20,
        //width: 50,
        padding: EdgeInsets.symmetric(horizontal: padding),
        margin: EdgeInsets.symmetric(horizontal: margin),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: color),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
