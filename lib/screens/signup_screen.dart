import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/utils/colors.dart';
import '/widgets/text_field_input.dart';

import '../utils/dimensions.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
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
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/user_default.jpg'),
                ),
                Positioned(
                  bottom: -10,
                  right: -10,
                  child: IconButton(
                    onPressed: () {},
                    splashRadius: 25,
                    icon: Icon(
                      Icons.add_a_photo_rounded,
                    ),
                  ),
                ),
              ],
            ),
            blankSpace(24),
            TextFieldInput(
              controller: _usernameController,
              hintText: 'Enter Userneame',
              textInputType: TextInputType.emailAddress,
            ),
            blankSpace(24),
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
            TextFieldInput(
              controller: _bioController,
              hintText: 'Enter your Bio',
              textInputType: TextInputType.emailAddress,
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
                child: const Text('Sign Up'),
              ),
            ),
            blankSpace(12),
            blankFlex(2),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text('Alreaddy have an account?'),
                ),
              )
            ]),
          ],
        ),
      )),
    );
  }
}
