// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import '/utils/colors.dart';
import '/widgets/post_card.dart';

class PostDetailScreen extends StatelessWidget {
  final post;
  const PostDetailScreen({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Photo'),
      ),
      body: ListView(children: [PostCard(post: post)]),
    );
  }
}
