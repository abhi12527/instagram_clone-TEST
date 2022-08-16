import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/screens/inbox_screen.dart';

import '../utils/colors.dart';
import '../utils/global_vairable.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: SvgPicture.asset(
            'assets/images/ic_instagram.svg',
            color: Theme.of(context).brightness == Brightness.dark
                ? primaryColor
                : Colors.black,
            height: 32,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InboxScreen()));
              },
              child: SvgPicture.asset(
                sendIcon,
                color: Theme.of(context).brightness == Brightness.dark
                    ? primaryColor
                    : Colors.black,
                height: 20,
              ),
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return circularIndicator(context);
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return PostCard(post: snapshot.data!.docs[index]);
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went Wrong!'));
          } else {
            return const Center(
              child: Text(
                  'You have no Feed to Show Start following people to get feed from peoples'),
            );
          }
        },
      ),
    );
  }
}
