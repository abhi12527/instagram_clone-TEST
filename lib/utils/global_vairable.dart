import 'package:flutter/material.dart';
import 'colors.dart';

const webScreenWidth = 600;
const sendIcon = 'assets/images/send.svg';
const commentIcon = 'assets/images/comment.svg';

blankSpace([double height = 0, double width = 0]) => SizedBox(
      height: height,
      width: width,
    );

blankFlex([flex = 1]) => Flexible(
      flex: 2,
      child: Container(),
    );

circularIndicator() => const Center(
      child: CircularProgressIndicator(
        color: primaryColor,
      ),
    );

showDialoguePop(
  BuildContext context,
  String message,
  String description, [
  double height = 50,
  double width = 50,
  String action = 'Try Again',
]) =>
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.end,
          actionsPadding: EdgeInsets.zero,
          buttonPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          actions: [
            Row(
              children: [
                Expanded(
                    child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(primary: Colors.grey),
                  child: Text(
                    action,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                )),
              ],
            )
          ],
          title: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Container(
            height: height,
            width: width,
            child: Column(
              children: [
                Text(
                  textAlign: TextAlign.center,
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
