import 'package:flutter/material.dart';
import 'package:insta_clone/screens/add_post_screen.dart';

const webScreenWidth = 600;

List<Widget> homeScreenItems = <Widget>[
  Text('feed'),
  Text('search'),
  AddPostScreen(),
  Text('notif'),
  Text('account'),
];

blankSpace([double height = 0, double width = 0]) => SizedBox(
      height: height,
      width: width,
    );

blankFlex([flex = 1]) => Flexible(
      flex: 2,
      child: Container(),
    );
