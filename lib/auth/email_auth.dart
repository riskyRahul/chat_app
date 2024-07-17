// ignore_for_file: unused_local_variable, body_might_complete_normally_nullable, avoid_print, use_build_context_synchronously, deprecated_member_use

import 'package:chat_app/constants/ui_string.dart';
import 'package:chat_app/constants/ui_text_style.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailAuth {
  static String? snackBarText;
  static ValueNotifier emailUserCredential = ValueNotifier('');
  static ValueNotifier loginEmailUserCredential = ValueNotifier('');

  static bool? emlVerified;
  static bool? val = false;
  static bool? verifiedEmail;

  List<String>? signInMethods;
  UserModel? userModelFootball;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  SnackBar getSnackBar(String val, BuildContext context) {
    return SnackBar(
      content: Text(
        val,
        style: getSemiBoldStyle(color: Colors.red),
      ),
      backgroundColor: Colors.white,
       behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          right: 20,
          left: 20),
    );
  }

  Future<dynamic> register(
      String? email, String? password, BuildContext context) async {
    try {
      return await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!)
          .then((authCredential) async {

        bool isEmailVerified =  authCredential.user!.emailVerified;

        verifyEmail();

        Navigator.pushNamedAndRemoveUntil(context, '/evs', (route) => false);

        /*await _db
            .collection("users")
            .doc(user.uid)
            .set(userModelFootball!.toMap());*/

        return authCredential;
      });
    } on FirebaseAuthException catch (firebaseAuthException) {
      print("Exception: ${firebaseAuthException.code}");
      if (firebaseAuthException.code == 'email-already-in-use') {
        snackBarText = AppStrings.emailRegErrorMessageText;
        ScaffoldMessenger.of(context).showSnackBar(
          getSnackBar(snackBarText!, context),
        );
        // ScaffoldMessenger.of(context).showSnackBar(
        // getSnackBar(snackBarText!, context),
        // );
      }
    }
  }

  Future<User?>? verifyEmail() async {
    await FirebaseAuth.instance.currentUser?.reload();
    if (!FirebaseAuth.instance.currentUser!.emailVerified) {
      try {
        await FirebaseAuth.instance.currentUser
            ?.sendEmailVerification()
            .then((value) async{
          val = true;
        // User user= FirebaseAuth.instance.currentUser!;
          // ScaffoldMessenger.of(emailContext)
          //   .showSnackBar(getSnackBar(snackBarText!, emailContext));
        });
        return FirebaseAuth.instance.currentUser;
      } on FirebaseAuthException catch (e) {
        print(e.message);
      }
    }
  }

  emailLogin(String? email, String? password, BuildContext context) async {
    //login_type.value = 'E';
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!)
          .then((authUser) async {
        //await Future.delayed(Duration(seconds: 1));
        if (authUser.user!.emailVerified) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("uid", authUser.user!.uid);
          Navigator.pushReplacementNamed(context, '/homescr');
          verifiedEmail = true;
        } else {
          verifiedEmail = false;
        }
        return authUser;
        /* else {
          Get.snackbar('Verification mail has been sent',
              'Please verify your mail by clicking on the link ',
              snackPosition: SnackPosition.BOTTOM);
        } */
      });
    } on FirebaseAuthException catch (firebaseAuthException) {
      print("Code: ${firebaseAuthException.code}");
      if (firebaseAuthException.code == 'user-not-found') {
        snackBarText = AppStrings.emailNotFoundErrorMessageText;
        ScaffoldMessenger.of(context).showSnackBar(
          getSnackBar(snackBarText!, context),
        );
      } else if (firebaseAuthException.code == 'invalid-credential') {
        snackBarText = AppStrings.pwdErrorMessageText;
        ScaffoldMessenger.of(context).showSnackBar(
          getSnackBar(snackBarText!, context),
        );
      } else if (firebaseAuthException.code == 'too-many-requests') {
        snackBarText = AppStrings.reqErrorMessageText;
        ScaffoldMessenger.of(context).showSnackBar(
          getSnackBar(snackBarText!, context),
        );
      } else {
        snackBarText = AppStrings.generalErrorMessageText;
        ScaffoldMessenger.of(context).showSnackBar(
          getSnackBar(snackBarText!, context),
        );
      }
    }
  }

  sendPasswordResetEmail(String? email, BuildContext context) async {
    var a =
        await _db.collection("users").where('email', isEqualTo: email).get();
    if (a.size == 1) {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email!)
          .then((value) {
        snackBarText = AppStrings.forgotPwdSentText;
        ScaffoldMessenger.of(context).showSnackBar(
          getSnackBar(snackBarText!, context),
        );
        Navigator.of(context).pop();
      }).catchError((onError) {
        print(onError.toString());
      });
    } else {
      snackBarText = AppStrings.emailNotFoundErrorMessageText;
      ScaffoldMessenger.of(context).showSnackBar(
        getSnackBar(snackBarText!, context),
      );
    }
  }

  Future<String?> checkSignInMethods(String? email) async {
    try {
      print(email);
      if (email != null) {
        signInMethods =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
        print(signInMethods);
        if (signInMethods != null) {
          if (signInMethods!.isNotEmpty) {
            print(signInMethods!.first);
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

  // just some extra error covering
  Future linkProvider(BuildContext context, credential) async {
    try {
      if (signInMethods != null && signInMethods!.isNotEmpty) {
        if (signInMethods!.length > 1) {
          print(signInMethods);
          await FirebaseAuth.instance.currentUser
              ?.linkWithCredential(credential);
        }
      }
    } on FirebaseAuthException catch (e) {
      print("${e.code}  ${e.message}");
    }
  }

  Future<String?> changePassword(String password) async {
    //Create an instance of the current user.
    User user =  FirebaseAuth.instance.currentUser!;
    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_) {
      return "Successfully changed password";
    }).catchError((error) {
      return ("Password can't be changed");
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }
}
