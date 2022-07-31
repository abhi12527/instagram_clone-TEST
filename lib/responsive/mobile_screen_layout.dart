import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/user.dart';
import 'package:insta_clone/provider/user_provider.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
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
    UserModel user = Provider.of<UserProvider>(context).user;
    return SafeArea(
      child: Scaffold(
        body: PageView(
          children: [
            Text('feed'),
            Text('search'),
            Text('add'),
            Text('notif'),
            Text('account'),
          ],
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChanged,
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
             _page == 3 ?   Icons.favorite:Icons.favorite_border,
                color: _page == 3 ? primaryColor : secondaryColor,
              ),
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _page == 4 ? primaryColor : secondaryColor,
              ),
              backgroundColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
