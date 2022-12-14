// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/view/message_screen.dart';
import 'package:readmore/readmore.dart';

import '/resources/auth_methods.dart';
import '/resources/firestore_methods.dart';
import '/view/login_screen.dart';
import '/view/post_detail_screen.dart';
import '/utils/colors.dart';
import '/utils/utils.dart';
import '/widgets/follow_button.dart';
import '../utils/global_vairable.dart';

class ProfileScreen extends StatefulWidget {
  String uid;
  ProfileScreen(this.uid, {Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool _isloading = false;
  @override
  void initState() {
    if (widget.uid == 'Current') {
      widget.uid = FirebaseAuth.instance.currentUser!.uid.toString();
    }
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _isloading = true;
    });
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postLen = postSnap.docs.length;
      userData = snap.data()!;
      followers = snap.data()!['follower'].length;
      following = snap.data()!['following'].length;
      isFollowing = snap
          .data()!['follower']
          .contains(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      _isloading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.uid = '';
  }

  @override
  Widget build(BuildContext context) {
    return _isloading
        ? circularIndicator(context)
        : Scaffold(
            appBar: AppBar(
              title: Text(
                userData['username'],
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
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
                            backgroundImage: NetworkImage(userData['photoUrl']),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStateColumn(postLen, "Posts"),
                                    buildStateColumn(followers, "Followers"),
                                    buildStateColumn(following, "Following"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(top: 1),
                        child: ReadMoreText(
                          userData['bio'],
                          trimCollapsedText: ' show more',
                          trimExpandedText: ' show less',
                          trimLines: 3,
                          trimMode: TrimMode.Line,
                          lessStyle: const TextStyle(
                              color: secondaryColor, fontSize: 12),
                          moreStyle: const TextStyle(
                              color: secondaryColor, fontSize: 12),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FirebaseAuth.instance.currentUser!.uid ==
                                    widget.uid
                                ? FollowButton(
                                    label: 'Sign-Out',
                                    backgroundColor:
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey.shade900
                                            : Colors.grey.shade300,
                                    borderColor: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey.shade900
                                        : Colors.grey.shade300,
                                    textColor: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    onPressed: () async {
                                      await FirestoreMethods()
                                          .updateStatus('Offline');
                                      await AuthMethods().signOut();

                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen(),
                                          ),
                                          (route) => false);
                                    },
                                  )
                                : isFollowing
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: FollowButton(
                                              label: 'Unfollow',
                                              backgroundColor: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.grey.shade900
                                                  : Colors.grey.shade300,
                                              borderColor: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.grey.shade900
                                                  : Colors.grey.shade300,
                                              textColor: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                              onPressed: () async {
                                                await FirestoreMethods()
                                                    .followUser(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        userData['uid']);
                                                setState(() {
                                                  isFollowing = false;
                                                  followers--;
                                                });
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: FollowButton(
                                              label: 'Message',
                                              backgroundColor: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.grey.shade900
                                                  : Colors.grey.shade300,
                                              borderColor: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.grey.shade900
                                                  : Colors.grey.shade300,
                                              textColor: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                              onPressed: () async {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MessageScreen(
                                                      user: userData['uid'],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : FollowButton(
                                        label: 'Follow',
                                        backgroundColor: blueColor,
                                        borderColor: blueColor,
                                        textColor: Colors.white,
                                        onPressed: () async {
                                          await FirestoreMethods().followUser(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              userData['uid']);
                                          setState(
                                            () {
                                              isFollowing = true;
                                              followers++;
                                            },
                                          );
                                        },
                                      ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return circularIndicator(context);
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PostDetailScreen(post: data),
                              ),
                            );
                          },
                          child: Image(
                            image: NetworkImage(
                              data['postUrl'],
                            ),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                )
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
