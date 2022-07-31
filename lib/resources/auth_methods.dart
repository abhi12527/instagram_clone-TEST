// ignore_for_file: unnecessary_null_comparison

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/models/user.dart';
import '/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List? file,
  }) async {
    String res = 'Some error Occurred';

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file!, false);
        res = 'Success';
        UserModel userModel = UserModel(
          username: username,
          uid: user.user!.uid,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
          follower: [],
          following: [],
        );
        await _firestore
            .collection('users')
            .doc(user.user!.uid)
            .set(userModel.toMap());
      } else {
        res = 'Input all the Fields';
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  loginUser({required String email, required String password}) async {
    String res = 'Some error Occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'success';
      } else {
        res = "Please Enter all the Fields";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    UserModel user = UserModel.fromMap(snap.data() as Map<String, dynamic>);
    return user;
  }
}
