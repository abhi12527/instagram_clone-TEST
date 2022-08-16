// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/screens/forgot_screen.dart';

import '../resources/firestore_methods.dart';
import '/resources/auth_methods.dart';
import '/screens/signup_screen.dart';
import '/utils/colors.dart';
import '/widgets/text_field_input.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/global_vairable.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  login() async {
    setState(() {
      _isLoading = true;
    });
    List<String> res = await AuthMethods().loginUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    setState(() {
      _isLoading = false;
    });
    if (res[0] != 'success') {
      showDialoguePop(context, res[0], res[1], 85);
    } else {
      FirestoreMethods().updateStatus('Online');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    }
  }

  void navigateToSignUp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  void navigateToForgotPassword() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ForgotScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            blankFlex(1),
            SvgPicture.asset(
              'assets/images/ic_instagram.svg',
              color: Theme.of(context).brightness == Brightness.dark
                  ? primaryColor
                  : Colors.black,
              height: 64,
            ),
            blankSpace(64),
            TextFieldInput(
              controller: _emailController,
              hintText: 'Enter Email',
              textInputType: TextInputType.emailAddress,
            ),
            blankSpace(24),
            TextFieldInput(
              controller: _passwordController,
              hintText: 'Enter Password',
              obscureText: true,
              textInputType: TextInputType.text,
            ),
            blankSpace(24),
            InkWell(
              onTap: _isLoading ? () {} : login,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  color: blueColor,
                ),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            GestureDetector(
              onTap: navigateToForgotPassword,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Forgot your login details? ',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade500
                            : Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Get help logging in.',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            blankSpace(12),
            blankFlex(2),
            const Divider(),
            GestureDetector(
              onTap: navigateToSignUp,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                ),
                const Text(
                  'Sign up.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
            ),
          ],
        ),
      )),
    );
  }
}
