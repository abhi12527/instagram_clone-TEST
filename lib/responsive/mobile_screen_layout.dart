import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/utils/colors.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';
import '../resources/auth_methods.dart';
import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  UserModel? user;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    AuthMethods().getUserData(context);
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;

    List<Widget> homeScreenItems = <Widget>[
      const FeedScreen(),
      const SearchScreen(),
      const AddPostScreen(),
      const ActivityScreen(),
      ProfileScreen('Current'),
    ];
    return SafeArea(
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChanged,
          children: homeScreenItems,
        ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          onTap: navigationTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _page == 0 ? Icons.home : Icons.home_outlined,
                color: _page == 0 ? primaryColor : secondaryColor,
              ),
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search_rounded,
                color: _page == 1 ? primaryColor : secondaryColor,
              ),
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box_outlined,
                color: _page == 2 ? primaryColor : secondaryColor,
              ),
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _page == 3 ? Icons.favorite : Icons.favorite_border,
                color: _page == 3 ? primaryColor : secondaryColor,
              ),
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              // icon: Icon(
              //   Icons.person,
              //   color: _page == 4 ? primaryColor : secondaryColor,
              // ),
              icon: CircleAvatar(
                radius: 13,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(user!.photoUrl),
              ),
              backgroundColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
