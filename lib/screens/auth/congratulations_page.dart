import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:chat_app/colors/theam_color.dart';
import 'package:chat_app/constants/ui_images.dart';
import 'package:chat_app/constants/ui_spacing.dart';
import 'package:chat_app/constants/ui_text_style.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CongratulationsScreen extends StatefulWidget {
  const CongratulationsScreen({super.key});
  @override
  State<CongratulationsScreen> createState() => _CongratulationsScreenState();
}

class _CongratulationsScreenState extends State<CongratulationsScreen> {
  @override
  void initState() {
        Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomePage())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInDown(
                    child: SizedBox(
                      height: AppSize.s230,
                      child: SvgPicture.asset(IconsAssets.conguratIcon),
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.s14,
                    width: double.infinity,
                  ),
                  FadeInLeft(
                      child: Text(
                    'Congratulations',
                    style: getSemiBoldStyle(
                        color: ColorManager.textColor,
                        fontSize: 20),
                  )),
                  const SizedBox(
                    height: AppSize.s8,
                    width: double.infinity,
                  ),
                  FadeInRight(
                      child: Text(
                    'Your account is ready to use. You will be redirected to the home page in a few seconds',
                    textAlign: TextAlign.center,
                    style: getRegularStyle(
                        color: ColorManager.hintTextColor,
                        fontSize: 14),
                  )),
                ]),
          ),
        ],
      ),
    );
  }
}