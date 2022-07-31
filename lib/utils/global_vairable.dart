import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_clone/screens/add_post_screen.dart';
import 'package:insta_clone/screens/feed_screen.dart';

const webScreenWidth = 600;
const sendIcon = 'assets/images/send.svg';
const commentIcon = 'assets/images/comment.svg';

List<Widget> homeScreenItems = <Widget>[
  FeedScreen(),
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
