// ignore_for_file: unused_local_variable, body_might_complete_normally_nullable, avoid_print, use_build_context_synchronously, deprecated_member_use

import 'package:chat_app/constants/ui_string.dart';
import 'package:chat_app/constants/ui_text_style.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/db_services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneAuth {
  static String? snackBarText;
  static ValueNotifier emailUserCredential = ValueNotifier('');
  static ValueNotifier loginEmailUserCredential = ValueNotifier('');

  static bool? emlVerified;
  static bool? val = false;
  static bool? verifiedEmail;

  List<String>? signInMethods;
  UserModel? userModelFootball;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DBServices _dbServices = DBServices();
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

  Future<void> phoneVerify(
      {required BuildContext context,
      required String phone,
      required String fullPhoneNumber,
      required Function(String, int?) codeSent,
      required Function(String) codeAutoRetrievalTimeout,
      required Function(FirebaseAuthException) verificationFailed,
      required Function(PhoneAuthCredential) verificationCompleted}) async {
    print("########################");
    print(phone);
    var a = await _db
        .collection("users")
        .where('phoneNumber', isEqualTo: phone)
        .get();
    if (a.size == 1) {
      if (kIsWeb) {
        await _auth.signInWithPhoneNumber(phone);
      } else {
        await _auth.verifyPhoneNumber(
          phoneNumber: fullPhoneNumber,
          timeout: const Duration(seconds: 30),
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        );
      }
    } else {
      snackBarText = AppStrings.mobileNotFoundErrorMessageText2;
      ScaffoldMessenger.of(context).showSnackBar(
        getSnackBar(snackBarText!, context),
      );
    }
  }

  Future<void> phoneVerifyForProfile(
      {required BuildContext context,
      required String phone,
      required String fullPhoneNumber,
      required Function(String, int?) codeSent,
      required Function(String) codeAutoRetrievalTimeout,
      required Function(FirebaseAuthException) verificationFailed,
      required Function(PhoneAuthCredential) verificationCompleted}) async {
    if (kIsWeb) {
      await _auth.signInWithPhoneNumber(phone);
    } else {
      await _auth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        timeout: const Duration(seconds: 30),
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    }
  }

  Future<void> signInWithPhoneNumber(
      {required BuildContext context,
      required String otp,
      required String phone,
      required String verificationId}) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      final User? user = (await _auth.signInWithCredential(credential)).user;
      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('phoneNumber', isEqualTo: phone)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          prefs.setString("uid", querySnapshot.docs.last.id.toString());
        } else {
          print("No matching documents.");
        }
        Navigator.pushReplacementNamed(context, '/homescr');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          getSnackBar("Invalid OTP. Please try again.", context),
        );
      }
      final User currentUser = _auth.currentUser!;
      assert(user!.uid == currentUser.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        ScaffoldMessenger.of(context).showSnackBar(
          getSnackBar("Invalid OTP. Please try again.", context),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          getSnackBar(
              "Authentication failed. Please try again later.", context),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signInWithPhoneNumberForProfile(
      {required BuildContext context,
      required String otp,
      required UserModel userModel,
      required String verificationId}) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      final User? user = (await _auth.signInWithCredential(credential)).user;
      if (user != null) {
        bool status = await _dbServices.editUserDataToDB(userModel.toMap());
        if (status) {
         Get.back();
         Get.back();
          ScaffoldMessenger.of(context)
              .showSnackBar(getSnackBar("change successfully", context));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(getSnackBar("somthing wrong", context));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          getSnackBar("Invalid OTP. Please try again.", context),
        );
      }
      final User currentUser = _auth.currentUser!;
      assert(user!.uid == currentUser.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        ScaffoldMessenger.of(context).showSnackBar(
          getSnackBar("Invalid OTP. Please try again.", context),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          getSnackBar(
              "Authentication failed. Please try again later.", context),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
