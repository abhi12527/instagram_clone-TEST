import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/search_screen.dart';
import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';

const webScreenWidth = 600;
const sendIcon = 'assets/images/send.svg';
const commentIcon = 'assets/images/comment.svg';

List<Widget> homeScreenItems = <Widget>[
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notif'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid.toString(),
  ),
];

blankSpace([double height = 0, double width = 0]) => SizedBox(
      height: height,
      width: width,
    );

blankFlex([flex = 1]) => Flexible(
      flex: 2,
      child: Container(),
    );
