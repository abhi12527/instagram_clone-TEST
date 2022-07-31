import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:insta_clone/utils/colors.dart';

class CommentsSceeen extends StatefulWidget {
  const CommentsSceeen({Key? key}) : super(key: key);

  @override
  State<CommentsSceeen> createState() => _CommentsSceeenState();
}

class _CommentsSceeenState extends State<CommentsSceeen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('Comments'),
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        padding: EdgeInsets.only(
          left: 16,
          right: 8,
        ),
      )),
    );
  }
}
