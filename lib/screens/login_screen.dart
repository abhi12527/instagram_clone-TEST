import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/utils/colors.dart';
import '/widgets/text_field_input.dart';

import '../utils/dimensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
              color: primaryColor,
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
                child: const Text('Login'),
              ),
            ),
            blankSpace(12),
            blankFlex(2),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text('Don\'t have an account?'),
                ),
              )
            ]),
          ],
        ),
      )),
    );
  }
}
