// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:chat_app/colors/theam_color.dart';
import 'package:chat_app/constants/ui_text_style.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/screens/start_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpleshScreen extends StatefulWidget {
  const SpleshScreen({super.key});

  @override
  State<SpleshScreen> createState() => _SpleshScreenState();
}

class _SpleshScreenState extends State<SpleshScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString("uid") ?? "";
      if (uid.isEmpty) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const StartPage()));
      } else {
        DocumentSnapshot documentSnapshot =
            await _db.collection('users').doc(uid).get();
        if (documentSnapshot.exists) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const StartPage()));
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorManager.white,
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Text(
            "Chat",
            style: getBoldStyle(color: ColorManager.primary, fontSize: 40),
          ),
        ),
      ),
    );
  }
}
