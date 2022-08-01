import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/follow_button.dart';
import 'package:readmore/readmore.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  bool _isloading = true;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = snap.data()!;

      setState(() {
        _isloading = false;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: _isloading ? Text('username') : Text(userData['username']),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      backgroundImage: _isloading
                          ? null
                          : NetworkImage(userData['photoUrl']),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStateColumn(20, "Posts"),
                              buildStateColumn(20, "Followers"),
                              buildStateColumn(20, "Following"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    _isloading ? 'username' : userData['username'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 1),
                  child: ReadMoreText(
                    _isloading ? 'bio' : userData['bio'],
                    trimCollapsedText: ' show more',
                    trimExpandedText: ' show less',
                    trimLines: 3,
                    trimMode: TrimMode.Line,
                    lessStyle:
                        const TextStyle(color: secondaryColor, fontSize: 12),
                    moreStyle:
                        const TextStyle(color: secondaryColor, fontSize: 12),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: FollowButton(
                        label: 'Edit Profile',
                        backgroundColor: Colors.grey.shade900,
                        borderColor: Colors.grey.shade900,
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }

  buildStateColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
