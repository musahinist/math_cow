import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final Function setIndex;
  BottomNavBar({this.setIndex});

  final List<TabItem> items = <TabItem>[
    //3 or 5
    TabItem(icon: Icons.games, title: 'Games'),
    TabItem(icon: Icons.whatshot, title: 'Motivation'),
    TabItem(icon: Icons.face, title: 'Profile')
  ];

  @override
  Widget build(BuildContext context) {
    //https://pub.dev/packages/convex_bottom_ban
    return ConvexAppBar(
      onTap: (i) => setIndex(i),
      backgroundColor: Colors.cyan,
      color: Colors.grey[800],
      // activeColor: Colors.amber[800],
      curve: Curves.decelerate,
      style: TabStyle.react,
      items: items,
      curveSize: 45,
      top: -13,
    );
  }
}
