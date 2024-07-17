// ignore_for_file: unused_field, avoid_print

import 'package:chat_app/auth/email_auth.dart';
import 'package:chat_app/auth/google_auth.dart';
import 'package:chat_app/colors/theam_color.dart';
import 'package:chat_app/constants/ui_fonts.dart';
import 'package:chat_app/constants/ui_spacing.dart';
import 'package:chat_app/constants/ui_string.dart';
import 'package:chat_app/constants/ui_text_style.dart';
import 'package:chat_app/services/db_services.dart';
import 'package:chat_app/widget/get_button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GoogleAuth _googleAuth = GoogleAuth();

  final EmailAuth _emailAuth = EmailAuth();

  final DBServices _dbServices = DBServices();

  String? snackBarText;

  bool? isEmail;
  String? uid;
  String? _email;
  String? _pwd;

  Future<void>? getPrefData() async {
    await Future.delayed(const Duration(seconds: 5), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      uid = prefs.getString("uid");
      _email = prefs.getString("email");
      _pwd = prefs.getString("pwd");
    });
    print("Hey $uid");
  }

  @override
  void initState() {
    getPrefData();

    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: AppMargin.m85,
              ),
              const Center(
                  child: SizedBox(width: AppSize.s100, height: AppSize.s100)),
              const SizedBox(
                height: AppMargin.m110,
              ),

              Center(
                child: Text(
                  AppStrings.verificationScreenText1,
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                      color: ColorManager.textColor, fontSize: FontSize.s20),
                ),
              ),
              const SizedBox(
                height: AppSize.s8,
              ),
              Center(
                child: Text(
                  AppStrings.verificationScreenText2,
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                      color: ColorManager.textColor, fontSize: FontSize.s18),
                ),
              ),
              const SizedBox(
                height: AppSize.s20,
              ),
              //const Spacer(),

              GetButtonWidget(
                onPressed: () async {
                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _email!, password: _pwd!)
                      .then((authUser) async {
                    if (authUser.user!.emailVerified) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/homescr', (route) => false);
                    } else {
                      snackBarText = AppStrings.verifyMailErrorMessageText;
                      print(snackBarText);
                      ScaffoldMessenger.of(context).showSnackBar(
                        getSnackBar(snackBarText!, context),
                      );
                    }
                  });
                },
                btnText: AppStrings.verificationScreenButtonText,
                btnColor: ColorManager.primary,
                btnTextColor: ColorManager.white,
              ),

              const SizedBox(
                height: AppSize.s18,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.verificationScreenText3,
                      style: getRegularStyle(
                          color: ColorManager.hintTextColor,
                          fontSize: FontSize.s14),
                    ),
                    TextButton(
                      onPressed: () {
                        _emailAuth.verifyEmail();
                      },
                      child: Text(
                        AppStrings.verificationScreenTextButtonText,
                        style: getSemiBoldStyle(
                            color: ColorManager.textColor,
                            fontSize: FontSize.s14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
