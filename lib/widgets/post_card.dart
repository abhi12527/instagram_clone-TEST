// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/models/user.dart';
import '/provider/user_provider.dart';
import '/resources/firestore_methods.dart';
import '/screens/comment_screen.dart';
import '/utils/colors.dart';
import '/utils/global_vairable.dart';
import '/widgets/like_animation.dart';

class PostCard extends StatefulWidget {
  final post;
  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLength = 0;
  @override
  void initState() {
    super.initState();
    getComment();
  }

  getComment() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.post['postId'])
          .collection('comments')
          .get();

      commentLength = snap.docs.length;
    } on Exception catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).user;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          //Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.post['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    (user.uid == widget.post['uid']
                                        ? 'Delete'
                                        : 'Do Nothing'),
                                    'Close'
                                  ]
                                      .map((e) => Column(
                                            children: [
                                              e != 'Delete' && e != 'Do Nothing'
                                                  ? const Divider()
                                                  : Container(),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: GestureDetector(
                                                  onTap: e == 'Delete'
                                                      ? () async {
                                                          Navigator.pop(
                                                              context);
                                                          await FirestoreMethods()
                                                              .deletePost(widget
                                                                      .post[
                                                                  'postId']);
                                                        }
                                                      : () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                  child: Center(
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 12,
                                                        horizontal: 16,
                                                      ),
                                                      child: Text(
                                                        e,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.more_vert_rounded),
                ),
              ],
            ),
            // IMAGE SECTION
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                widget.post['postId'],
                user.uid,
                widget.post['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 3),
                  child: Image.network(
                    widget.post['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 100),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 200),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Like Comment
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.post['likes'].contains(user.uid),
                smallLike: true,
                child: _footerButton(
                  child: widget.post['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_outline,
                          color: Colors.white,
                        ),
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                      widget.post['postId'],
                      user.uid,
                      widget.post['likes'],
                    );
                  },
                ),
              ),
              _footerButton(
                child: SvgPicture.asset(
                  commentIcon,
                  color: Colors.white,
                  height: 20,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommentsSceeen(
                      snap: widget.post,
                    ),
                  ),
                ),
              ),
              _footerButton(
                child: SvgPicture.asset(
                  sendIcon,
                  color: Colors.white,
                  height: 20,
                ),
                onPressed: () {},
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: _footerButton(
                    child: const Icon(Icons.bookmark_border),
                    onPressed: () {},
                  ),
                ),
              )
            ],
          ),
          // Desciption

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.post['likes'].length} likes',
                    // style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(
                          color: primaryColor,
                        ),
                        children: [
                          TextSpan(
                            text: widget.post['username'] + ' ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: widget.post['description'])
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'View all $commentLength Comments',
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(DateTime.parse(
                            widget.post['datePublished'].toString()))
                        .toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Padding _footerButton({
    required Widget child,
    required Function()? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
      child: GestureDetector(
        onTap: onPressed,
        child: child,
      ),
    );
  }
}
