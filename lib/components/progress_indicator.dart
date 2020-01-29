import 'package:flutter/material.dart';

class ProgressIndic extends StatelessWidget {
  final int cpercent;
  final int wpercent;
  const ProgressIndic({Key key, this.cpercent = 0, this.wpercent = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              width: 50,
              height: 6,
              margin: EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(40),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                margin: EdgeInsets.only(left: (50.0 - wpercent * 2)),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(5)),
              ),
            ),
            Container(
              width: 50,
              height: 6,
              margin: EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(40),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                margin: EdgeInsets.only(right: (50.0 - cpercent * 2)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ],
        ),
        Icon(
          Icons.visibility,
          size: 13,
          color: Colors.black.withAlpha(80),
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            "$cpercent/25",
            style: TextStyle(
                color: Colors.black.withAlpha(80),
                fontSize: 10,
                fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}
