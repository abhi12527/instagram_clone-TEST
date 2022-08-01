import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../utils/global_vairable.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider userProvider = Provider.of(context, listen: false)
      ..refreshUser();
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser!.uid);

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreenWidth) {
        return widget.webScreenLayout;
      }
      return widget.mobileScreenLayout;
    });
  }
}
