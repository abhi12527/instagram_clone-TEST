import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/models/user.dart';
import 'package:insta_clone/provider/user_provider.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/global_vairable.dart';
import 'package:insta_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final post;
  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

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
                        return ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          children: ['Delete']
                              .map((e) => GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.45),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 16,
                                            ),
                                            child: Text(e),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
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
            onDoubleTap: () {
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
                    child: _footerButton(
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 120,
                      ),
                      onPressed: () {},
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
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  onPressed: () {},
                ),
              ),
              _footerButton(
                child: SvgPicture.asset(
                  commentIcon,
                  color: Colors.white,
                  height: 20,
                ),
                onPressed: () {},
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
                  child: const Text(
                    'View all 200 Comments',
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
                        .format(DateTime.parse(widget.post['datePublished']))
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
