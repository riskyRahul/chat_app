// ignore_for_file: avoid_print, use_build_context_synchronously, deprecated_member_use, no_leading_underscores_for_local_identifiers

import 'package:chat_app/constants/ui_string.dart';
import 'package:chat_app/constants/ui_text_style.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAuth {
  static ValueNotifier userCredential = ValueNotifier('');
  static ValueNotifier userRegisterCredential = ValueNotifier('');
  final GoogleSignIn googleSignIn = GoogleSignIn();
  static String? snackBarText;
  UserModel? userModelFootball;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<String>? signInMethods;
  static bool? docFlag;
  String? docID;

  SnackBar getSnackBar(String val, BuildContext context) {
    return SnackBar(
      content: Text(
        val,
        style: getSemiBoldStyle(color: Colors.red),
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          right: 20,
          left: 20),
    );
  }
  // bool errorHappened = false;
  // Future<dynamic> signInWithGoogle(BuildContext context) async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //     //print(googleUser?.email);
  //     //String holder = await checkSignInMethods(googleUser?.email);
  //     //print(await FirebaseAuth.instance
  //     //  .fetchSignInMethodsForEmail(googleUser!.email));
  //     //print("Holder $holder");
  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;
  //     String? em = googleUser?.email;
  //     print("ID $em");
  //     var a = await _db.collection("users").where('email', isEqualTo: em).get();
  //     if (a.size == 1) {
  //       var snap = a.docs[0];
  //       docID = snap.reference.id;
  //     }
  //     if (docID != null) {
  //       final credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth?.accessToken,
  //         idToken: googleAuth?.idToken,
  //       );
  //       //print(credential.signInMethod);
  //       if (credential.idToken != null || credential.accessToken != null) {
  //         print(FirebaseAuth.instance.currentUser?.email);
  //         //FirebaseAuth.instance.currentUser?.reload();
  //         String? id = FirebaseAuth.instance.currentUser?.uid;
  //         print("UID $id");
  //         return await FirebaseAuth.instance
  //             .signInWithCredential(credential)
  //             .then((value) async {
  //           User user = value.user!;
  //           SharedPreferences prefs = await SharedPreferences.getInstance();
  //           prefs.setString("uid", user.uid);
  //           Navigator.pushReplacementNamed(context, '/homescr');
  //           return value;
  //         });
  //       }
  //     } else {
  //       snackBarText = AppStrings.emailNotFoundErrorMessageText;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         getSnackBar(snackBarText!, context),
  //       );
  //       await googleSignIn.signOut();
  //       return null;
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     snackBarText = AppStrings.emailNotFoundErrorMessageText;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       getSnackBar(e.message!, context),
  //     );
  //     print('exception->$e');
  //   }
  // }

  Future<dynamic> registerWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      String? em = googleUser?.email;
      print("ID $em");
      var a = await _db.collection("users").where('email', isEqualTo: em).get();
      if (a.size == 0) {
        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
        //print(credential.signInMethod);
        if (credential.idToken != null || credential.accessToken != null) {
          print(FirebaseAuth.instance.currentUser?.email);
          return await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            User user = value.user!;
            userModelFootball = UserModel(
                uid: user.uid,
                email: user.email,
                displayName: user.displayName,
                phoneNumber: user.phoneNumber,
                photoURL: user.photoURL,
                isEmailVerified: user.emailVerified);
            print("UID ${userModelFootball!.uid}");
            await _db
                .collection("users")
                .doc(user.uid)
                .set(userModelFootball!.toMap());
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("uid", user.uid);
            Navigator.pushReplacementNamed(context, '/homescr');
            return value;
          });
        }
      } else {
        var snap = a.docs[0];
        docID = snap.reference.id;
        print("HEy my ID $docID");
        if (docID != null) {
          final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth?.accessToken,
              idToken: googleAuth?.idToken);
          if (credential.idToken != null || credential.accessToken != null) {
            print(FirebaseAuth.instance.currentUser?.email);
            //FirebaseAuth.instance.currentUser?.reload();
            String? id = FirebaseAuth.instance.currentUser?.uid;
            print("UID $id");
            return await FirebaseAuth.instance
                .signInWithCredential(credential)
                .then((value) async {
              User user = value.user!;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("uid", user.uid);
              Navigator.pushReplacementNamed(context, '/homescr');
              return value;
            });
          }
        } else {
          snackBarText = AppStrings.emailNotFoundErrorMessageText;
          ScaffoldMessenger.of(context).showSnackBar(
            getSnackBar(snackBarText!, context),
          );
          await googleSignIn.signOut();
          return null;
        }
      }
    } on FirebaseAuthException catch (e) {
      print('exception->$e');
    }
  }

  checkSignInMethods(String? email) async {
    try {
      if (email != null) {
        signInMethods =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
        print(signInMethods);
        if (signInMethods != null) {
          if (signInMethods!.isNotEmpty) {
            switch (signInMethods!.first) {
              case 'google.com':
                print(signInMethods!.first);
                return "G";
              case 'password':
                // since password is managed by user we force have email provider only
                return "P";
            }
          } else {
            return "E";
          }
        }
      }
    } on FirebaseAuthException catch (error) {
      print(error.message);
    }
  }

  Future<bool> signOutFromGoogle() async {
    try {
      await googleSignIn.signOut();
      // await googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future deleteUser() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      User user = _auth.currentUser!;
      // called from database class
      await user.delete();
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
