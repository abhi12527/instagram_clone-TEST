import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/global_vairable.dart';
import 'package:insta_clone/widgets/post_card.dart';

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
        backgroundColor: mobileBackgroundColor,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: SvgPicture.asset(
            'assets/images/ic_instagram.svg',
            color: Colors.white,
            height: 32,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: InkWell(
              onTap: () {},
              child: SvgPicture.asset(
                sendIcon,
                color: Colors.white,
                height: 20,
              ),
            ),
          )
        ],
      ),
      body: PostCard(),
    );
  }
}
