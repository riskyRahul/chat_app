// ignore_for_file: avoid_print
import 'package:animate_do/animate_do.dart';
import 'package:chat_app/auth/google_auth.dart';
import 'package:chat_app/colors/theam_color.dart';
import 'package:chat_app/constants/ui_images.dart';
import 'package:chat_app/constants/ui_spacing.dart';
import 'package:chat_app/constants/ui_text_style.dart';
import 'package:chat_app/screens/auth/login_page.dart';
import 'package:chat_app/screens/auth/register_page.dart';
import 'package:chat_app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final GoogleAuth _googleAuth = GoogleAuth();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 64, right: 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FadeInDown(
                    child: Container(
                      margin: const EdgeInsets.only(top: AppMargin.m85),
                      height: AppSize.s108,
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.s20,
                    width: double.infinity,
                  ),
                  FadeInLeft(
                      child: Text(
                    'Welcome in Chat App',
                    style: getSemiBoldStyle(
                        color: ColorManager.textColor, fontSize: 24),
                  )),
                  const SizedBox(
                    height: AppSize.s10,
                    width: double.infinity,
                  ),
                  FadeInLeft(
                      child: Text(
                    'Welcome back! Please enter your details.',
                    style: getRegularStyle(
                        color: ColorManager.hintTextColor, fontSize: 14),
                  )),
                  const SizedBox(
                    height: AppSize.s40,
                    width: double.infinity,
                  ),
                  FadeInLeft(
                    child: Button.primaryButton(
                        child: Center(
                          child: Text(
                            "Login",
                            style: getSemiBoldStyle(
                                color: ColorManager.white, fontSize: 16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        }),
                  ),
                  const SizedBox(
                    height: AppSize.s30,
                    width: double.infinity,
                  ),
                  FadeInLeft(
                    child: Button.secondaryButton(
                        child: Center(
                          child: Text(
                            "Sign up",
                            style: getSemiBoldStyle(
                                color: ColorManager.primary, fontSize: 16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterScreen()));
                        }),
                  ),
                  const SizedBox(
                    height: AppSize.s30,
                    width: double.infinity,
                  ),
                  customDivider(),
                  const SizedBox(
                    height: AppSize.s30,
                    width: double.infinity,
                  ),
                  ValueListenableBuilder(
                    valueListenable: GoogleAuth.userCredential,
                    builder: (context, value, child) {
                      return (GoogleAuth.userCredential.value == '' ||
                              GoogleAuth.userCredential.value == null)
                          ? FadeInLeft(
                              child: Button.secondaryButton(
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                            IconsAssets.googlelogo),
                                        const SizedBox(width: AppSize.s8),
                                        Text(
                                          "Continue with Google",
                                          style: getSemiBoldStyle(
                                              color: ColorManager.primary,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onPressed: () async {
                                    GoogleAuth.userCredential.value =
                                        await _googleAuth
                                            .registerWithGoogle(context);
                                    if (GoogleAuth.userCredential.value == '' ||
                                        GoogleAuth.userCredential.value ==
                                            null) {
                                      print("somthing wrong...");
                                    } else {
                                      print(GoogleAuth
                                          .userCredential.value.user!.email);
                                    }
                                  }),
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                  color: ColorManager.primary, value: .5),
                            );
                    },
                  ),
                  const SizedBox(
                    height: AppSize.s20,
                    width: double.infinity,
                  ),
                  // Platform.isIOS ? FadeInLeft(
                  //     child: Button.secondaryButton(
                  //         child: Center(
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               SvgPicture.asset(IconsAssets.applelogo),
                  //               const SizedBox(width: AppSize.s8),
                  //               Text(
                  //                 "Continue with Apple",
                  //                 style: getSemiBoldStyle(
                  //                     color: ColorManager.primary, fontSize: 16),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         onPressed: () {
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) =>
                  //                       const CongratulationsScreen()));
                  //         }),
                  //   ):const SizedBox(),
                ]),
          ),
        ],
      ),
    );
  }

  Row customDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: ColorManager.grey2,
            thickness: 0.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Or',
            style: getSemiBoldStyle(color: ColorManager.hintTextColor),
          ),
        ),
        Expanded(
          child: Divider(
            color: ColorManager.grey2,
            thickness: 0.5,
          ),
        ),
      ],
    );
  }
}
