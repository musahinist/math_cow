import 'package:flutter/material.dart';
import 'dart:math' as math;

class ScrollAnimation extends StatefulWidget {
  @override
  _ScrollAnimationState createState() => _ScrollAnimationState();
}

class _ScrollAnimationState extends State<ScrollAnimation> {
  ScrollController _controller = new ScrollController();

  List<DemoCard> get _cards =>
      items.map((Item _item) => DemoCard(_item)).toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        // appBar: AppBar(title: Text(widget.title)),
        body:
            Stack(alignment: AlignmentDirectional.topStart, children: <Widget>[
          AnimatedBackground(controller: _controller),
          Center(child: ListView(controller: _controller, children: _cards))
        ]));
  }
}

class Item {
  String name;
  String description;
  MaterialColor color;
  IconData icon;
  Item(this.name, this.description, this.color, this.icon);
}

List<Item> items = [
  Item('A', "Something cool", Colors.amber, Icons.ac_unit),
  Item('B', "Hey, why not?", Colors.cyan, Icons.add_photo_alternate),
  Item('C', "This might be OK", Colors.indigo, Icons.airplay),
  Item('D', "Totally awesome", Colors.green, Icons.crop),
  Item('E', "Rockin out", Colors.pink, Icons.album),
  Item('F', "Take a look", Colors.blue, Icons.adb)
];

class DemoCard extends StatelessWidget {
  DemoCard(this.item);
  final Item item;

  static final Shadow _shadow =
      Shadow(offset: Offset(2.0, 2.0), color: Colors.black26);
  final TextStyle _style = TextStyle(color: Colors.white70, shadows: [_shadow]);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Colors.white),
            borderRadius: BorderRadius.circular(35)),
        color: item.color.withOpacity(.7),
        child: Container(
            constraints: BoxConstraints.expand(height: 256),
            child: RawMaterialButton(
              onPressed: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(item.name, style: _style.copyWith(fontSize: 64)),
                        Icon(item.icon, color: Colors.white70, size: 72),
                      ])
                ],
              ),
            )));
  }
}

class AnimatedBackground extends StatefulWidget {
  AnimatedBackground({Key key, this.controller}) : super(key: key);

  final ScrollController controller;

  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> {
  get offset => widget.controller.hasClients ? widget.controller.offset : 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.controller,
        builder: (BuildContext context, Widget child) {
          return OverflowBox(
              maxWidth: double.infinity,
              alignment: Alignment(4, 3),
              child: Transform.rotate(
                  angle: ((math.pi * offset) / -1024),
                  child: Icon(Icons.settings, size: 512, color: Colors.white)));
        });
  }
}
