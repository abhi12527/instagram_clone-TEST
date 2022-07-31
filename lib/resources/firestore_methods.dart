import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
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
}
