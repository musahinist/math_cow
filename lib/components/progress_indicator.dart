import 'package:flutter/material.dart';

class ProgressIndic extends StatelessWidget {
  final int percent;
  const ProgressIndic({Key key, this.percent = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 50,
          height: 7,
          margin: EdgeInsets.only(right: 10.0),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(80),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(
            margin: EdgeInsets.only(right: (50.0 - percent * 5)),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
          ),
        ),
        Icon(
          Icons.visibility,
          size: 13,
          color: Colors.black.withAlpha(80),
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            "$percent/10",
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
