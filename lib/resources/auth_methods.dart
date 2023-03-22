import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram/models/users.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:instagram/utils/utils.dart';
import 'package:logger/logger.dart';

import '../screens/profile_screen.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods _storage = StorageMethods();
  Logger logger = Logger(printer: PrettyPrinter(colors: true));

  String res = '';

  // sign up user
  signUpUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      Uint8List? file,
      required BuildContext context}) async {
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        // Using email and password for the user credentials
        UserCredential _userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        String userId = _userCredential.user!.uid;

        String photoUrl =
            await _storage.uploadImageToStorage('profilePics', file!, false);

        UserModel user = UserModel(
          id: userId,
          bio: bio,
          email: email,
          followers: [],
          following: [],
          username: username,
          photoUrl: photoUrl,
        );

        // For registration of the user
        var registerUser = await _firestore
            .collection('users')
            .doc()
            .set(user.toJson())
            .whenComplete(() {
          logger.d(
              'User with userId : $userId and username $username is created successfully');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileScreen(),
            ),
          );
        }).onError((error, stackTrace) => logger.d(
                'The error occurred during registered user is $error and it occured at $stackTrace'));
        res = 'success';
      }
    } on FirebaseAuthException catch (err) {
      res = err.toString();
      Fluttertoast.showToast(msg: res);
    } catch (e) {
      res = e.toString();
      Fluttertoast.showToast(msg: res);
    }
    return res;
  }

  loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      logger.d('Email is $email && password is $password');
      var authenticateUser = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .onError(
        (error, stackTrace) {
          return showSnackBar(error.toString(), context);
        },
      ).then((value) => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ProfileScreen())));
      // showSnackBar(loginUserSuccessFull, context);
    } catch (e) {
      logger.e(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
