import 'package:flutter/cupertino.dart';
import 'package:insta_clone/models/user.dart';
import 'package:insta_clone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthMethods _authMethods = AuthMethods();
  UserModel get user => _user!;

  refreshUser() async {
    UserModel userModel = await _authMethods.getUserDetails();
    print(userModel);
    _user = userModel;
    notifyListeners();
  }
}
