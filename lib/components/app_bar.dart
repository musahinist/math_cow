import 'package:flutter/material.dart';

class TransAppBar extends StatelessWidget {
  final IconData licon, ricon;
  final String ltext, rtext, ctext;
  const TransAppBar(
      {Key key, this.licon, this.ltext, this.ctext, this.rtext, this.ricon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 5,
        left: 0,
        right: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(licon ?? Icons.arrow_back),
                    onPressed: () {},
                  ),
                  Text(
                    ltext ?? "",
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(ctext ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(rtext ?? ""),
                  IconButton(
                    icon: Icon(ricon ?? Icons.timelapse),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
