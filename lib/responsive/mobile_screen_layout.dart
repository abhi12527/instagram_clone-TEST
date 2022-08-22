import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

import '/utils/colors.dart';
import '../models/user.dart';
import '../controller/user_provider.dart';
import '../resources/auth_methods.dart';
import '../view/add_post_screen.dart';
import '../view/feed_screen.dart';
import '../view/notification_screen.dart';
import '../view/profile_screen.dart';
import '../view/search_screen.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout>
    with WidgetsBindingObserver {
  int _page = 0;
  UserModel? user;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AuthMethods().getUserData(context);
    pageController = PageController();
    FirestoreMethods().updateStatus('Online');
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FirestoreMethods().updateStatus('Online');
    } else {
      FirestoreMethods().updateStatus('Offline');
    }
    super.didChangeAppLifecycleState(state);
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
      AddPostScreen(navigate: navigationTapped),
      const ActivityScreen(),
      ProfileScreen('Current'),
    ];
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        onTap: navigationTapped,
        items: [
          BottomNavigationBarItem(
            icon: _page == 0
                ? Image.asset(
                    'assets/images/home_filled.png',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    height: 20,
                  )
                : Image.asset(
                    'assets/images/home_unfilled.png',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    height: 20,
                  ),
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: _page == 1
                ? Image.asset(
                    'assets/images/search_bold.png',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    height: 20,
                  )
                : Image.asset(
                    'assets/images/search_light.png',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    height: 20,
                  ),
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: _page == 2
                ? Image.asset(
                    'assets/images/add_bold.png',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    height: 20,
                  )
                : Image.asset(
                    'assets/images/add_light.png',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    height: 20,
                  ),
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: _page == 3
                ? Image.asset(
                    'assets/images/heart_filled.png',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    height: 20,
                  )
                : Image.asset(
                    'assets/images/heart_outlined.png',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
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
    );
  }
}
