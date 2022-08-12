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
              icon: _page == 0
                  ? Image.asset(
                      'assets/images/home_filled.png',
                      color: primaryColor,
                      height: 20,
                    )
                  : Image.asset(
                      'assets/images/home_unfilled.png',
                      color: primaryColor,
                      height: 20,
                    ),
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: _page == 1
                  ? Image.asset(
                      'assets/images/search_bold.png',
                      color: primaryColor,
                      height: 20,
                    )
                  : Image.asset(
                      'assets/images/search_light.png',
                      color: primaryColor,
                      height: 20,
                    ),
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: _page == 2
                  ? Image.asset(
                      'assets/images/add_bold.png',
                      color: primaryColor,
                      height: 20,
                    )
                  : Image.asset(
                      'assets/images/add_light.png',
                      color: primaryColor,
                      height: 20,
                    ),
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: _page == 3
                  ? Image.asset(
                      'assets/images/heart_filled.png',
                      color: primaryColor,
                      height: 20,
                    )
                  : Image.asset(
                      'assets/images/heart_outlined.png',
                      color: primaryColor,
                      height: 20,
                    ),
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: CircleAvatar(
                radius: 13,
                backgroundColor: Colors.grey,
                backgroundImage: user!.photoUrl != null
                    ? NetworkImage(user!.photoUrl, scale: 1)
                    : null,
              ),
              backgroundColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
