import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/models/comment.dart';
import 'package:insta_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  uploadPost(
    String uid,
    String description,
    String username,
    String profImage,
    Uint8List file,
  ) async {
    String res = 'Something went wrong';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(post.toMap());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        Comment comment = Comment(
            profilePic: profilePic,
            text: text,
            uid: uid,
            name: name,
            commentId: commentId,
            datePublished: DateTime.now(),
            likes: []);
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .add(comment.toMap());
      } else {
        print('Text is Empty');
      }
    } catch (e) {}
  }
}
